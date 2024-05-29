-- Create Users Table
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Products Table
CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Orders Table
CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create OrderItems Table
CREATE TABLE OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create Categories Table
CREATE TABLE Categories (
    category_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT
);

-- Create ProductCategories Table
CREATE TABLE ProductCategories (
    product_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (product_id, category_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

-- Create Reviews Table
CREATE TABLE Reviews (
    review_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Addresses Table
CREATE TABLE Addresses (
    address_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    street VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Create Payments Table
CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


-- Insert Dummy Users
INSERT INTO Users (username, email, password) VALUES
('john_doe', 'john@example.com', 'password123'),
('jane_smith', 'jane@example.com', 'password456'),
('alice_jones', 'alice@example.com', 'password789');

-- Insert Dummy Products
INSERT INTO Products (name, description, price, stock) VALUES
('Laptop', 'A high-performance laptop', 999.99, 50),
('Smartphone', 'A latest model smartphone', 699.99, 100),
('Headphones', 'Noise-cancelling headphones', 199.99, 200);

-- Insert Dummy Orders
INSERT INTO Orders (user_id, total) VALUES
(1, 1699.97),
(2, 199.99);

-- Insert Dummy OrderItems
INSERT INTO OrderItems (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 999.99),
(1, 2, 1, 699.99),
(2, 3, 1, 199.99);

-- Insert Dummy Categories
INSERT INTO Categories (name, description) VALUES
('Electronics', 'Devices and gadgets'),
('Home Appliances', 'Appliances for home use'),
('Books', 'Various kinds of books');

-- Insert Dummy ProductCategories
INSERT INTO ProductCategories (product_id, category_id) VALUES
(1, 1), -- Laptop in Electronics
(2, 1), -- Smartphone in Electronics
(3, 1); -- Headphones in Electronics

-- Insert Dummy Reviews
INSERT INTO Reviews (product_id, user_id, rating, comment) VALUES
(1, 1, 5, 'Excellent laptop, very fast and reliable.'),
(2, 2, 4, 'Great smartphone, but battery life could be better.'),
(3, 3, 3, 'Average headphones, sound quality is okay.');

-- Insert Dummy Addresses
INSERT INTO Addresses (user_id, street, city, state, zip_code, country) VALUES
(1, '123 Main St', 'Springfield', 'IL', '62701', 'USA'),
(2, '456 Elm St', 'Metropolis', 'NY', '10001', 'USA'),
(3, '789 Oak St', 'Gotham', 'NJ', '07001', 'USA');

-- Insert Dummy Payments
INSERT INTO Payments (order_id, amount, payment_method) VALUES
(1, 1699.97, 'Credit Card'),
(2, 199.99, 'PayPal');