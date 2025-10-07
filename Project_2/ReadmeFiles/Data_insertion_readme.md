# 📊 Sample Data for Library Management System

![Language](https://img.shields.io/badge/Language-SQL-blue.svg)
![Content](https://img.shields.io/badge/Content-Sample_Data-brightgreen.svg)

### Overview

This repository contains the SQL script used to populate the **Library Management System** database with a comprehensive set of sample data. This data seeding is crucial for demonstrating the database's functionality, testing queries, and developing applications based on the schema. The script inserts records into all tables, ensuring that referential integrity is maintained.

---

### Data Insertion Summary

The script populates the database with the following records:

* 🏢 **5** unique library branches.
* 🧑‍💼 **11** employee records across various positions and branches.
* 👥 **12** registered library members.
* 📚 **35** distinct book titles across multiple genres like Classic, Fantasy, and History.
* 📤 **15** book issuance records, linking books to members.
* 📥 **15** book return records.

---

### Sample Data Previews

Below is a preview of the sample data inserted into each table.

#### 🏢 Branch Data
*A total of 5 branch records were inserted.*

| branch_id | manager_id | branch_address | contact_no |
| :--- | :--- | :--- | :--- |
| `B001` | `E109` | `123 Main St` | `+919099988676` |
| `B002` | `E109` | `456 Elm St` | `+919099988677` |
| `B003` | `E109` | `789 Oak St` | `+919099988678` |

#### 🧑‍💼 Employee Data
*A total of 11 employee records were inserted.*

| emp_id | emp_name | position | salary | branch_id |
| :--- | :--- | :--- | :--- | :--- |
| `E101` | `John Doe` | `Clerk` | 60000.00 | `B001` |
| `E102` | `Jane Smith` | `Clerk` | 45000.00 | `B002` |
| `E103` | `Mike Johnson` | `Librarian`| 55000.00 | `B001` |

#### 👥 Member Data
*A total of 12 member records were inserted.*

| member_id | member_name | member_address | reg_date |
| :--- | :--- | :--- | :--- |
| `C101` | `Alice Johnson` | `123 Main St` | `2021-05-15` |
| `C102` | `Bob Smith` | `456 Elm St` | `2021-06-20` |
| `C103` | `Carol Davis` | `789 Oak St` | `2021-07-10` |

#### 📚 Book Catalog Data
*A total of 35 book records were inserted.*

| isbn | book_title | category | rental_price | status |
| :--- | :--- | :--- | :--- | :--- |
| `978-0-553-29698-2` | `The Catcher in the Rye` | `Classic` | 7.00 | `yes` |
| `978-0-330-25864-8` | `Animal Farm` | `Classic` | 5.50 | `yes` |
| `978-0-14-118776-1` | `One Hundred Years of Solitude` | `Literary Fiction` | 6.50 | `yes` |

#### 📤 Book Issuance Data
*A total of 15 issuance records were inserted.*

| issued_id | issued_member_id | issued_book_name | issued_date |
| :--- | :--- | :--- | :--- |
| `IS106` | `C106` | `Animal Farm` | `2024-03-10` |
| `IS107` | `C107` | `One Hundred Years of Solitude` | `2024-03-11` |
| `IS108` | `C108` | `The Great Gatsby` | `2024-03-12` |

#### 📥 Book Return Data
*A total of 15 return records were inserted.*

| return_id | issued_id | return_date | return_book_name |
| :--- | :--- | :--- | :--- |
| `RS104` | `IS106` | `2024-05-01` | `Animal Farm` |
| `RS105` | `IS107` | `2024-05-03` | `One Hundred Years of Solitude` |
| `RS106` | `IS108` | `2024-05-05` | `The Great Gatsby` |

---

### Key Takeaways

* **Data Integrity:** The data is inserted in a specific order (`branch` -> `employees` -> `members` -> `books` -> `issued_status` -> `return_status`) to respect the **foreign key constraints** established in the database schema.
* **Realistic Scenarios:** The sample data includes a variety of records that allow for testing different scenarios, such as multiple books issued by one member and multiple employees working at a single branch.