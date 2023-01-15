-- Query Tables
SELECT * FROM card_holder;
SELECT * FROM credit_card;
SELECT * FROM merchant_category;
SELECT * FROM merchant;
SELECT * FROM transaction;

-- Drop views
DROP VIEW IF EXISTS cardholder_transaction CASCADE;
DROP VIEW IF EXISTS transaction_lessthan$2 CASCADE;
DROP VIEW IF EXISTS transaction_bw7and9 CASCADE;
DROP VIEW IF EXISTS fraud_transaction_bw7and9 CASCADE;
DROP VIEW IF EXISTS fraud_transaction_bw9and24 CASCADE;
DROP VIEW IF EXISTS fraud_transaction_bw0and7 CASCADE;
DROP VIEW IF EXISTS merchant_small_transaction CASCADE;


-- Question 1

-- Create a view for transactions of each cardholder
CREATE VIEW cardholder_transaction AS
SELECT 
c.name AS cardholder_name,
a.card AS creditcard_number,
a.amount AS amount,
a.date AS transaction_date
FROM transaction AS a, credit_card AS b, card_holder AS c
WHERE a.card = b.card AND
b.cardholder_id = c.id
GROUP BY a.id, b.card, c.id;

-- Query view cardholder_transaction
SELECT * FROM cardholder_transaction;

-- Create a view for number of transactions that are less than $2.00 per cardholder
CREATE VIEW transaction_lessthan$2 AS
SELECT cardholder_name, creditcard_number, COUNT(*) AS transaction_count
FROM cardholder_transaction
WHERE amount < 2.00
GROUP BY cardholder_name, creditcard_number
ORDER BY transaction_count DESC;

-- Query view transaction_lessthan$2
SELECT * FROM transaction_lessthan$2 ORDER by transaction_count DESC, cardholder_name LIMIT 10;


-- Question 2

-- Create a view for transactions between 7 am and 9 am
CREATE VIEW transaction_bw7and9 AS
SELECT 
d.name AS cardholder_name,
a.card AS creditcard_number,
b.name AS merchant_name,
e.name AS merchant_category,
a.amount,
a.date AS transaction_date
FROM transaction AS a, merchant AS b, credit_card AS c, card_holder AS d, merchant_category AS e
WHERE a.id_merchant = b.id AND
b.id_merchant_category = e.id AND
a.card = c.card AND
c.cardholder_id = d.id AND
CAST(date AS TIME) > '07:00:00' AND
CAST(date AS TIME) < '09:00:00'
GROUP BY  a.card, b.name, d.name, a.amount, e.name, a.date
ORDER BY merchant_category ASC;

-- Query view transaction_bw7and9 for top 100 transactions
SELECT * FROM transaction_bw7and9 LIMIT 100;

-- Create a view for count of transactions of less than $2.00 between 7 am and 9am
CREATE VIEW fraud_transaction_bw7and9 AS
SELECT cardholder_name, creditcard_number, merchant_name, merchant_category, amount
FROM transaction_bw7and9 
WHERE amount < 2.00
GROUP BY cardholder_name, creditcard_number, merchant_name, merchant_category, amount
ORDER BY merchant_category ASC;

-- Query view fraud_transaction_bw7and9 
SELECT * FROM fraud_transaction_bw7and9;

-- Create a view for count of transactions of less than $2.00 after 9am till mid-night
CREATE VIEW fraud_transaction_bw9and24 AS
SELECT 
d.name AS cardholder_name,
a.card AS creditcard_number,
b.name AS merchant_name,
e.name AS merchant_category,
a.amount
FROM transaction AS a, merchant AS b, credit_card AS c, card_holder AS d, merchant_category AS e
WHERE a.id_merchant = b.id AND
b.id_merchant_category = e.id AND
a.card = c.card AND
c.cardholder_id = d.id AND
CAST(date AS TIME) > '09:00:00' AND
CAST(date AS TIME) < '24:00:00' AND
amount < 2.00
GROUP BY  a.card, b.name, d.name, a.amount, e.name, a.date
ORDER BY merchant_category ASC;

-- Query view fraud_transaction_bw9and24 
SELECT * FROM fraud_transaction_bw9and24;

-- Create a view for count of transactions of less than $2.00 between 0 am and 7 am
CREATE VIEW fraud_transaction_bw0and7 AS
SELECT 
d.name AS cardholder_name,
a.card AS creditcard_number,
b.name AS merchant_name,
e.name AS merchant_category,
a.amount
FROM transaction AS a, merchant AS b, credit_card AS c, card_holder AS d, merchant_category AS e
WHERE a.id_merchant = b.id AND
b.id_merchant_category = e.id AND
a.card = c.card AND
c.cardholder_id = d.id AND
CAST(date AS TIME) > '00:00:00' AND
CAST(date AS TIME) < '07:00:00' AND
amount < 2.00
GROUP BY  a.card, b.name, d.name, a.amount, e.name, a.date
ORDER BY merchant_category ASC;

-- Query view fraud_transaction_bw0and7 
SELECT * FROM fraud_transaction_bw0and7;

-- Query view for total number of less than $2.00 transactions between 7 am and 9 am
SELECT count (*) FROM fraud_transaction_bw7and9;

-- Query view for total number of less than $2.00 transactions between after 9 am till mid-night
SELECT count(*) FROM fraud_transaction_bw9and24;

-- Query view for total number of less than $2.00 transactions between mid-night and 7 am
SELECT count(*) FROM fraud_transaction_bw0and7;

-- Query view for total number of less than $2.00 transactions between in 24 hours
SELECT sum(transaction_count) FROM transaction_lessthan$2;

-- Create view for merchants prone to being hacked using small transactions of less than $2.00
CREATE VIEW merchant_small_transaction AS
SELECT 
b.name AS merchant_name,
e.name AS merchant_category,
d.name AS cardholder_name, 
a.card AS creditcard_number, 
COUNT(a.id) AS transaction_count
FROM transaction AS a, merchant AS b, credit_card AS c, card_holder AS d, merchant_category AS e
WHERE a.amount < 2.00 AND
a.id_merchant = b.id AND
b.id_merchant_category = e.id AND
a.card = c.card AND
c.cardholder_id = d.id
GROUP BY  a.card, b.name, c.card, d.name, e.id
ORDER BY transaction_count DESC; 

-- Query view merchant_small_transaction top 5 
SELECT * FROM merchant_small_transaction LIMIT 5;

