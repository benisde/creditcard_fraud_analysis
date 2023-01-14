-- Drop tables
DROP TABLE IF EXISTS card_holder CASCADE;
DROP TABLE IF EXISTS credit_card CASCADE;
DROP TABLE IF EXISTS merchant_category CASCADE;
DROP TABLE IF EXISTS merchant CASCADE;
DROP TABLE IF EXISTS transaction CASCADE;

-- Create a table of card holders
CREATE TABLE card_holder (
	id INT NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL
);

-- Create a table of credit cards
CREATE TABLE credit_card (
	card VARCHAR NOT NULL PRIMARY KEY,
	cardholder_id INT NOT NULL,
	FOREIGN KEY (cardholder_id) REFERENCES card_holder(id)
);


-- Create a table of merchant category
CREATE TABLE merchant_category (
	id INT NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL
);

-- Create a table of merchants
CREATE TABLE merchant (
	id INT NOT NULL PRIMARY KEY,
	name VARCHAR NOT NULL,
	id_merchant_category INT NOT NULL,
	FOREIGN KEY (id_merchant_category) REFERENCES merchant_category(id)
);

-- Create a table of transactions
CREATE TABLE transaction (
	id INT NOT NULL PRIMARY KEY,
	date TIMESTAMP NOT NULL,
	amount FLOAT NOT NULL,
	card VARCHAR NOT NULL, 
	FOREIGN KEY (card) REFERENCES credit_card(card),
	id_merchant INT NOT NULL,
	FOREIGN KEY (id_merchant) REFERENCES merchant(id)
);