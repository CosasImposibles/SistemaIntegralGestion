-- ===================================================================
-- SCRIPT DE PRUEBA - MÓDULO DE EMPLEADOS
-- Sistema Integral de Gestión
-- ===================================================================

USE SistemaIntegralGestionDB;
GO

-- ===================================================================
-- 1. VERIFICAR ESTRUCTURA DE LA TABLA EMPLEADOS
-- ===================================================================

-- Ver la estructura de la tabla
SELECT 
	COLUMN_NAME,
	DATA_TYPE,
	CHARACTER_MAXIMUM_LENGTH,
	IS_NULLABLE,
	COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Empleados'
ORDER BY ORDINAL_POSITION;
GO

-- ===================================================================
-- 2. DATOS DE PRUEBA (OPCIONAL)
-- ===================================================================

-- Insertar empleados de prueba
INSERT INTO Empleados (
	Nombre, ApellidoPaterno, ApellidoMaterno, CURP, RFC, Email,
	Telefono1, Telefono2, FechaContratacion, AreaContratacion, NSS,
	FechaAltaSalud, Direccion, Colonia, CodigoPostal, Ciudad, Estado,
	Estatus, SalarioBase
) VALUES 
(
	'Juan', 'Pérez', 'García',
	'PEGJ850101HMCRNN09', 'PEGJ850101XYZ',
	'juan.perez@empresa.com',
	'5512345678', '5587654321',
	'2024-01-15', 'Recursos Humanos', '12345678901',
	'2024-01-15',
	'Av. Reforma #123', 'Centro', '06000', 'Ciudad de México', 'Ciudad de México',
	'Activo', 15000.00
),
(
	'María', 'López', 'Martínez',
	'LOMM900215MDFPRR08', 'LOMM900215ABC',
	'maria.lopez@empresa.com',
	'5523456789', NULL,
	'2024-02-01', 'Ventas', '23456789012',
	'2024-02-01',
	'Calle Juárez #456', 'Polanco', '11560', 'Ciudad de México', 'Ciudad de México',
	'Activo', 18000.00
),
(
	'Carlos', 'Hernández', 'Sánchez',
	'HESC880520HGTRNR03', 'HESC880520DEF',
	'carlos.hernandez@empresa.com',
	'5534567890', '5598765432',
	'2023-11-10', 'Operaciones', '34567890123',
	'2023-11-10',
	'Av. Insurgentes #789', 'Roma Norte', '06700', 'Ciudad de México', 'Ciudad de México',
	'Activo', 20000.00
);
GO

-- ===================================================================
-- 3. CONSULTAS DE VERIFICACIÓN
-- ===================================================================

-- Ver todos los empleados registrados
SELECT * FROM Empleados ORDER BY FechaContratacion DESC;
GO

-- Ver empleados activos solamente
SELECT 
	EmpleadoID,
	Nombre + ' ' + ApellidoPaterno + ' ' + ApellidoMaterno AS NombreCompleto,
	CURP,
	RFC,
	Email,
	AreaContratacion,
	SalarioBase,
	Estatus
FROM Empleados
WHERE Estatus = 'Activo'
ORDER BY FechaContratacion DESC;
GO

-- Estadísticas de empleados
SELECT 
	COUNT(*) AS TotalEmpleados,
	SUM(CASE WHEN Estatus = 'Activo' THEN 1 ELSE 0 END) AS Activos,
	SUM(CASE WHEN Estatus = 'Inactivo' THEN 1 ELSE 0 END) AS Inactivos,
	AVG(SalarioBase) AS SalarioPromedio,
	MIN(SalarioBase) AS SalarioMinimo,
	MAX(SalarioBase) AS SalarioMaximo
FROM Empleados;
GO

-- Empleados por área
SELECT 
	AreaContratacion,
	COUNT(*) AS NumeroEmpleados,
	AVG(SalarioBase) AS SalarioPromedio
FROM Empleados
WHERE Estatus = 'Activo'
GROUP BY AreaContratacion
ORDER BY NumeroEmpleados DESC;
GO

-- ===================================================================
-- 4. PRUEBAS DE VALIDACIÓN DE UNICIDAD
-- ===================================================================

