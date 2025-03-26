# Intelligent Vending Machines Database - Relational Model

## Overview
This project focuses on translating the previously developed Entity-Relationship (E-R) model for Intelligent Vending Machines (IVMs) into a relational database schema. Additionally, it includes integrity constraints, relational algebra queries, and SQL implementations.

## Relational Model
The relational model consists of several tables derived from the E-R model, using the following notation:

- **Tables:** `RelationName (attribute1, attribute2, ..., attributeN)`
- **Primary Keys:** Underlined attributes (`_attribute_`)
- **Foreign Keys:** Specified as `attributeX, attributeY: FK(RelationName)`
- **Unique Constraints:** Specified using `unique(attributeA, attributeB)`

The schema includes:

- `IVM (_serial_number_, name, address)`
- `Shelf (_ivm_serial_number_, _shelf_number_, width, height, type)`, with `ivm_serial_number: FK(IVM)`
- `Category (_name_, super_category: FK(Category))`, ensuring hierarchy constraints
- `Product (_ean_, name, brand, package_type, category: FK(Category))`
- `Planogram (_ivm_serial_number_, _shelf_number_, _ean_, front_display, max_units)`, with FKs linking to `IVM`, `Shelf`, and `Product`
- `Retailer (_tin_, name UNIQUE)`
- `Replenishment (_event_id_, ivm_serial_number: FK(IVM), shelf_number: FK(Shelf), ean: FK(Product), tin: FK(Retailer), timestamp, units_replenished)`

## Integrity Constraints
To maintain data consistency, the following constraints are enforced:

- **(RI-1 & RI-2) Category Hierarchy Integrity:**  
  - A category cannot be its own parent.
  - Cycles in category hierarchy are not allowed.

- **(RI-3) Retailer Uniqueness:**  
  - Retailer names must be unique.

- **(RI-4) Replenishment Quantity Constraint:**  
  - Units replenished must not exceed the maximum allowed in the planogram.

- **(RI-5) Category-Shelf Compatibility:**  
  - A product can only be placed on a shelf that matches its category's designated shelf type.

- **(RI-6) Retailer Responsibility:**  
  - Only the retailer assigned to a category can replenish its products.

## Relational Algebra Queries
The following queries extract useful insights from the database:

1. **Products replenished in quantities greater than 10 after a given date for a specific category:**  
   `π_EAN, name (σ_category="Barras Energéticas" ∧ units_replenished > 10 ∧ timestamp > "2021-12-31" (Product ⨝ Replenishment))`

2. **IVMs displaying a specific product (by EAN):**  
   `π_ivm_serial_number (σ_ean="9002490100070" (Planogram))`

3. **Number of direct subcategories for a given category:**  
   `COUNT(σ_super_category="Sopas Take-Away" (Category))`

4. **Most replenished product:**  
   `π_ean, name (σ_units_replenished=MAX(units_replenished) (Product ⨝ Replenishment))`

## SQL Queries
Corresponding SQL implementations:

1. **Products replenished in quantities greater than 10 after a given date for a specific category:**
   ```sql
   SELECT p.ean, p.name
   FROM Product p
   JOIN Replenishment r ON p.ean = r.ean
   WHERE p.category = 'Barras Energéticas' AND r.units_replenished > 10 AND r.timestamp > '2021-12-31';
   ```

2. **IVMs displaying a specific product (by EAN):**
   ```sql
   SELECT ivm_serial_number
   FROM Planogram
   WHERE ean = '9002490100070';
   ```

3. **Number of direct subcategories for a given category:**
   ```sql
   SELECT COUNT(*)
   FROM Category
   WHERE super_category = 'Sopas Take-Away';
   ```

4. **Most replenished product:**
   ```sql
   SELECT p.ean, p.name
   FROM Product p
   JOIN Replenishment r ON p.ean = r.ean
   WHERE r.units_replenished = (SELECT MAX(units_replenished) FROM Replenishment);
   ```

## Conclusion
This project successfully converts the E-R model into a relational schema, ensuring data consistency through integrity constraints. The inclusion of relational algebra and SQL queries enables efficient data retrieval, supporting business operations related to Intelligent Vending Machines.
