-- Asi se crea una base de datos
CREATE DATABASE practicas;

USE practicas;

-- ahora procederemos a crear nuestra primera tablas
CREATE TABLE usuarios(
id INT auto_increment unique primary key,
nombre text not null,
dni char(8) unique
);