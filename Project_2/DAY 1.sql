select * from books;

--Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO BOOKS(isbn,book_title,category,rental_price,status,author,publisher)
	VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM books WHERE isbn = '978-1-60129-456-2';

-- Task 2: Update an Existing Member's Address

SELECT * FROM members;

UPDATE members
SET member_address = '3321 Side St'
WHERE member_id = 'C101';

-- Task 3: Delete a Record from the Issued Status Table -- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status WHERE issued_id = 'IS121';

DELETE FROM issued_status WHERE issued_id = 'IS121';

SELECT * FROM issued_status WHERE issued_id = 'IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E106'.
SELECT * FROM issued_status;

SELECT * FROM issued_status WHERE issued_emp_id = 'E106';


-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT COUNT(issued_member_id)  FROM issued_status  GROUP by issued_member_id  HAVING COUNT(issued_member_id) > 1;


-- 3. CTAS (Create Table As Select)
--           Task 6: Create Summary Tables: Used CREATE TABLE AS to generate new tables based on query results - each book and total book_issued_cnt**


CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issued_count
FROM issued_status as ist 
JOIN books as b
ON ist.issued_book_isbn= b.isbn 
GROUP BY b.isbn , b.book_title;

SELECT * from book_issued_cnt;



-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books WHERE category = 'Literary Fiction';

-- Task 8: Find Total Rental Income by Category:

SELECT category , SUM(rental_price) as Ttl_Rentl_incm FROM books GROUP BY 1; 

-- Task 9: List Members Who Registered in the Last 180 Days:

SELECT * FROM members WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

-- Task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id;

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 4.00;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;




