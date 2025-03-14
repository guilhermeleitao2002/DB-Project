-- 1
SELECT dia_semana, concelho, SUM(unidades) AS "Número de artigos vendidos"
FROM Vendas
WHERE (ano>2020 or (ano=2020 and mes>11) or(ano=2020 and mes=12 and dia_mes>9))  and ano<2022
GROUP BY GROUPING SETS((dia_semana), (concelho), ())
ORDER BY (dia_semana, concelho);

-- 2
SELECT concelho, cat, dia_semana, SUM(unidades) AS "Número de artigos vendidos"
FROM Vendas
WHERE distrito = 'Lisboa'
GROUP BY GROUPING SETS((concelho), (cat), (dia_semana), ())
ORDER BY (concelho, cat, dia_semana);