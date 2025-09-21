-- Additional sample data can be added here

-- Sample_Queries.sql
-- Example queries for the library system

-- 1. Find all available books by genre
SELECT b.title, b.genre, a.first_name, a.last_name, bc.copy_number
FROM books b
JOIN book_authors ba ON b.book_id = ba.book_id
JOIN authors a ON ba.author_id = a.author_id
JOIN book_copies bc ON b.book_id = bc.book_id
WHERE bc.status = 'Available'
ORDER BY b.genre, b.title;

-- 2. Get member borrowing history
SELECT m.first_name, m.last_name, b.title, l.loan_date, l.due_date, l.return_date
FROM members m
JOIN loans l ON m.member_id = l.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
ORDER BY m.last_name, l.loan_date DESC;

-- 3. Find overdue books
SELECT m.first_name, m.last_name, m.email, b.title, l.due_date, DATEDIFF(CURDATE(), l.due_date) AS days_overdue
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN book_copies bc ON l.copy_id = bc.copy_id
JOIN books b ON bc.book_id = b.book_id
WHERE l.status = 'Active' AND l.due_date < CURDATE();

-- 4. Count books by genre
SELECT genre, COUNT(*) as book_count
FROM books
GROUP BY genre
ORDER BY book_count DESC;

-- 5. Most popular authors (by number of books)
SELECT a.first_name, a.last_name, COUNT(ba.book_id) as book_count
FROM authors a
JOIN book_authors ba ON a.author_id = ba.author_id
GROUP BY a.author_id
ORDER BY book_count DESC;