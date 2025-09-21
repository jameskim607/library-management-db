-- library_database.sql

-- Create Database
CREATE DATABASE library_management_system;
USE library_management_system;

-- Table 1: Members (Library Users)
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    address TEXT,
    membership_date DATE NOT NULL,
    membership_status ENUM('Active', 'Suspended', 'Expired') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table 2: Authors
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birth_date DATE,
    nationality VARCHAR(50),
    biography TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 3: Publishers
CREATE TABLE publishers (
    publisher_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    address TEXT,
    contact_email VARCHAR(100),
    contact_phone VARCHAR(15),
    website VARCHAR(200),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table 4: Books (changed publication_year from YEAR to SMALLINT)
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    isbn VARCHAR(13) UNIQUE NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    publication_year SMALLINT, -- Changed from YEAR to SMALLINT
    genre VARCHAR(50) NOT NULL,
    language VARCHAR(30) DEFAULT 'English',
    page_count INT,
    publisher_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (publisher_id) REFERENCES publishers(publisher_id) ON DELETE SET NULL
);

-- Table 5: Book-Author Relationship (Many-to-Many)
CREATE TABLE book_authors (
    book_id INT,
    author_id INT,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);

-- Table 6: Book Copies
CREATE TABLE book_copies (
    copy_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    copy_number INT NOT NULL,
    status ENUM('Available', 'Borrowed', 'Reserved', 'Under Maintenance', 'Lost') DEFAULT 'Available',
    acquisition_date DATE,
    book_condition ENUM('New', 'Good', 'Fair', 'Poor') DEFAULT 'Good',
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (book_id, copy_number),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);

-- Table 7: Loans
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    copy_id INT NOT NULL,
    member_id INT NOT NULL,
    loan_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE,
    status ENUM('Active', 'Returned', 'Overdue', 'Lost') DEFAULT 'Active',
    late_fee DECIMAL(10,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (copy_id) REFERENCES book_copies(copy_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Table 8: Reservations
CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    member_id INT NOT NULL,
    reservation_date DATE NOT NULL,
    status ENUM('Pending', 'Fulfilled', 'Cancelled') DEFAULT 'Pending',
    priority INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE
);

-- Table 9: Fines
CREATE TABLE fines (
    fine_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    loan_id INT,
    amount DECIMAL(10,2) NOT NULL,
    reason VARCHAR(200) NOT NULL,
    status ENUM('Unpaid', 'Paid', 'Waived') DEFAULT 'Unpaid',
    issue_date DATE NOT NULL,
    payment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (loan_id) REFERENCES loans(loan_id) ON DELETE SET NULL
);

-- Table 10: Staff
CREATE TABLE staff (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    position VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2),
    status ENUM('Active', 'Inactive', 'On Leave') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create Indexes for better performance
CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_genre ON books(genre);
CREATE INDEX idx_members_email ON members(email);
CREATE INDEX idx_loans_member ON loans(member_id);
CREATE INDEX idx_loans_due_date ON loans(due_date);
CREATE INDEX idx_loans_status ON loans(status);
CREATE INDEX idx_copies_status ON book_copies(status);

-- Insert Sample Data
INSERT INTO publishers (name, contact_email, website) VALUES
('Penguin Random House', 'contact@penguin.com', 'https://www.penguinrandomhouse.com'),
('HarperCollins', 'info@harpercollins.com', 'https://www.harpercollins.com'),
('Macmillan', 'support@macmillan.com', 'https://www.macmillan.com');

INSERT INTO authors (first_name, last_name, nationality) VALUES
('George', 'Orwell', 'British'),
('J.K.', 'Rowling', 'British'),
('Stephen', 'King', 'American'),
('Jane', 'Austen', 'British');

INSERT INTO books (isbn, title, publication_year, genre, publisher_id, page_count) VALUES
('9780451524935', '1984', 1949, 'Dystopian', 1, 328),
('9780439064873', 'Harry Potter and the Chamber of Secrets', 1998, 'Fantasy', 2, 341),
('9781501142970', 'It', 1986, 'Horror', 3, 1138),
('9780141439518', 'Pride and Prejudice', 1813, 'Romance', 1, 432);

INSERT INTO book_authors (book_id, author_id) VALUES
(1, 1), -- 1984 by George Orwell
(2, 2), -- Harry Potter by J.K. Rowling
(3, 3), -- It by Stephen King
(4, 4); -- Pride and Prejudice by Jane Austen

INSERT INTO book_copies (book_id, copy_number, status, book_condition) VALUES
(1, 1, 'Available', 'Good'),
(1, 2, 'Available', 'New'),
(2, 1, 'Available', 'Fair'),
(3, 1, 'Under Maintenance', 'Poor'),
(4, 1, 'Available', 'Good');

INSERT INTO members (first_name, last_name, email, membership_date) VALUES
('John', 'Doe', 'john.doe@email.com', '2024-01-15'),
('Jane', 'Smith', 'jane.smith@email.com', '2024-02-20'),
('Bob', 'Johnson', 'bob.johnson@email.com', '2024-03-10');

INSERT INTO staff (first_name, last_name, email, position, hire_date) VALUES
('Alice', 'Brown', 'alice.brown@library.com', 'Librarian', '2023-05-15'),
('David', 'Wilson', 'david.wilson@library.com', 'Assistant Librarian', '2023-08-20');