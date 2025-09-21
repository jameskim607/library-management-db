# Library Management System Database

## Overview
A comprehensive relational database for managing library operations including book cataloging, member management, loan tracking, and financial transactions.

## Database Schema
The system includes 10 main tables:
- `members` - Library users and their information
- `authors` - Book authors
- `publishers` - Publishing companies
- `books` - Book information and metadata
- `book_authors` - Many-to-many relationship between books and authors
- `book_copies` - Physical copies of books
- `loans` - Book borrowing records
- `reservations` - Book reservation system
- `fines` - Financial penalties for overdue/lost books
- `staff` - Library employees

## Installation
1. Clone this repository
2. Run MySQL and execute the `library_database.sql` file:
   ```sql
   source path/to/library_database.sql