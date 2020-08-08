USE giving_assistant;

INSERT INTO Categories (`id`, `parent_id`, `name`) VALUES
('cc62809e-d9a2-11ea-80b6-0242ac110002', NULL, 'Root'),
('e087049c-d9a2-11ea-80b6-0242ac110002', 'cc62809e-d9a2-11ea-80b6-0242ac110002', 'Shoes'),
('e0870757-d9a2-11ea-80b6-0242ac110002', 'cc62809e-d9a2-11ea-80b6-0242ac110002', 'Electronics'),
('fd3e5c44-d9a2-11ea-80b6-0242ac110002', 'cc62809e-d9a2-11ea-80b6-0242ac110002', 'Clothing');

INSERT INTO Merchants (`id`, `category_id`, `name`) VALUES
('9f5a5e0f-d9ba-11ea-80b6-0242ac110002', 'e087049c-d9a2-11ea-80b6-0242ac110002', 'Nike'),
('5468df6d-d9a3-11ea-80b6-0242ac110002', 'e0870757-d9a2-11ea-80b6-0242ac110002', 'Apple'),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'fd3e5c44-d9a2-11ea-80b6-0242ac110002', 'H&M'),
('d88c0576-d9b9-11ea-80b6-0242ac110002', 'fd3e5c44-d9a2-11ea-80b6-0242ac110002', 'Forever 21'),
('e9d16c8c-d9b9-11ea-80b6-0242ac110002', 'fd3e5c44-d9a2-11ea-80b6-0242ac110002', 'GAP'),
('1805de8a-d9ba-11ea-80b6-0242ac110002', 'fd3e5c44-d9a2-11ea-80b6-0242ac110002', 'The North Face');

INSERT INTO MerchantLogos (`merchant_id`, `url`) VALUES
('9f5a5e0f-d9ba-11ea-80b6-0242ac110002', 'https://cdn.givingassistant.org/images/logo.svg'),
('5468df6d-d9a3-11ea-80b6-0242ac110002', 'https://cdn.givingassistant.org/images/logo.svg'),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'https://cdn.givingassistant.org/images/logo.svg'),
('d88c0576-d9b9-11ea-80b6-0242ac110002', 'https://cdn.givingassistant.org/images/logo.svg'),
('e9d16c8c-d9b9-11ea-80b6-0242ac110002', 'https://cdn.givingassistant.org/images/logo.svg'),
('1805de8a-d9ba-11ea-80b6-0242ac110002', 'https://cdn.givingassistant.org/images/logo.svg');

INSERT INTO MerchantShippingDetails (`merchant_id`, `content`) VALUES
('9f5a5e0f-d9ba-11ea-80b6-0242ac110002', 'Shipping'),
('5468df6d-d9a3-11ea-80b6-0242ac110002', 'Shipping Details'),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'Shipping policy'),
('d88c0576-d9b9-11ea-80b6-0242ac110002', 'Details'),
('e9d16c8c-d9b9-11ea-80b6-0242ac110002', 'Shipping'),
('1805de8a-d9ba-11ea-80b6-0242ac110002', 'Shipping policy');

INSERT INTO Campaigns (`id`, `merchant_id`, `name`, `date_start`, `date_end`) VALUES
('a6a4a530-d9a4-11ea-80b6-0242ac110002', '6649d2bf-d9b9-11ea-80b6-0242ac110002', 'Campaign 1', '2020-08-08 00:00:00', '2020-08-09 23:59:59'),
('d08a4db3-d9a4-11ea-80b6-0242ac110002', '6649d2bf-d9b9-11ea-80b6-0242ac110002', 'Campaign 2', '2020-08-10 00:00:00', NULL),
('f1ee6475-d9bb-11ea-80b6-0242ac110002', 'fd3e5c44-d9a2-11ea-80b6-0242ac110002', 'Campaign GAP', '2020-08-08 00:00:00', NULL);

INSERT INTO CashBackRates (`merchant_id`, `campaign_id`, `rate`, `date_start`, `date_end`) VALUES
('6649d2bf-d9b9-11ea-80b6-0242ac110002', NULL, 20, '2020-08-01 00:00:00', NULL),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'd08a4db3-d9a4-11ea-80b6-0242ac110002', 25, '2020-08-12 00:00:00', NULL),
('9f5a5e0f-d9ba-11ea-80b6-0242ac110002', NULL, 40, '2020-01-01 00:00:00', NULL),
('5468df6d-d9a3-11ea-80b6-0242ac110002', NULL, 15, '2020-01-01 00:00:00', NULL),
('d88c0576-d9b9-11ea-80b6-0242ac110002', NULL, 50, '2020-01-01 00:00:00', NULL),
('e9d16c8c-d9b9-11ea-80b6-0242ac110002', NULL, 20, '2020-01-01 00:00:00', NULL),
('1805de8a-d9ba-11ea-80b6-0242ac110002', NULL, 20, '2020-01-01 00:00:00', NULL);

INSERT INTO MerchantVisits (`merchant_id`, `user_id`, `track_id`, `created_at`) VALUES
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'a7c3914b-d9bd-11ea-80b6-0242ac110002', 'a', NOW()),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'b452cbeb-d9bd-11ea-80b6-0242ac110002', 'b', NOW()),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'ba87c17b-d9bd-11ea-80b6-0242ac110002', 'c', NOW()),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'c007ae9d-d9bd-11ea-80b6-0242ac110002', 'd', NOW()),
('6649d2bf-d9b9-11ea-80b6-0242ac110002', 'c547b653-d9bd-11ea-80b6-0242ac110002', 'e', NOW()),
('9f5a5e0f-d9ba-11ea-80b6-0242ac110002', 'ca4d6381-d9bd-11ea-80b6-0242ac110002', 'f', NOW()),
('9f5a5e0f-d9ba-11ea-80b6-0242ac110002', 'a7c3914b-d9bd-11ea-80b6-0242ac110002', 'g', NOW()),
('5468df6d-d9a3-11ea-80b6-0242ac110002', 'd0aefcbe-d9bd-11ea-80b6-0242ac110002', 'h', NOW()),
('1805de8a-d9ba-11ea-80b6-0242ac110002', 'a7c3914b-d9bd-11ea-80b6-0242ac110002', 'i', NOW()),
('1805de8a-d9ba-11ea-80b6-0242ac110002', 'd5b11e24-d9bd-11ea-80b6-0242ac110002', 'j', NOW()),
('1805de8a-d9ba-11ea-80b6-0242ac110002', 'b452cbeb-d9bd-11ea-80b6-0242ac110002', 'k', NOW());
