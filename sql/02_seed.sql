-- ====================================================================
-- Archivo: 02_seed.sql
-- Descripción: Carga los datos iniciales y prueba los procedimientos y triggers.
-- ====================================================================

-- --------------------------------------------------------------------
-- PASO 1: CREAR REGISTROS INICIALES USANDO PROCEDIMIENTOS ALMACENADOS
-- --------------------------------------------------------------------

-- Se insertan dos docentes utilizando el procedimiento almacenado 'sp_docente_crear'.
-- Esto prueba la funcionalidad de CREACIÓN (la 'C' del CRUD) para la tabla 'docente'.
CALL sp_docente_crear('CC1001', 'Ana Gómez', 'MSc. Ing. Sistemas', 6, 'Cra 10 # 5-55', 'Tiempo completo');
CALL sp_docente_crear('CC1002', 'Carlos Ruiz', 'Ing. Informático', 3, 'Cll 20 # 4-10', 'Cátedra');

-- Se guardan los IDs de los docentes recién creados en variables para usarlos más adelante.
SET @id_ana    := (SELECT docente_id FROM docente WHERE numero_documento='CC1001');
SET @id_carlos := (SELECT docente_id FROM docente WHERE numero_documento='CC1002');

-- Se insertan dos proyectos, cada uno asignado a un docente, usando 'sp_proyecto_crear'.
-- Esto prueba la funcionalidad de CREACIÓN para la tabla 'proyecto'.
CALL sp_proyecto_crear('Plataforma Académica', 'Módulos de matrícula', '2025-01-01', NULL, 25000000, 800, @id_ana);
CALL sp_proyecto_crear('Chat Soporte TI', 'Chat universitario', '2025-02-01', '2025-06-30', 12000000, 450, @id_carlos);


-- --------------------------------------------------------------------
-- PASO 2: PROBAR EL TRIGGER DE ACTUALIZACIÓN (AUDITORÍA)
-- --------------------------------------------------------------------

-- Se actualiza el registro del docente 'Carlos Ruiz' usando 'sp_docente_actualizar'.
-- Esta acción dispara automáticamente el trigger 'tr_docente_after_update',
-- que debe crear una copia del nuevo registro en la tabla 'copia_actualizados_docente'.
-- Esto prueba la 'U' (Update) del CRUD de docente y el trigger de auditoría.
CALL sp_docente_actualizar(@id_carlos, 'CC1002', 'Carlos A. Ruiz', 'Esp. Base de Datos', 4, 'Cll 20 # 4-10', 'Cátedra');


-- --------------------------------------------------------------------
-- PASO 3: PROBAR EL TRIGGER DE ELIMINACIÓN (AUDITORÍA)
-- --------------------------------------------------------------------

-- Para poder eliminar a la docente 'Ana Gómez', primero se deben eliminar los registros
-- que dependen de ella (en este caso, sus proyectos) debido a la llave foránea (FK).
DELETE FROM proyecto WHERE docente_id_jefe = @id_ana;

-- Una vez eliminados sus proyectos, se elimina a la docente 'Ana Gómez' usando 'sp_docente_eliminar'.
-- Esta acción dispara automáticamente el trigger 'tr_docente_after_delete',
-- que debe guardar los datos del docente eliminado en la tabla 'copia_eliminados_docente'.
-- Esto prueba la 'D' (Delete) del CRUD de docente y el trigger de auditoría.
CALL sp_docente_eliminar(@id_ana);