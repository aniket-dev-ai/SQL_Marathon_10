# Database Schema for Library Management System

### Overview

This repository contains the SQL script for creating the database schema of a Library Management System. The schema is designed to efficiently manage the core entities of a library, including branches, employees, members, books, and their borrowing status. It establishes clear relationships between tables using primary and foreign keys to ensure data integrity and consistency.

---

### Database Schema Overview

The database consists of the following **6 tables**:

* **`branch`**: Stores information about different library branches.
* **`employees`**: Contains details of employees working at various branches.
* **`members`**: Manages the records of registered library members.
* **`books`**: A catalog of all books available in the library.
* **`issued_status`**: Tracks books that have been checked out by members.
* **`return_status`**: Logs the details of returned books.

---

### Table Structures

Below is a detailed breakdown of each table's structure, including columns, data types, and key constraints.

#### `branch`
Stores information about each library branch.

| Column         | Type          | Constraints |
| :------------- | :------------ | :---------- |
| `branch_id`    | `VARCHAR(10)` | PRIMARY KEY |
| `manager_id`   | `VARCHAR(10)` |             |
| `branch_address`| `VARCHAR(30)` |             |
| `contact_no`   | `VARCHAR(15)` |             |

#### `employees`
Stores information about library employees, their roles, and the branch they are associated with.

| Column      | Type           | Constraints                            |
| :---------- | :------------- | :------------------------------------- |
| `emp_id`    | `VARCHAR(10)`  | PRIMARY KEY                            |
| `emp_name`  | `VARCHAR(30)`  |                                        |
| `position`  | `VARCHAR(30)`  |                                        |
| `salary`    | `DECIMAL(10,2)`|                                        |
| `branch_id` | `VARCHAR(10)`  | FOREIGN KEY (references `branch.branch_id`) |

#### `members`
Stores details of all registered library members.

| Column         | Type          | Constraints |
| :------------- | :------------ | :---------- |
| `member_id`    | `VARCHAR(10)` | PRIMARY KEY |
| `member_name`  | `VARCHAR(30)` |             |
| `member_address`| `VARCHAR(30)` |             |
| `reg_date`     | `DATE`        |             |

#### `books`
Contains the catalog of all books in the library system.

| Column       | Type           | Constraints |
| :----------- | :------------- | :---------- |
| `isbn`       | `VARCHAR(50)`  | PRIMARY KEY |
| `book_title` | `VARCHAR(80)`  |             |
| `category`   | `VARCHAR(30)`  |             |
| `rental_price`| `DECIMAL(10,2)`|             |
| `status`     | `VARCHAR(10)`  |             |
| `author`     | `VARCHAR(30)`  |             |
| `publisher`  | `VARCHAR(30)`  |             |

#### `issued_status`
Tracks all book issuance transactions, linking books, members, and employees.

| Column             | Type          | Constraints                               |
| :----------------- | :------------ | :---------------------------------------- |
| `issued_id`        | `VARCHAR(10)` | PRIMARY KEY                               |
| `issued_member_id` | `VARCHAR(30)` | FOREIGN KEY (references `members.member_id`) |
| `issued_book_name` | `VARCHAR(80)` |                                           |
| `issued_date`      | `DATE`        |                                           |
| `issued_book_isbn` | `VARCHAR(50)` | FOREIGN KEY (references `books.isbn`)     |
| `issued_emp_id`    | `VARCHAR(10)` | FOREIGN KEY (references `employees.emp_id`) |

#### `return_status`
Logs the return of issued books.

| Column           | Type          | Constraints                           |
| :--------------- | :------------ | :------------------------------------ |
| `return_id`      | `VARCHAR(10)` | PRIMARY KEY                           |
| `issued_id`      | `VARCHAR(30)` |                                       |
| `return_book_name`| `VARCHAR(80)` |                                       |
| `return_date`    | `DATE`        |                                       |
| `return_book_isbn`| `VARCHAR(50)` | FOREIGN KEY (references `books.isbn`) |

---

### Entity Relationships

The schema is designed with the following relationships:
* A **`branch`** has multiple **`employees`**. (`branch.branch_id` -> `employees.branch_id`)
* An **`employee`** can issue multiple books. (`employees.emp_id` -> `issued_status.issued_emp_id`)
* A **`member`** can have multiple books issued. (`members.member_id` -> `issued_status.issued_member_id`)
* A **`book`** can be issued multiple times and returned multiple times. (`books.isbn` -> `issued_status.issued_book_isbn`, `books.isbn` -> `return_status.return_book_isbn`)