-- ===================================================================
-- Archivo: 00_create_database.sql
-- Descripción:Se crea la base de datos y la selecciona para su uso.
-- ===================================================================

-- Crea la base de datos con el nombre 'proyectos_informaticos'.
-- La cláusula 'IF NOT EXISTS' evita que se produzca un error si la base de datos ya existe.
CREATE DATABASE IF NOT EXISTS proyectos_informaticos;

-- Selecciona la base de datos 'proyectos_informaticos' para que todas las
-- sentencias SQL posteriores (como CREATE TABLE, INSERT, etc.) se ejecuten en ella.
USE proyectos_informaticos;