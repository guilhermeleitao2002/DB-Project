--  1
SELECT  "name" 
FROM retalhista
WHERE tin IN (
    SELECT tin
    FROM responsavel_por
    GROUP BY tin
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*)
        FROM responsavel_por
        GROUP BY tin
    )
);

--  2
select "name"
from retalhista 
where tin in (
    SELECT tin
    FROM responsavel_por, categoria_simples
    WHERE responsavel_por.nome_cat = categoria_simples.nome
    GROUP BY(tin)
    HAVING COUNT(*) >= ALL (
        SELECT COUNT(*) 
        FROM categoria_simples 
    )
);

--  3
SELECT ean
FROM produto
WHERE ean NOT IN (
    SELECT DISTINCT ean
    FROM evento_reposicao
);

--  4
SELECT ean
FROM (
    SELECT ean, COUNT(DISTINCT evento_reposicao.tin) AS n_retalhistas
    FROM evento_reposicao
    GROUP BY ean
) AS Q
WHERE n_retalhistas = 1;