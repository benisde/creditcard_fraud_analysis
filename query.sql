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

-- Create a view for transactions of each cardholder
CREATE VIEW cardholder_transaction AS
SELECT 
C.name AS cardholder_name,
A.card AS card_number,
A.amount AS amount,
A.date AS transaction_date
FROM transaction AS A, credit_card AS B, card_holder AS C
WHERE A.card = B.card AND
B.cardholder_id = C.id
GROUP BY A.id, B.card, C.id;

-- Query view cardholder_transaction
SELECT * FROM cardholder_transaction;

-- Create a view for number of transactions that are less than $2.00 per cardholder
CREATE VIEW transaction_lessthan$2 AS
SELECT cardholder_name, card_number, COUNT(*) AS transaction_count
FROM cardholder_transaction
WHERE amount < 2.00
GROUP BY cardholder_name, card_number
ORDER BY transaction_count DESC;

-- Query view transaction_lessthan$2
SELECT * FROM transaction_lessthan$2;

-- Create a view for transactions between 7 am and 9 am
CREATE VIEW transaction_bw7and9 AS
SELECT * FROM cardholder_transaction
WHERE CAST(transaction_date AS TIME) > '07:00:00' AND
CAST(transaction_date AS TIME) < '09:00:00'
ORDER BY amount DESC;

-- Query view transaction_bw7and9 for top 100 transactions
SELECT * FROM transaction_bw7and9 LIMIT 100;

-- Create a view for count of transactions of less than $2.00 between 7 am and 9am
CREATE VIEW fraud_transaction_bw7and9 AS
SELECT cardholder_name, card_number, count(*) AS transaction_count 
FROM transaction_bw7and9 
WHERE amount < 2.00
GROUP BY cardholder_name, card_number
ORDER by transaction_count DESC;

-- Query view fraud_transaction_bw7and9 
SELECT * FROM fraud_transaction_bw7and9;

-- Create a view for count of transactions of less than $2.00 after 9am
CREATE VIEW fraud_transaction_bw9and24 AS
SELECT cardholder_name, card_number, count(*) AS transaction_count 
FROM cardholder_transaction 
WHERE amount < 2.00 AND
CAST(transaction_date AS TIME) > '09:00:00' AND
CAST(transaction_date AS TIME) < '24:00:00'  
GROUP BY cardholder_name, card_number
ORDER by transaction_count DESC;

-- Query view fraud_transaction_bw9and24 
SELECT * FROM fraud_transaction_bw9and24;

-- Create a view for count of transactions of less than $2.00 between 0 am and 7 am
CREATE VIEW fraud_transaction_bw0and7 AS
SELECT cardholder_name, card_number, count(*) AS transaction_count 
FROM cardholder_transaction 
WHERE amount < 2.00 AND
CAST(transaction_date AS TIME) > '00:00:00' AND
CAST(transaction_date AS TIME) < '07:00:00' 
GROUP BY cardholder_name, card_number
ORDER by transaction_count DESC;

-- Query view fraud_transaction_bw0and7 
SELECT * FROM fraud_transaction_bw0and7;

-- Query view for total number of less than $2.00 transactions between 7 am and 9 am
SELECT sum(transaction_count) FROM fraud_transaction_bw7and9;

-- Query view for total number of less than $2.00 transactions between after 9 am till mid-night
SELECT sum(transaction_count) FROM fraud_transaction_bw9and24;

-- Query view for total number of less than $2.00 transactions between mid-night and 7 am
SELECT sum(transaction_count) FROM fraud_transaction_bw0and7;

-- Query view for total number of less than $2.00 transactions between in 24 hours
SELECT sum(transaction_count) FROM transaction_lessthan$2;

-- Create view for merchants prone to being hacked using small transactions of less than $2.00
CREATE VIEW merchant_small_transaction AS
SELECT 
b.name AS merchant_name, 
d.name AS cardholder_name, 
a.card as creditcard_number, 
COUNT(a.id) AS transaction_count
FROM transaction AS a, merchant AS b, credit_card AS c, card_holder AS d
WHERE a.amount < 2.00 AND
a.id_merchant = b.id AND
a.card = c.card AND
c.cardholder_id = d.id
GROUP BY  a.card, b.name, c.card, d.name
ORDER BY transaction_count DESC; 

-- Query view merchant_small_transaction top 5 
SELECT * FROM merchant_small_transaction LIMIT 5;