-- Intentar insertar un CURP duplicado (debe fallar)
/*
INSERT INTO Empleados (
	Nombre, ApellidoPaterno, ApellidoMaterno, CURP, RFC, Email,
	Telefono1, FechaContratacion, AreaContratacion, NSS,
	FechaAltaSalud, Direccion, Colonia, CodigoPostal, Ciudad, Estado,
	Estatus, SalarioBase
) VALUES (
	'Pedro', 'González', 'Ramírez',
	'PEGJ850101HMCRNN09', -- CURP duplicado
	'GORP850101XYZ',
	'pedro.gonzalez@empresa.com',
	'5545678901',
	'2024-03-01', 'Marketing', '45678901234',
	'2024-03-01',
	'Calle 5 de Mayo #321', 'Centro', '06000', 'Ciudad de México', 'Ciudad de México',
	'Activo', 16000.00
);
-- Este INSERT debe fallar con error de violación de restricción UNIQUE
*/
GO

-- ===================================================================
-- 5. CONSULTAS ÚTILES PARA REPORTES
-- ===================================================================

-- Empleados contratados en el último mes
SELECT 
	Nombre + ' ' + ApellidoPaterno + ' ' + ApellidoMaterno AS NombreCompleto,
	FechaContratacion,
	AreaContratacion,
	SalarioBase
FROM Empleados
WHERE FechaContratacion >= DATEADD(MONTH, -1, GETDATE())
ORDER BY FechaContratacion DESC;
GO

-- Empleados por estado
SELECT 
	Estado,
	COUNT(*) AS NumeroEmpleados
FROM Empleados
WHERE Estatus = 'Activo'
GROUP BY Estado
ORDER BY NumeroEmpleados DESC;
GO

-- Empleados con salario por encima del promedio
SELECT 
	Nombre + ' ' + ApellidoPaterno + ' ' + ApellidoMaterno AS NombreCompleto,
	AreaContratacion,
	SalarioBase,
	(SELECT AVG(SalarioBase) FROM Empleados WHERE Estatus = 'Activo') AS SalarioPromedio,
	SalarioBase - (SELECT AVG(SalarioBase) FROM Empleados WHERE Estatus = 'Activo') AS DiferenciaConPromedio
FROM Empleados
WHERE Estatus = 'Activo'
	AND SalarioBase > (SELECT AVG(SalarioBase) FROM Empleados WHERE Estatus = 'Activo')
ORDER BY SalarioBase DESC;
GO

-- ===================================================================
-- 6. ACTUALIZACIÓN DE DATOS (EJEMPLOS)
-- ===================================================================

-- Actualizar salario de un empleado
/*
UPDATE Empleados
SET SalarioBase = 17000.00
WHERE EmpleadoID = 1;
-- Este UPDATE será auditado automáticamente por el trigger
*/
GO

-- Cambiar estatus de un empleado
/*
UPDATE Empleados
SET Estatus = 'Inactivo'
WHERE EmpleadoID = 2;
*/
GO

-- ===================================================================
-- 7. VERIFICAR AUDITORÍA
-- ===================================================================

-- Ver los logs de auditoría de empleados
SELECT 
	LogID,
	TablaAfectada,
	Accion,
	RegistroID,
	Detalles,
	FechaHora
FROM AuditoriaLogs
WHERE TablaAfectada = 'Empleados'
ORDER BY FechaHora DESC;
GO

-- ===================================================================
-- 8. LIMPIEZA (USAR CON PRECAUCIÓN)
-- ===================================================================

-- Eliminar todos los empleados de prueba
/*
DELETE FROM Empleados WHERE Email LIKE '%@empresa.com';
*/
GO

-- ===================================================================
-- 9. BACKUP DE SEGURIDAD
-- ===================================================================

-- Crear respaldo de la tabla Empleados
/*
SELECT * INTO Empleados_Backup_20240101
FROM Empleados;
*/
GO

-- ===================================================================
-- FIN DEL SCRIPT DE PRUEBA
-- ===================================================================

PRINT 'Script de prueba ejecutado correctamente';
PRINT 'Total de empleados registrados: ' + CAST((SELECT COUNT(*) FROM Empleados) AS VARCHAR(10));
GO
