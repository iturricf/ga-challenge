CREATE DATABASE IF NOT EXISTS giving_assistant;

USE giving_assistant;

CREATE TABLE IF NOT EXISTS Categories (
    `id` char(36) NOT NULL,
    `parent_id` char(36) DEFAULT NULL,
    `name` varchar(100) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `categories_parent_id_idx` (`parent_id`)
);

CREATE TABLE IF NOT EXISTS Merchants (
    `id` char(36) NOT NULL,
    `category_id` char(36) NOT NULL,
    `name` varchar(100) NOT NULL,
    `about` text DEFAULT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `merchants_category_id_idx` (`category_id`),
    KEY `merchants_created_at_idx` (`created_at`)
);

CREATE TABLE IF NOT EXISTS MerchantLogos (
    `merchant_id` CHAR(36) NOT NULL,
    `type` enum('0', '1', '2') DEFAULT '0' COMMENT '0= For header, 1= For mobile, 2= For mailing',
    `url` text DEFAULT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `merchant_logos_merchant_id_idx` (`merchant_id`),
    KEY `merchant_logos_created_at_idx` (`merchant_id`)
);

CREATE TABLE IF NOT EXISTS MerchantShippingDetails (
    `merchant_id` char(36) NOT NULL,
    `content` text NOT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `merchant_shipping_details_merchant_id_idx` (`merchant_id`),
    KEY `merchant_shipping_details_created_at_idx` (`created_at`)
);

CREATE TABLE IF NOT EXISTS MerchantVisits (
    `merchant_id` char(36) NOT NULL,
    `user_id` char(36) NOT NULL,
    `track_id` text NOT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    KEY `merchant_visits_merchant_id_idx` (`merchant_id`),
    KEY `merchant_visits_user_id_idx` (`user_id`),
    KEY `merchant_visits_created_at_idx` (`created_at`)
);

CREATE TABLE IF NOT EXISTS Campaigns (
    `id` char(36) NOT NULL,
    `merchant_id` char(36) NOT NULL,
    `name` varchar(100) NOT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `date_start` datetime NOT NULL,
    `date_end` datetime DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `campaigns_merchant_id_idx` (`merchant_id`),
    KEY `campaigns_created_at_idx` (`created_at`),
    KEY `campaigns_date_start_idx` (`date_start`),
    KEY `campaigns_date_end_idx` (`date_end`)
);

CREATE TABLE IF NOT EXISTS CashBackRates (
    `merchant_id` char(36) NOT NULL,
    `campaign_id` char(36) DEFAULT NULL,
    `rate` int NOT NULL,
    `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `date_start` datetime NOT NULL,
    `date_end` datetime DEFAULT NULL,
    KEY `cash_back_rate_merchant_id_idx` (`merchant_id`),
    KEY `cash_back_rate_campaign_id_idx` (`campaign_id`),
    KEY `cash_back_rate_created_at_idx` (`created_at`),
    KEY `cash_back_rate_date_start_idx` (`date_start`),
    KEY `cash_back_rate_date_end_idx` (`date_end`)
);