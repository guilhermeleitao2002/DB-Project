--  RI-1
create or replace function chk_super_categoria()
returns trigger as
$$
declare temp_categoria char(20);
begin 
    temp_categoria := new.super_categoria;
    while (temp_categoria IN (SELECT categoria FROM tem_outra)) loop 
        temp_categoria := (SELECT super_categoria FROM tem_outra WHERE categoria = temp_categoria);
        if (temp_categoria = new.categoria) then 
            raise exception 'Não pode haver circularidade entre categorias';
        end if;
    end loop;
    return new;
end;
$$ language plpgsql;

--  RI-4
create or replace function chk_unidades_evento_reposicao()
returns trigger as
$$
begin
    if (new.unidades > (SELECT unidades FROM planograma WHERE ean = new.ean AND nro = new.nro
    AND num_serie = new.num_serie AND fabricante = new.fabricante))
    then 
        raise exception 'Número de unidades inválido';
    end if;
    return new;
end;
$$ language plpgsql;

--  RI-5
create or replace function chk_categoria_evento_reposicao()
returns trigger as
$$
begin
    if ((SELECT nome FROM prateleira WHERE nro = new.nro AND num_serie = new.num_serie AND fabricante = new.fabricante) NOT IN 
        (SELECT nome FROM tem_categoria WHERE ean = new.ean)) then
            raise exception 'Produto não pode ser reposto numa prateleira que não 
                seja da sua categoria';
    end if; 
    return new;
end;
$$ language plpgsql;

create trigger chk_super_categoria_trigger
before update or insert on tem_outra
for each row execute procedure chk_super_categoria();

create trigger chk_evento_reposicao_trigger1
before update or insert on evento_reposicao
for each row execute procedure chk_unidades_evento_reposicao();

create trigger chk_evento_reposicao_trigger2
before update or insert on evento_reposicao
for each row execute procedure chk_categoria_evento_reposicao();