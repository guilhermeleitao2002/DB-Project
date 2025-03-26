# Intelligent Vending Machines Database Model

## Overview
This project implements a database model designed to manage Intelligent Vending Machines (IVMs), commonly known as "Smart Cabinets," installed at retail locations. The objective is to develop a concise, coherent, and organized Entity-Relationship (ER) model that meets the specific requirements of managing smart cabinets, their product displays, and replenishment processes.

## Domain Modeling
The system’s domain includes several key components:

- **Intelligent Vending Machines (IVMs):**  
  Each IVM is uniquely identified by a manufacturer’s serial number and is associated with a retail location (name and address).

- **Shelves:**  
  Within each IVM, shelves are numbered and characterized by dimensions (width and height) and type. Shelf types include "ambient," "hot," and "cold" (with cold shelves further distinguished as "cold positive" or "cold negative").

- **Planograms:**  
  A planogram specifies the product layout on each shelf. It defines the shelf to be used, the number of product fronts visible, and the maximum number of product units that can be displayed.

- **Products:**  
  Products are identified by a unique 13-digit EAN barcode. Each product has attributes such as designation, brand, and packaging type (indicating whether the product is flexible or rigid).

- **Categories:**  
  Every product is classified under a category. Categories form a hierarchy where a product belongs to exactly one category. Categories are divided into "Super Categories" (those with subcategories) and "Simple Categories" (those without subcategories). Each category is also linked to a specific shelf type, restricting where products can be placed.

- **Retailers:**  
  Retailers, identified by their Tax Identification Number (TIN) and unique name, are responsible for the replenishment of products in the IVMs. Each retailer is assigned specific product categories to manage within an IVM.

- **Replenishment Events:**  
  These events record the details of restocking activities, including the timestamp and the number of units replaced. They are linked to both the responsible retailer and the corresponding planogram, ensuring that replenishment does not exceed the maximum units permitted.

## Integrity Constraints
The implementation enforces several key integrity constraints to ensure data consistency and adherence to domain rules:

- **Uniqueness:**  
  Key attributes such as the IVM serial number, retailer TIN, and product EAN must be unique.

- **Referential Integrity:**  
  All relationships between entities (e.g., products and their categories, replenishment events linked to planograms and retailers) are strictly maintained.

- **Quantity Restrictions:**  
  Replenishment events are constrained so that the number of units replaced does not exceed the limits defined in the planogram.

- **Category Hierarchy:**  
  The hierarchical structure of categories is enforced by ensuring that each product belongs to only one category, and that each category (if part of a hierarchy) has at most one parent.

- **Shelf Type Constraints:**  
  Product placement is controlled by associating each category with a predefined shelf type, thereby restricting products to suitable environments based on their storage requirements.

## Conclusion
The database model developed in this project focuses on effectively managing the inventory and replenishment processes of Intelligent Vending Machines. By leveraging a well-structured ER diagram and robust integrity constraints, the model ensures efficient data organization, consistency, and scalability in a retail environment.
