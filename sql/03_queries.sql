-- queries.sql (MySQL 8.0+)

-- Q0: Crear y usar la base de datos
CREATE DATABASE IF NOT EXISTS proyectos_informaticos;
USE proyectos_informaticos;

-- Q1: Proyectos y su docente jefe
SELECT p.proyecto_id, p.nombre AS proyecto, d.nombres AS docente_jefe
FROM proyecto p
JOIN docente d ON d.docente_id = p.docente_id_jefe;

-- Q2: Promedio de presupuesto por docente (UDF)
SELECT d.docente_id, d.nombres,
       fn_promedio_presupuesto_por_docente(d.docente_id) AS promedio_presupuesto
FROM docente d;

-- Q3: Verificar trigger UPDATE (auditoría)
SELECT * FROM copia_actualizados_docente
ORDER BY auditoria_id DESC
LIMIT 10;

-- Q4: Verificar trigger DELETE (auditoría)
SELECT * FROM copia_eliminados_docente
ORDER BY auditoria_id DESC
LIMIT 10;

-- Q5: Validar CHECKs
SELECT proyecto_id, nombre, fecha_inicial, fecha_final, presupuesto, horas
FROM proyecto
WHERE (fecha_final IS NULL OR fecha_final >= fecha_inicial)
  AND presupuesto >= 0
  AND horas >= 0;

-- Q6: Docentes con sus proyectos
SELECT d.docente_id, d.nombres, p.proyecto_id, p.nombre
FROM docente d
LEFT JOIN proyecto p ON d.docente_id = p.docente_id_jefe
ORDER BY d.docente_id;

-- Q7: Total de horas por docente
SELECT d.docente_id, d.nombres, SUM(p.horas) AS total_horas
FROM docente d
LEFT JOIN proyecto p ON d.docente_id = p.docente_id_jefe
GROUP BY d.docente_id, d.nombres;