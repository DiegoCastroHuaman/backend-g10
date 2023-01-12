
-- Un comentario se crea con '--' ^-^
-- Asi se crea una base de datos
-- No imporat CreatE IGUAL FUNCIONA    
-- CREATE DATABASE IF NOT EXISTS practicas;

-- Indicamos que vamos a usar la bd
USE practicas;


-- Ahora vamos a crear nustrea primera table
-- TIPOS DE DATOS https://dev.mysql.com/doc/refman/8.0/en/data-types.html
-- Doc de como crear una tabla https://dev.mysql.com/doc/refman/8.0/en/create-table.html
-- La lleva primaria señala que no se puede repetir
CREATE TABLE usuarios(
-- nombre datatype [cofig__adic]
    id INT          auto_increment unique PRIMARY KEY,
    nombre TEXT     NOT NULL,
    dni CHAR(8) UNIQUE
);

-- cuando no entra, nos vamos a mysql80 y le damos en iniciar

create table tareas(
    id             INT     auto_increment primary key,
    titulo      varchar(100)     unique,
    descripcion text,
    usuario_id INT,
    -- Creo la relacion entre las tablas
    -- en foreing digo que prop de mi tabla va tener el foreign key
    -- el reference señala que columna de la tb usuarios me voy a jalar
    foreign key (usuario_id) references usuarios(id)
);

insert into usuarios (nombre, dni) values ('Diego', '70036504');

insert into usuarios (id, nombre, dni) values(default, 'Juana', '12345678');

-- Si queremos ingresar varios registros
insert into usuarios (id, nombre, dni) values(default, 'Diego', '12345671'), 
                                            (default, 'Pablo', '12345679'),
                                            (default, 'Vicente', '12345670');

insert into tareas(id, titulo, descripcion, usuario_id) values(default, 'Ir a la playa', 'Ire a la playa fin de semana', 1),
                                                              (default, 'Ir a la piscina', 'Ire a la piscina a mis clases de natacion', 2);

-- Esto sirve para visualizar la informacion
select nombre from usuarios;
-- Visualizar todas las columnas
select * from usuarios;

insert into usuarios(id, nombre, dni) values (default, 'Juana','01234567'), (default, 'Pablo','01234667');

select * from usuarios;

select * from usuarios where nombre = 'Juana';

select * from usuarios where nombre = 'Juana' and id =2;

-- Visualizar todas las tareas del usuario 1
select * from tareas where usuario_id = 1 or usuario_id = 2;

INSERT INTO tareas (id, titulo, descripcion, usuario_id) VALUES (DEFAULT, 'Ir a comer', 'Comer un sabroso pollito a la brasa', 1),
                                                                (DEFAULT, 'Comer pizza', 'Comer una sabrosa pizza con peperoni', 1);
                                                                
select * from tareas where usuario_id = 1 AND titulo LIKE "%comer%";
SELECT * FROM usuarios WHERE nombre LIKE "%O";
SELECT * FROM usuarios WHERE nombre LIKE "J%";
-- Si queremos hacer la distincion entre mayusculas y minusculas antes de poner el texto deberemos poner la palabra
-- BINARY y esto paraa que haga la comparacion a nivel de numeros de caracteres (formato ASCII)
SELECT * FROM usuarios WHERE nombre LIKE BINARY "j%";
-- _> indico cuantos caracteres debe de "saltar" para que busque el caracter indicado
SELECT * FROM usuarios WHERE nombre LIKE "_u%";
-- No visualizara el nombre con la letra en la posicion de la "u"
SELECT * FROM usuarios WHERE nombre NOT LIKE "__u%";
-- Ahora insertamos una tarea sin dueño
INSERT INTO tareas (id, titulo, descripcion, usuario_id) VALUES (DEFAULT, 'no hacer nada', 'no hacer nada porque es domingo', null);

SELECT * FROM tareas;

INSERT INTO tareas (id, titulo, descripcion, usuario_id) VALUES 
                  (DEFAULT, 'Jugar LOL', 'Jugar con mis amigos pros', 3);
-- Interseccion entre la tabla usuarios con la tabla tareas donde usuarios
SELECT * FROM usuarios INNER JOIN tareas ON usuarios.id = tareas.usuario_id;

SELECT * FROM usuarios LEFT JOIN tareas ON usuarios.id = tareas.usuarios_id;

SELECT * FROM usuarios RIGHT JOIN tareas ON usuarios.id = tareas.usuarios_id;

-- FULL outer join
-- Selecciona todos los usuarios asi no tengan tareas y todas las tareas aun asi no tengan usuarios
-- hace una mezcla completa entre los usuarios y las tareas respentando sus conexiones
SELECT * FROM usuarios LEFT JOIN tareas ON usuarios.id = tareas.usuarios_id UNION
SELECT * FROM usuarios RIGHT JOIN tareas ON usuarios.id = tareas.usuarios_id;

-- UNION mezcla o combina las dos o mas consultas en una sola "tabla virtual" peo estas consultas tienen
-- que tener el mismo numero de columnas, sino el union sera incorrecto
SELECT id FROM usuarios UNION
SELECT titulo FROM tareas;


-- concatenar > juntar combinar
-- AS  para poner nombre de la tabla
-- usemos la comillas simples '' para poner el nombre con espacio
SELECT CONCAT(titulo," " ,descripcion) AS 'nombre completo' FROM tareas;

-- devolver todos los usuarios cuyo dni contenga el numero 5
-- devolver todos los usuarios cuyo dni tengan el tercer digito 8
-- devolver todas las tareas del usuario eduardo

SELECT * FROM usuarios WHERE dni LIKE '%5%';
SELECT * FROM usuarios WHERE dni LIKE '__8%';
SELECT * FROM usuarios INNER JOIN tareas ON usuarios.id = tareas.usuario_id where nombre = 'Eduardo';