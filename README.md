# Giving Assistant BE Challenge

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

1. Initialize a MySQL container

```bash
docker run --name ga_mysql_test -e MYSQL_ROOT_PASSWORD=password -d mysql:5.7
```

2. Load DB Schema

```bash
docker exec -i ga_mysql_test sh -c 'exec mysql -u root -p"password"' < db/db.sql
```

3. Load example data

```bash
docker exec -i ga_mysql_test sh -c 'exec mysql -u root -p"password"' < db/example_data.sql
```

4. Connect to MySQL DB and run example queries:

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