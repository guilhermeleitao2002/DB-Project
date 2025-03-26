# Intelligent Vending Machines Database - Full Project Summary

## Overview
This project develops a comprehensive database system for managing **Intelligent Vending Machines (IVMs)**, covering database design, relational implementation, query development, OLAP analysis, and a web application prototype.

---

## **Part 1: Entity-Relationship Model**
### **Objective:**  
Design a **conceptual database model** using an **Entity-Relationship (E-R) diagram** to represent the structure and relationships of the IVM system.

### **Key Components:**
- **IVMs** identified by serial numbers, located at retail points.
- **Shelves** with specific dimensions and types (ambient, hot, cold).
- **Planograms** defining product placement in vending machines.
- **Products** classified by **categories** with a hierarchical structure.
- **Retailers** responsible for replenishment, recorded in **replenishment events**.

### **Integrity Constraints:**
- Products must belong to a category.
- Categories form a strict hierarchy.
- Retailers manage specific product categories.
- Replenishment events must follow planogram limits.

---

## **Part 2: Relational Model and Query Development**
### **Objective:**  
Translate the E-R model into a **Relational Database Schema**, ensuring efficient data management and retrieval.

### **Key Implementations:**
- **Database Schema (DDL)** with primary and foreign keys.
- **Integrity Constraints**, including:
  - Preventing cyclic category hierarchies.
  - Ensuring valid replenishment operations.
  - Enforcing category-specific product placement.
- **SQL Queries**:
  - Finding top retailers by category management.
  - Identifying products never replenished.
  - Listing vending machines that contain a specific product.
- **Relational Algebra Queries** for theoretical validation.

---

## **Part 3: Advanced SQL, Web Application, and OLAP Analysis**
### **Objective:**  
Enhance the database with **stored procedures, advanced SQL queries, OLAP analytics, and a web application**.

### **Key Implementations:**
- **Advanced SQL Queries**, including:
  - Finding retailers managing all simple categories.
  - Identifying products always replenished by the same retailer.
- **Stored Procedures & Triggers** to enforce:
  - Replenishment limits based on planograms.
  - Valid product placement on shelves.
  - Maintaining hierarchical category consistency.
- **Sales Analysis View:** Aggregates replenishment data as sales.
- **OLAP Queries:**  
  - Analyzing total sales by region, category, and time.
  - Using `ROLLUP`, `CUBE`, and `GROUPING SETS` for multi-level aggregation.
- **Web Application Prototype (Python CGI + HTML)**:
  - Managing categories and retailers.
  - Listing restocking events by IVM.
  - Viewing category hierarchies dynamically.

### **Performance Optimization:**
- Indexing strategies for efficient query execution on large datasets.

---

## **Conclusion**
This project delivers a **fully functional, optimized database system** for **Intelligent Vending Machines**, integrating **data modeling, relational implementation, advanced SQL queries, OLAP analytics, and a prototype web application** to ensure efficient data management and insightful business intelligence.
