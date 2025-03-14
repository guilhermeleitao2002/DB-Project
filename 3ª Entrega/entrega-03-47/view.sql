CREATE VIEW vendas(ean, cat, ano, trimestre, mes, dia_mes, dia_semana, distrito, concelho, unidades) AS
    SELECT e.ean, t.cat AS cat, EXTRACT(year FROM e.instante) AS ano, EXTRACT(quarter FROM e.instante) AS trimestre,
    EXTRACT (month FROM e.instante) AS mes, EXTRACT(day FROM e.instante) AS dia_mes, EXTRACT(dow FROM e.instante) AS dia_semana, p.distrito, p.concelho, e.unidades
    FROM evento_reposicao e, produto t, instalada_em i, ponto_de_retalho p
    WHERE e.ean = t.ean AND e.num_serie = i.num_serie AND e.fabricante = i.fabricante AND i."local"  = p.nome;