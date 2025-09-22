# Library Management System Database

## 📌 Project Overview
This project implements a **relational database management system (RDBMS)** for a **Library Management System** using **MySQL**.  
It was developed as part of the assignment to design and implement a full-featured database with proper constraints, relationships, and sample data.

---

## 🎯 Objectives
- Design a database schema for managing a library.
- Implement well-structured tables with constraints (`PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`).
- Demonstrate relationships:
  - **One-to-Many**: Publishers → Books, Members → Loans
  - **Many-to-Many**: Books ↔ Authors (via `book_authors`)
- Populate the database with sample records.

---

## 🗂 Database Schema

The database contains the following tables:

1. **Members** – Library users and their membership info.  
2. **Authors** – Information about book authors.  
3. **Publishers** – Book publishing details.  
4. **Books** – Core book records with publisher references.  
5. **Book Authors** – Junction table for books ↔ authors.  
6. **Book Copies** – Tracks multiple copies of a book.  
7. **Loans** – Borrowing records for book copies.  
8. **Reservations** – Member reservations for books.  
9. **Fines** – Penalties for late returns.  
10. **Staff** – Staff working at the library.  

Indexes have been added for better query performance (e.g., on `books.title`, `members.email`, `loans.status`).

---

## ⚙️ How to Run

1. Clone this repository:
   ```bash
   git clone https://github.com/jameskim607/library-management-db.git
   cd library-management-db
2. Open MySQL and run the SQL script:

mysql -u root -p < library_database.sql


3. Switch to the database:

USE library_database;


3. Explore the tables:

SHOW TABLES;

📊 Sample Queries

Here are some example queries you can run:

List all available books:

SELECT b.title, c.copy_number, c.status
FROM books b
JOIN book_copies c ON b.book_id = c.book_id
WHERE c.status = 'Available';


Find overdue loans:

SELECT l.loan_id, m.first_name, m.last_name, b.title, l.due_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies c ON l.copy_id = c.copy_id
JOIN books b ON c.book_id = b.book_id
WHERE l.due_date < CURDATE() AND l.status = 'Active';


Show all books by a specific author:

SELECT a.first_name, a.last_name, b.title
FROM authors a
JOIN book_authors ba ON a.author_id = ba.author_id
JOIN books b ON ba.book_id = b.book_id
WHERE a.last_name = 'Orwell';

✅ Features

Complete relational schema with 10 tables.

Proper constraints for data integrity.

Many-to-Many relationships (Books ↔ Authors).

Sample data for demonstration.

Indexed for performance.

📅 Assignment Details

Coursework: Database Management Assignment

Submission Deadline: 25th September 2025

Question Attempted: Question 1 (Build a Complete Database Management System)

👨‍💻 Author

Name: James Kimani

Project: Library Management Database (MySQL)