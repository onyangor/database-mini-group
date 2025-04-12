CREATE DATABASE bookstore_db;
USE bookstore_db;

-- Table: book_language
CREATE TABLE book_language (
    language_id INT AUTO_INCREMENT PRIMARY KEY,
    language_name VARCHAR(100) NOT NULL
);

-- Table: publisher
CREATE TABLE publisher (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: book
CREATE TABLE book (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    language_id INT,
    publisher_id INT,
    price DECIMAL(10,2),
    FOREIGN KEY (language_id) REFERENCES book_language(language_id),
    FOREIGN KEY (publisher_id) REFERENCES publisher(publisher_id)
);

-- Table: author
CREATE TABLE author (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table: book_author (many-to-many)
CREATE TABLE book_author (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id),
    FOREIGN KEY (author_id) REFERENCES author(author_id)
);
-- Table: customer
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL
);

-- Table: address_status
CREATE TABLE address_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(100) NOT NULL  -- e.g., 'current', 'old'
);

-- Table: country
CREATE TABLE country (
    country_id INT AUTO_INCREMENT PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Table: address
CREATE TABLE address (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    street VARCHAR(255),
    city VARCHAR(100),
    postal_code VARCHAR(20),
    country_id INT,
    status_id INT,
    FOREIGN KEY (country_id) REFERENCES country(country_id),
    FOREIGN KEY (status_id) REFERENCES address_status(status_id)
);

-- Table: customer_address
CREATE TABLE customer_address (
    customer_id INT,
    address_id INT,
    PRIMARY KEY (customer_id, address_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (address_id) REFERENCES address(address_id)
);
-- Table: shipping_method
CREATE TABLE shipping_method (
    shipping_method_id INT AUTO_INCREMENT PRIMARY KEY,
    method_name VARCHAR(100) NOT NULL  -- e.g., 'Standard', 'Express'
);

-- Table: order_status
CREATE TABLE order_status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(100) NOT NULL  -- e.g., 'pending', 'shipped', 'delivered'
);

-- Table: cust_order
CREATE TABLE cust_order (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status_id INT,
    shipping_method_id INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id),
    FOREIGN KEY (shipping_method_id) REFERENCES shipping_method(shipping_method_id)
);

-- Table: order_line
CREATE TABLE order_line (
    order_line_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    book_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (book_id) REFERENCES book(book_id)
);

-- Table: order_history
CREATE TABLE order_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    status_id INT,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES cust_order(order_id),
    FOREIGN KEY (status_id) REFERENCES order_status(status_id)
);

/* INSERT DUMMY TO DATABASE */
-- book_language
INSERT INTO book_language (language_name) VALUES
('English'),
('French'),
('Swahili');


-- publisher
INSERT INTO publisher (name) VALUES
('Penguin Books'),
('Macmillan'),
('Oxford University Press');


-- book
INSERT INTO book (title, language_id, publisher_id, price) VALUES
('1984', 1, 1, 14.99),
('Le Petit Prince', 2, 2, 9.99),
('Swahili Tales', 3, 3, 11.50);


-- author
INSERT INTO author (name) VALUES
('George Orwell'),
('Antoine de Saint-Exupéry'),
('Ali Mazrui');


-- book_author
INSERT INTO book_author (book_id, author_id) VALUES
(1, 1),
(2, 2),
(3, 3);


-- customer
INSERT INTO customer (name, email) VALUES
('Alice Mwangi', 'alice@example.com'),
('John Doe', 'john@example.com');


-- address_status
INSERT INTO address_status (status_name) VALUES
('current'),
('old');


-- country
INSERT INTO country (country_name) VALUES
('Kenya'),
('France');

-- address
INSERT INTO address (street, city, postal_code, country_id, status_id) VALUES
('123 Moi Avenue', 'Nairobi', '00100', 1, 1),
('456 Rue de Paris', 'Paris', '75001', 2, 1);

-- customer_address
INSERT INTO customer_address (customer_id, address_id) VALUES
(1, 1),
(2, 2);

-- shipping_method
INSERT INTO shipping_method (method_name) VALUES
('Standard'),
('Express');

-- order_status
INSERT INTO order_status (status_name) VALUES
('pending'),
('shipped'),
('delivered');

-- cust_order
INSERT INTO cust_order (customer_id, order_date, status_id, shipping_method_id) VALUES
(1, '2025-04-10', 1, 1),
(2, '2025-04-11', 2, 2);

-- order_line
INSERT INTO order_line (order_id, book_id, quantity) VALUES
(1, 1, 1),
(1, 3, 2),
(2, 2, 1);

-- order_history
INSERT INTO order_history (order_id, status_id) VALUES
(1, 1),
(1, 2),
(2, 2);

-- Users and their privileges

CREATE USER 'book_admin'@'localhost' IDENTIFIED BY 'Admin@123';
CREATE USER 'book_staff'@'localhost' IDENTIFIED BY 'Staff@123';
CREATE USER 'book_viewer'@'localhost' IDENTIFIED BY 'Viewer@123';

-- grant all privileges to the admin
GRANT ALL PRIVILEGES ON bookstore_db.* TO 'book_admin'@'localhost';

-- Staff: Can read and modify data, but no permission to DROP or manage users
GRANT SELECT, INSERT, UPDATE, DELETE ON bookstore_db.* TO 'book_staff'@'localhost';

-- for students who can only read books
GRANT SELECT ON bookstore_db.* TO 'book_viewer'@'localhost';

-- save changes
FLUSH PRIVILEGES;
