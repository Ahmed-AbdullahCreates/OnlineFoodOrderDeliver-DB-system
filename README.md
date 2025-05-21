#  Food Delivery System Database Project

## Project Overview

This repository contains a comprehensive database design and implementation for a Food Delivery System, developed as part of a Database Design course. The project demonstrates the complete database development lifecycle, from conceptual modeling to physical implementation and testing.

## Table of Contents

- [Food Delivery System Database Project](#food-delivery-system-database-project)
  - [Project Overview](#project-overview)
  - [Table of Contents](#table-of-contents)
  - [📁 Project Structure](#-project-structure)
  - [Database Design](#database-design)
    - [Entity Relationship Diagram (ERD)](#entity-relationship-diagram-erd)
    - [Schema Mapping](#schema-mapping)
    - [Key Design Features](#key-design-features)
  - [Database Schema](#database-schema)
    - [Relationships](#relationships)
  - [Implementation](#implementation)
  - [Testing \& Mock Data](#testing--mock-data)
  - [Documentation](#documentation)
  - [Technologies Used](#technologies-used)
  - [Team Members](#team-members)
  - [Installation \& Setup](#installation--setup)
    - [Prerequisites](#prerequisites)
    - [Database Setup](#database-setup)
    - [Running Data Generation Scripts](#running-data-generation-scripts)
  - [📝 License](#-license)

## 📁 Project Structure

```
Project/
├── Database Design/             # Conceptual and logical design artifacts
│   ├── ERD.png                  # Entity Relationship Diagram
│   ├── Mapping.drawio           # Mapping diagrams source file
│   ├── Schema.png               # Database schema visualization
│   └── Use case diagram.jpeg    # System use case diagram
│
├── Documentation/               # Project documentation
│   ├── Documentation.pdf        # Comprehensive project documentation
│
├── Development/                 # Development artifacts
│   ├── QBE s.txt                # Query-By-Example notes
│   └── Role.png                 # User roles diagram
│
└── Implementation/              # Physical implementation
    └── food-delivery-system/
        └── Implementation/
            ├── SchemaDifination.sql    # SQL DDL for database creation
            ├── olaAndOmara.sql         # Additional SQL scripts
            ├── Mock Data/              # Test data generation
            │   ├── covert_csv_t0_sql.py # CSV to SQL converter script
            │   ├── realistic_data.sql  # Generated test data
            │   ├── userInsert.py       # User data generation script
            │   └── csv files/          # CSV data sources
            └── schema diagram/         # Schema visualization artifacts
```

##  Database Design

The database design follows the standard three-phase approach:

1. **Conceptual Design**: Created an Entity-Relationship Diagram (ERD) to represent the high-level conceptual model of the system.
   
2. **Logical Design**: Mapped the ERD to a relational model through mapping techniques and normalization.

3. **Physical Design**: Transformed the logical model into SQL DDL, including tables, constraints, indexes, and triggers.

### Entity Relationship Diagram (ERD)
![Entity Relationship Diagram](./Database%20Design/ERD.png)

### Schema Mapping
![Schema Mapping](./Database%20Design/Schema(mapping).png)

### Key Design Features

- Normalized tables (3NF) for efficient data storage
- Foreign key constraints with appropriate ON DELETE actions
- Check constraints to ensure data integrity
- Indexes for performance optimization
- Triggers for automated timestamp updates and business rule enforcement

##  Database Schema

The system includes the following core entities:

| Entity | Description |
|--------|-------------|
| Users | Customer information including contact details and account status |
| Restaurants | Restaurant details including location and ratings |
| MenuItems | Food items available from restaurants |
| Orders | Customer orders with status tracking |
| OrderDetails | Line items within each order |
| Payments | Payment transaction information |
| Deliveries | Delivery status and tracking information |
| Feedback | Customer reviews and ratings |

### Relationships

- Users place multiple Orders
- Restaurants offer multiple MenuItems
- Orders contain multiple OrderDetails (menu items)
- Orders have one Payment
- Orders have one Delivery
- Orders can have Feedback

##  Implementation

The database was implemented using SQL Server with:

- Primary and foreign key constraints
- Check constraints for data validation
- Indexes for query optimization
- Triggers for automated data management
- Computed columns for reporting
- Stored procedures for common operations

##  Testing & Mock Data

Mock data was generated to test the database functionality:

- Python scripts to generate realistic data
- CSV files converted to SQL INSERT statements
- Data validation through constraints and triggers

##  Documentation

Comprehensive documentation includes:

- Database design methodology
- Entity relationship diagrams
- Mapping documentation
- Schema definitions
- Query examples
- Implementation guidelines

##  Technologies Used

- **Database**: SQL Server
- **Modeling Tools**: Draw.io (for ERD and mapping diagrams)
- **Data Generation**: Python (pandas)
- **Version Control**: Git
- **Documentation**: PDF
- 
## Problematic Team Members

- **Ahmed Abdullah**
- **Mohamed Ashraf Omara**
- **Salma Yasser**
- **Ola Farahat**
  


##  Installation & Setup

### Prerequisites

- SQL Server (2019 or later recommended)
- Python 3.7+ (for data generation scripts)
- pandas library (`pip install pandas`)

### Database Setup

1. Run the schema creation script:
   ```sql
   USE master;
   GO
   
   -- Create new database
   CREATE DATABASE FoodDeliverySystem;
   GO
   
   USE FoodDeliverySystem;
   GO
   
   -- Run the schema definition script
   -- <paste content of SchemaDifination.sql here>
   ```

2. Load test data:
   ```sql
   USE FoodDeliverySystem;
   GO
   
   -- Run the realistic data script
   -- <paste content of realistic_data.sql here>
   ```

### Running Data Generation Scripts

To generate new test data:

1. Update CSV files in the `csv files` directory
2. Run the conversion script:
   ```bash
   python covert_csv_t0_sql.py
   ```

## 📝 License

[MIT License](LICENSE)

---

*This project was developed as part of the Database Design course, FCAI, 2023-2024.*
