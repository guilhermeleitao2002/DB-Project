# Intelligent Vending Machines Database - Implementation

## Overview
This project extends the database system for Intelligent Vending Machines (IVMs) by implementing a complete relational database schema, integrity constraints, SQL queries, OLAP analysis, and a web application prototype.

## 1. Database Schema

### Schema Definition
The database schema is created using SQL (DDL) with constraints such as:
- `NOT NULL`, `CHECK`, `PRIMARY KEY`, `UNIQUE`, and `FOREIGN KEY`
- Constraints enforce hierarchical category structures and retailer responsibilities

### Data Insertion
A dataset is loaded to ensure all queries return meaningful results. The insertion process can be automated using:
- SQL scripts
- Python scripts
- CSV imports

## 2. Integrity Constraints

### Implemented Using Triggers and Stored Procedures:
- **RI-1:** A category cannot be its own parent.
- **RI-4:** Replenishment quantity must not exceed the planogram limit.
- **RI-5:** A product can only be placed on a shelf that supports its category.

Other constraints are enforced using alternative SQL mechanisms. `ON DELETE CASCADE` and `ON UPDATE CASCADE` are not permitted.

## 3. SQL Queries

- **Retailers responsible for the highest number of categories**
- **Retailers managing all simple categories**
- **Products that were never replenished**
- **Products always replenished by the same retailer**

## 4. View for Sales Analysis

A database view summarizes sales data assuming all restocking corresponds to sales:

```sql
CREATE VIEW Vendas AS
SELECT 
    p.ean, c.nome AS cat, 
    EXTRACT(YEAR FROM r.instante) AS ano, 
    EXTRACT(QUARTER FROM r.instante) AS trimestre, 
    EXTRACT(DAY FROM r.instante) AS dia_mes, 
    EXTRACT(DOW FROM r.instante) AS dia_semana, 
    pr.distrito, pr.concelho, 
    r.unidades
FROM evento_reposicao r
JOIN produto p ON r.ean = p.ean
JOIN categoria c ON p.cat = c.nome
JOIN instalada_em i ON r.num_serie = i.num_serie
JOIN ponto_de_retalho pr ON i.local = pr.nome;
```

## 5. Web Application Prototype

A simple web interface (Python CGI + HTML) allows:
1. Adding/removing categories and subcategories
2. Adding/removing a retailer and its associated products (ensuring atomicity)
3. Listing all restocking events per IVM with the number of units replenished per category
4. Listing all subcategories of a super-category at any hierarchy level

**Security Considerations:**
- SQL Injection prevention
- Transaction atomicity for critical operations

## 6. OLAP Queries

Using the `Vendas` view, OLAP queries analyze sales data:

1. **Total sales by day of the week, municipality, and overall within a time range:**
   ```sql
   SELECT dia_semana, concelho, SUM(unidades) 
   FROM Vendas
   WHERE instante BETWEEN 'YYYY-MM-DD' AND 'YYYY-MM-DD'
   GROUP BY ROLLUP (dia_semana, concelho);
   ```

2. **Sales breakdown for a district (`Lisboa`) by municipality, category, day of the week, and total:**
   ```sql
   SELECT concelho, cat, dia_semana, SUM(unidades) 
   FROM Vendas
   WHERE distrito = 'Lisboa'
   GROUP BY CUBE (concelho, cat, dia_semana);
   ```

## 7. Index Optimization

To improve performance, indexes are created on critical queries:

- **Query:**
  ```sql
  SELECT DISTINCT R.nome 
  FROM retalhista R 
  JOIN responsavel_por P ON R.tin = P.tin 
  WHERE P.nome_cat = 'Frutos';
  ```
  **Optimization:** Index on `responsavel_por(nome_cat, tin)`

- **Query:**
  ```sql
  SELECT T.nome, COUNT(T.ean) 
  FROM produto P 
  JOIN tem_categoria T ON P.cat = T.nome 
  WHERE P.desc LIKE 'A%' 
  GROUP BY T.nome;
  ```
  **Optimization:** Index on `produto(desc)` to accelerate `LIKE 'A%'` searches.

## Conclusion
This project implements a robust database system for managing IVMs, ensuring efficient data storage, retrieval, and business intelligence analysis through SQL, OLAP queries, and a functional web interface.
