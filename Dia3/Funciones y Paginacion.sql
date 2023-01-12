-- funciones de agregacion
-- funciones que permiten efectuar operaciones sobre algunas columnas para obtener

USE minimarket;
select * from productos;

-- AVG(columna) > Promedio de esa columna
select categoria_id , avg(precio)
from productos
group by categoria_id;

-- MAX (Columna)
select MAX(precio)
from productos;

-- MIN (Columna)
select MIN(precio)
from productos;

-- COUNT(columna) > cuanta cuanto registro tenemos
select COUNT(precio)
from productos;

-- SUM(columna) > suma el contenido de esa columna
-- PostgreSQL o SQL server intentamos hacer una sumatoria de una columna que no es numerica arrojara un error
select SUM(precio)
from productos;

-- PAGINACION
select * from productos
LIMIT 2  -- indicar cuantos quiero devolver
OFFSET 0; -- indicar cuantos quiero 'saltarme'

-- Ordenamiento
select * from productos
order by nombre desc , fecha_vencimiento DESC;  -- ASC > Ascendente |  DESC > Descendente


select SUM(p.precio)
from productos as p inner join categorias as c on p.categorias_id = c.id
where c.nombre = 'Otros'
group by p.id
order by fecha_vencimiento DESC
limit 1
offset 0;

ALTER TABLE almacen_producto DROP FOREIGN KEY almacen_producto_ibfk_2;
-- OPCIONES
-- RESTRICT > restringe o impide la eliminacion de nuestro padre si tiene hijos
-- CASCADE > elimina el padre y elimina a sus hijos
-- SET NULL > elimina al padre y a sus hijos les cambia el valor de esa columna a NULL
-- NO ACTION > elimina al padre PERO aun conversara su id dando como resultado un problema de integridad
-- SET DEFAULT > asigna un valor por defecto en el caso que se elimine el padre
ALTER TABLE almacen_producto ADD FOREIGN KEY (producto_id) REFERENCES productos(id) ON DELETE CASCADE;

DELETE FROM productos WHERE id = 3;
SELECT * FROM almacen_producto;