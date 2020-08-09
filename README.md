# Giving Assistant BE Challenge

*This repository contains code examples, please clone this repository in order to use them.*

In a first approach to the problem I have came up with a simple design that answer these questions:

1. Which category does this Merchant belong to?
2. Which are the shipping policies for this Merchant?
3. Which other Merchants belong to this Category?
4. What is the current cash back rate for this Merchant?
5. Is there any ongoing campaign for this Merchant?
6. Is there a special cash back rate for this Campaign?
7. Which other Merchants have ongoing campaigns at this moment?

## First Approach

![First approach](https://github.com/iturricf/ga-challenge/blob/master/db/first_approach.png?raw=true)

As this design shows, Merchants cash back rates have been normalized into a separate table, this way all cash back rates changes will be registered, and also rates that apply for Campaigns. Also, it will be possible to schedule cash back rates changes.

## Extended Design

![Extended design](https://github.com/iturricf/ga-challenge/blob/master/db/extended_design.png?raw=true)

Further Merchant data disaggregation is possible if it is needed to keep track of other changes over time. For instance: Merchant logos, Shipping details, Cash back rates breaktown for specific Merchant’s categories (external categories).

## Extra tables

![Extra tables](https://github.com/iturricf/ga-challenge/blob/master/db/extra_tables.png?raw=true)

Extra tables could be added, that help answering extra questions when running reports. For example, number of users that visited and shopped at stores.

### Considerations

- I have used UUIDs as primary keys as this would allow easier key generation mechanisms in a database sharding scenario.
- For a real application I would add further analysis for the indexes created on searchable columns. E.g: BTREE vs Hash.
- Usage of `enum` in MerchantLogos table is an example, this should be changed if possible values for the `type` column will change over time.

### Erratum

Please note ER Diagram relation notation in `MerchantShippingDetails`, `MerchantReturnPolicy`, `MerchantAdditionalInfo` and `MerchantVisits` is wrong, those should be many-to-one relationships.

---

## Examples

A db.sql file is provided with the proposed database schema and some example data, which I'll use to run some queries.

### Running Database (Docker required)

1. Clone this repository

2. Go to the recently created repository root directory

3. Initialize a MySQL container

```bash
docker run --name ga_mysql_test -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7
```

4. Load DB Schema

```bash
docker exec -i ga_mysql_test sh -c 'exec mysql -u root -p"password"' < db/db.sql
```

5. Load example data

```bash
docker exec -i ga_mysql_test sh -c 'exec mysql -u root -p"password"' < db/example_data.sql
```

6. Connect to MySQL DB and run example queries:

```bash
docker exec -it ga_mysql_test mysql -u root -p"password" giving_assistant
```

### Answering question using DB:

1. Which category does this Merchant belong to?
```sql
SELECT c.name FROM Merchants m INNER JOIN Categories c ON c.id = m.category_id
WHERE m.id = '1805de8a-d9ba-11ea-80b6-0242ac110002';
```

2. Which are the shipping policies for this Merchant?
```sql
SELECT ms.content FROM MerchantShippingDetails ms
WHERE ms.merchant_id = '1805de8a-d9ba-11ea-80b6-0242ac110002'
ORDER BY created_at DESC
LIMIT 1;
```

3. Which other Merchants belong to this Category?
```sql
SELECT m.id, m.name FROM Merchants m
WHERE m.category_id = 'fd3e5c44-d9a2-11ea-80b6-0242ac110002' 
AND m.id != '1805de8a-d9ba-11ea-80b6-0242ac110002'
ORDER BY m.name
LIMIT 5;
```

4. What is the current cash back rate for this Merchant?
```sql
SELECT r.rate FROM CashBackRates r
WHERE r.merchant_id = '6649d2bf-d9b9-11ea-80b6-0242ac110002'
ORDER BY created_at DESC
LIMIT 1;
```

Also the same question could be answered by looking at the `date_start` adn `date_end` columns

```sql
SELECT r.rate FROM CashBackRates r
WHERE r.merchant_id = '6649d2bf-d9b9-11ea-80b6-0242ac110002'
AND r.date_start <= '2020-08-07 10:35:07'
AND (r.date_end >= '2020-08-07 10:35:07' OR r.date_end IS NULL)
ORDER BY created_at DESC
LIMIT 1;
```

This could be used to ask for a rate in a certain date either in the future or in the past.

5. Is there any on-going campaign for this Merchant?

```sql
SELECT c.id, c.name FROM Campaigns c
WHERE c.merchant_id = '6649d2bf-d9b9-11ea-80b6-0242ac110002'
AND c.date_start <= NOW()
AND (c.date_end >= NOW() OR c.date_end IS NULL);
```

6. Is there a special cash back rate for this Campaign?

```sql
SELECT r.rate FROM CashBackRates r
WHERE r.campaign_id = 'd08a4db3-d9a4-11ea-80b6-0242ac110002'
ORDER BY r.created_at DESC
LIMIT 1;
```

7. Which other Merchants have on-going campaigns at this moment?

```sql
SELECT m.id, m.name FROM Merchants m
INNER JOIN Campaigns c ON m.id = c.merchant_id
WHERE c.date_start <= NOW()
AND (c.date_end >= NOW() OR c.date_end IS NULL);
```

---

# Some additional thoughts

## Several data sources providing similar information

There are different approaches for this issue, I can combine a couple and create some sort of `Data Intake Engine` that process different data sources.

A first step could be to identify the criticality of the data provided and assign a priority to each data source[1], this could be understood as a `trustworthiness index`, so that given a collection of data sources:

```
DS = {ds1, ds2, ..., dsn}
```

And a defined priority set corresponding to each data source:

```
P = {p1, p2, ..., pn}
```

in regards of certain attribute in the datasets, for instance: `cash_back_rate`.

Then retrieving the cash back rate from `DS` will be done as follow:

```
cash_back_rate = loadData('cash_back_rate', DS, P, maxPriority)
```

This will retrieve data from dataset whose has a higher priority value.

The previous approach could be an overkill in certain situations and for those cases I still could use `duplicate` and `similar text` calculation algorithms.

Having duplicate data increase redundancy which might be a sign that we are facing with correct data. So by creating an index on duplicate data coming from several data sources we could arrive the data that has a higher probability to be correct.

Also using a `similar text` approach by calculating the Levenshtein distance between two strings we could arrive to a similar solution.

### Receiving five different titles for the Merchant

In the case of receiving 5 different store names for the Merchant I created a simple service that will try to sort out this issue.

Considering the 5 store names as the input dataset I created the `SimpleDataResolver` service that analyze duplicate data and resolves the right value as the one that most repeats in the input dataset.

For a scenario where there is no duplicate data then I use a `similar text` search approach to guess the correct value.

This algorithm uses the Levenshtein distance, then by comparing the dataset values to each other and measuring the `distance` between them I create a similarity map. This maps each value in the input dataset to the most similar value found.

At the end, I take the similarity map as the new input dataset and repeat the duplicate data processing as described above.

This service will not work when input data set contains totally unrelated data.

### Code Example (Docker required)

A code example and its corresponding test were added in [src/DataIntake/SimpleDataResolver](https://github.com/iturricf/ga-challenge/blob/master/src/DataIntake/SimpleDataResolver.php) and [tests/SimpleDataResolverTest](https://github.com/iturricf/ga-challenge/blob/master/tests/SimpleDataResolverTest.php). Here is how to use it:

1. Clone this repository

2. Go to the recently created repository root directory

3. Run composer install

```bash
docker run --rm -it --volume $PWD:/app composer install
```

4. Run phpunit

```bash
docker run --rm -it --volume $PWD:/app composer ./vendor/bin/phpunit
```

### Some considerations

- The service could be improved by calculating the similarity map in several passes.
- Further analysis is required to use this for critical data.

## Ensuring data is readily and quicky available

According to the data modeling shown above, if a full Merchant record is required a SQL query like the following will be needed:

```sql
SELECT
    m.id
    m.category_id,
    m.name,
    m.about
    (SELECT ml.url FROM MerchantLogos ml WHERE ml.type = '0' AND ml.merchant_id = {MERCHANT_ID}
    ORDER BY ml.created_at DESC LIMIT 1) as header_logo,
    (SELECT ml.url FROM MerchantLogos ml WHERE ml.type = '1' AND ml.merchant_id = {MERCHANT_ID}
    ORDER BY ml.created_at DESC LIMIT 1) as mobile_logo,
    (SELECT ms.content FROM MerchantShippingDetails ms WHERE ms.merchant_id = {MERCHANT_ID}
    ORDER BY ms.created_at DESC LIMIT 1) as shipping_details,
    (SELECT cb.rate FROM CashBackRates cb WHERE cb.merchant_id = {MERCHANT_ID}
    AND cb.date_start <= NOW() AND (cb.date_end >= NOW() OR cb.date_end IS NULL)
    ORDER BY cb.created_at DESC LIMIT 1) as cash_back_rate
FROM Merchants m
WHERE m.id = {MERCHANT_ID}
LIMIT 1;
```

This query could be expensive and if we are looking support high concurrency traffic it would really help having a **cache** layer.

![Cache general](https://github.com/iturricf/ga-challenge/blob/master/db/cache_general.png?raw=true)

For this purpose I would use Redis so that whenever a Merchant record is required it will lookup the Redis cache first and try to hydrate a Merchant object from cached data.

![Cache detail](https://github.com/iturricf/ga-challenge/blob/master/db/cache_detail.png?raw=true)

If no data is associated to the merchant key then the above query will be run against the database server. The resulting data then will be used to hydrate a Merchant object. Also this data will be pushed to the Redis cache for future use.

## References

[1]. Ali, R.; Siddiqi, M. H.; Ahmed, M. I.; Ali, T.; Hussain, S.; Huh, E.; Kang, B.H.; Lee S. GUDM: Automatic Generation of Unified Datasets for Learning and Reasoning in Healthcare. Sensors 2015, 15, 15772-15798. 