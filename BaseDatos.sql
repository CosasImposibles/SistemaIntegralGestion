-- ===================================================================
-- SistemaIntegralGestionDB
-- ===================================================================

CREATE DATABASE SistemaIntegralGestionDB;
GO

USE SistemaIntegralGestionDB;
GO

-- ==========================================
-- 1. CAPA DE SEGURIDAD Y ACCESO (RBAC)
-- ==========================================

CREATE TABLE Roles (
    RolID INT PRIMARY KEY IDENTITY(1,1),
    NombreRol VARCHAR(50) UNIQUE NOT NULL, -- Ejemplo: 'Administrador', 'Recursos Humanos', 'Operaciones'
    Descripcion VARCHAR(255),
    FechaCreacion DATETIME DEFAULT GETDATE()
);

-- ==========================================
-- 2. CAPA DE ENTIDADES HUMANAS Y OPERATIVAS
-- ==========================================

CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(50) NOT NULL,
    ApellidoPaterno VARCHAR(50) NOT NULL,
    ApellidoMaterno VARCHAR(50) NOT NULL,
    CURP CHAR(18) UNIQUE NOT NULL,
    RFC CHAR(13) UNIQUE NOT NULL, -- Requerido para la estructura fiscal mexicana
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono1 VARCHAR(15) NOT NULL,
    Telefono2 VARCHAR(15),
    FechaContratacion DATE NOT NULL,
    AreaContratacion VARCHAR(100) NOT NULL, -- Departamento (oficinista, bodeguero, vendedor, etc.)
    NSS CHAR(11) UNIQUE NOT NULL,          -- Número de Seguro Social
    FechaAltaSalud DATE NOT NULL,          -- Alta en el servicio de salud
    Direccion VARCHAR(150) NOT NULL,
    Colonia VARCHAR(100) NOT NULL,
    CodigoPostal CHAR(5) NOT NULL,
    Ciudad VARCHAR(100) NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    Estatus VARCHAR(20) DEFAULT 'Activo' CHECK (Estatus IN ('Activo', 'Inactivo', 'Pendiente_Eliminacion')),
    SalarioBase DECIMAL(18,2) NOT NULL DEFAULT 0.00 -- Se conserva para el módulo de nóminas posterior
);

CREATE TABLE Usuarios (
    UsuarioID INT PRIMARY KEY IDENTITY(1,1),
    EmpleadoID INT FOREIGN KEY REFERENCES Empleados(EmpleadoID),
    Username VARCHAR(50) UNIQUE NOT NULL,
    PasswordHash VARCHAR(256) NOT NULL,  -- Almacenamiento seguro cifrado
    RolID INT FOREIGN KEY REFERENCES Roles(RolID), -- Control de acceso relacional 
    Activo BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE()
);

-- ==========================================
-- 3. CONTROL DE ACCESO: AUTORIZACIONES DE ELIMINACIÓN
-- ==========================================
-- (Movido aquí porque ya existen las tablas Usuarios y Empleados)

CREATE TABLE AutorizacionesEliminacion (
    AutorizacionID INT PRIMARY KEY IDENTITY(1,1),
    TablaAfectada VARCHAR(30) NOT NULL CHECK (TablaAfectada IN ('Empleados', 'Clientes')),
    RegistroID INT NOT NULL, -- El ID del empleado o cliente que se desea eliminar
    UsuarioSolicitaID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID) NOT NULL,
    SupervisorID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID), -- Quién aprueba
    Estatus VARCHAR(20) DEFAULT 'Pendiente' CHECK (Estatus IN ('Pendiente', 'Aprobada', 'Rechazada')),
    Motivo TEXT NOT NULL,
    FechaSolicitud DATETIME DEFAULT GETDATE() NOT NULL,
    FechaResolucion DATETIME
);

-- ==========================================
-- 4. CAPA COMERCIAL (CLIENTES - ENTREGA 1)
-- ==========================================

CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY IDENTITY(1,1),
    RazonSocial_Nombre VARCHAR(150) NOT NULL, -- Soporta nombre personal o empresa
    RFC VARCHAR(13) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Telefono1 VARCHAR(15) NOT NULL,
    Telefono2 VARCHAR(15),
    ContactoPrincipal VARCHAR(100),         -- Persona física de contacto en la empresa
    Direccion VARCHAR(150) NOT NULL,
    Colonia VARCHAR(100) NOT NULL,
    CodigoPostal CHAR(5) NOT NULL,
    Ciudad VARCHAR(100) NOT NULL,
    Estado VARCHAR(50) NOT NULL,
    FechaRegistro DATE DEFAULT GETDATE() NOT NULL,
    Estatus VARCHAR(20) DEFAULT 'Activo' CHECK (Estatus IN ('Activo', 'Inactivo', 'Pendiente_Eliminacion'))
);

-- ==========================================
-- 5. CAPA DE INSUMOS Y PROVEEDORES
-- ==========================================

CREATE TABLE Entidades (
    EntidadID INT PRIMARY KEY IDENTITY(1,1),
    RazonSocial VARCHAR(150) NOT NULL,   -- Obligatorio para validez fiscal
    RFC VARCHAR(13) UNIQUE NOT NULL,     -- Soporta 12 dígitos (Moral) o 13 dígitos (Física)
    Tipo VARCHAR(20) NOT NULL CHECK (Tipo IN ('Proveedor', 'Cliente')), -- Bandera lógica de optimización
    DireccionFiscal VARCHAR(255),
    Telefono VARCHAR(15),
    EmailContacto VARCHAR(100),
    Estatus BIT DEFAULT 1
);

CREATE TABLE Monedas (
    MonedaID INT PRIMARY KEY IDENTITY(1,1),
    CodigoISO CHAR(3) UNIQUE NOT NULL,   -- Ejemplo: 'MXN', 'USD' 
    NombreMoneda VARCHAR(50) NOT NULL,
    Simbolo VARCHAR(5) NOT NULL
);

CREATE TABLE HistorialTipoCambio (
    TipoCambioID INT PRIMARY KEY IDENTITY(1,1),
    MonedaOrigenID INT FOREIGN KEY REFERENCES Monedas(MonedaID),
    MonedaDestinoID INT FOREIGN KEY REFERENCES Monedas(MonedaID),
    TasaCambio DECIMAL(18,6) NOT NULL,   -- Soporte de alta precisión para tasas de cambio 
    FechaActualizacion DATETIME DEFAULT GETDATE() -- Sincronizado mediante API de Banxico 
);

CREATE TABLE InsumosCotizaciones (
    CotizacionID INT PRIMARY KEY IDENTITY(1,1),
    ProveedorID INT FOREIGN KEY REFERENCES Entidades(EntidadID), -- Relación directa marcada en pizarra
    Insumo VARCHAR(150) NOT NULL,
    Descripcion TEXT,
    Precio DECIMAL(18,2) NOT NULL,       -- Costo unitario base
    MonedaID INT FOREIGN KEY REFERENCES Monedas(MonedaID), -- Soporte multimoneda 
    FechaCotizacion DATE DEFAULT GETDATE(),
    Estatus BIT DEFAULT 1                -- Permite saber si la cotización está vigente
);

-- ==========================================
-- 6. CAPA FINANCIERA (NÓMINAS DETALLADAS)
-- ==========================================

CREATE TABLE Nominas (
    NominaID INT PRIMARY KEY IDENTITY(1,1),
    EmpleadoID INT FOREIGN KEY REFERENCES Empleados(EmpleadoID),
    FechaPeriodo DATE DEFAULT GETDATE(),
    DiasTrabajados INT DEFAULT 15,       -- Esencial para cálculos proporcionales
    SueldoBruto DECIMAL(18,2) NOT NULL,  -- Salario base contractual antes de deducciones
    
    -- Desglose dinámico de Descuentos de Ley Mexicanos 
    ISR_Retenido DECIMAL(18,2) DEFAULT 0.00,    -- Tarifa progresiva del Art. 96 de la Ley del ISR 
    IMSS_Obrero DECIMAL(18,2) DEFAULT 0.00,     -- Cuotas de Invalidez, Vida, Cesantía, Enfermedad 
    INFONAVIT_Descuento DECIMAL(18,2) DEFAULT 0.00, -- Retención de fondo de vivienda si aplica 
    OtrasDeducciones DECIMAL(18,2) DEFAULT 0.00,
    
    TotalDeducciones DECIMAL(18,2) DEFAULT 0.00,
    TotalNeto DECIMAL(18,2) NOT NULL     -- Dinero neto final que recibe el colaborador
);

-- ==========================================
-- 7. CAPA OPERATIVA (PROYECTOS Y GANTT)
-- ==========================================

CREATE TABLE Proyectos (
    ProyectoID INT PRIMARY KEY IDENTITY(1,1),
    NombreProyecto VARCHAR(150) NOT NULL,
    Objetivo TEXT,
    Metas TEXT,
    FechaInicio DATE NOT NULL,           -- Ventanas temporales estrictas para proyección
    FechaFin DATE NOT NULL,             -- Ventanas temporales estrictas para viabilidad
    PorcentajeProgreso DECIMAL(5,2) DEFAULT 0.00, -- Progreso porcentual dinámico de la UI 
    Estatus VARCHAR(20) DEFAULT 'Planeacion' CHECK (Estatus IN ('Planeacion', 'En Desarrollo', 'Suspendido', 'Finalizado'))
);

CREATE TABLE AsignacionProyectos (
    AsignacionID INT PRIMARY KEY IDENTITY(1,1),
    ProyectoID INT FOREIGN KEY REFERENCES Proyectos(ProyectoID),
    EmpleadoID INT FOREIGN KEY REFERENCES Empleados(EmpleadoID), -- Involucrados en el proyecto 
    HorasAsignadasSemanales INT NOT NULL, -- Permite calcular y alertar sobreasignaciones 
    FechaAsignacion DATE DEFAULT GETDATE(),
    Activo BIT DEFAULT 1
);

-- ==========================================
-- 8. CAPA DE COMPRAS (HISTORIAL DE TRANSACCIONES)
-- ==========================================

CREATE TABLE OrdenesCompra (
    OrdenID INT PRIMARY KEY IDENTITY(1,1),
    ProveedorID INT FOREIGN KEY REFERENCES Entidades(EntidadID),
    FechaEmision DATETIME DEFAULT GETDATE(),
    Estatus VARCHAR(20) DEFAULT 'Pendiente' CHECK (Estatus IN ('Pendiente', 'Aprobada', 'Recibida', 'Cancelada')),
    Subtotal DECIMAL(18,2) NOT NULL,
    IVA DECIMAL(18,2) NOT NULL,
    Total DECIMAL(18,2) NOT NULL
);

CREATE TABLE OrdenesCompraDetalle (
    DetalleID INT PRIMARY KEY IDENTITY(1,1),
    OrdenID INT FOREIGN KEY REFERENCES OrdenesCompra(OrdenID),
    CotizacionID INT FOREIGN KEY REFERENCES InsumosCotizaciones(CotizacionID),
    Cantidad INT NOT NULL,
    PrecioUnitarioHistorico DECIMAL(18,2) NOT NULL -- Historial de fluctuación congelado al comprar
);

-- ==========================================
-- 9. CAPA DE INFRAESTRUCTURA Y AUDITORÍA
-- ==========================================

CREATE TABLE AuditoriaLogs (
    LogID INT PRIMARY KEY IDENTITY(1,1),
    TablaAfectada VARCHAR(50) NOT NULL,
    Accion VARCHAR(10) NOT NULL CHECK (Accion IN ('INSERT', 'UPDATE', 'DELETE')), -- Movimientos tracking 
    UsuarioID INT FOREIGN KEY REFERENCES Usuarios(UsuarioID), -- Quién hizo el cambio 
    FechaHora DATETIME DEFAULT GETDATE(),                    -- Cuándo ocurrió el cambio 
    RegistroID INT NOT NULL,                                 -- ID numérico del renglón afectado
    Detalles TEXT NOT NULL                                   -- Historial detallado o JSON en cascada
);
GO

-- ===================================================================
-- 10. DISPARADORES DE AUDITORÍA AUTOMÁTICA (TRIGGERS)
-- ===================================================================

-- Trigger para auditar cambios (UPDATES) en la tabla de Empleados
CREATE TRIGGER trg_AuditoriaEmpleados_Update
ON Empleados
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AuditoriaLogs (TablaAfectada, Accion, UsuarioID, RegistroID, Detalles)
    SELECT 
        'Empleados',
        'UPDATE',
        NULL, -- Nota: El backend (Persona 2) enviará el UsuarioID después; por ahora se inicializa en NULL
        i.EmpleadoID,
        'Cambio en empleado: ' + i.Nombre + ' (RFC: ' + i.RFC + '). ' +
        'Salario Anterior: $' + CAST(d.SalarioBase AS VARCHAR(20)) + ' -> ' +
        'Salario Nuevo: $' + CAST(i.SalarioBase AS VARCHAR(20)) + '. ' +
        'Estatus Anterior: ' + d.Estatus + ' -> Estatus Nuevo: ' + i.Estatus
    FROM inserted i
    INNER JOIN deleted d ON i.EmpleadoID = d.EmpleadoID;
END;
GO

-- Trigger para auditar eliminaciones (DELETES) en la tabla de Empleados
CREATE TRIGGER trg_AuditoriaEmpleados_Delete
ON Empleados
AFTER DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AuditoriaLogs (TablaAfectada, Accion, UsuarioID, RegistroID, Detalles)
    SELECT 
        'Empleados',
        'DELETE',
        NULL,
        d.EmpleadoID,
        'Se eliminó el registro del empleado: ' + d.Nombre + ' (RFC: ' + d.RFC + '). Salario contractual final: $' + CAST(d.SalarioBase AS VARCHAR(20))
    FROM deleted d;
END;
GO

-- ===================================================================
-- 11. DISPARADORES DE AUDITORÍA (PROYECTOS)
-- ===================================================================

CREATE TRIGGER trg_AuditoriaProyectos_Update
ON Proyectos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO AuditoriaLogs (TablaAfectada, Accion, UsuarioID, RegistroID, Detalles)
    SELECT 
        'Proyectos',
        'UPDATE',
        NULL, -- El backend (C#) deberá encargarse de registrar qué usuario inició sesión
        i.ProyectoID,
        'Actualización en proyecto: ' + i.NombreProyecto + '. ' +
        'Progreso Anterior: ' + CAST(d.PorcentajeProgreso AS VARCHAR(10)) + '% -> ' +
        'Nuevo Progreso: ' + CAST(i.PorcentajeProgreso AS VARCHAR(10)) + '%. ' +
        'Estatus Anterior: ' + d.Estatus + ' -> Nuevo Estatus: ' + i.Estatus
    FROM inserted i
    INNER JOIN deleted d ON i.ProyectoID = d.ProyectoID;
END;
GO

-- ===================================================================
-- 12. POBLADO DE CATÁLOGOS BASE (ROLES INICIALES)
-- ===================================================================

INSERT INTO Roles (NombreRol, Descripcion)
VALUES 
('Administrador', 'Acceso total al sistema, configuraciones de seguridad y logs de auditoría.'),
('Recursos Humanos', 'Gestión de empleados, modificación de salarios y generación de nóminas.'),
('Operaciones', 'Gestión de proyectos, asignación de personal y seguimiento de cronograma.');
GO

-- ===================================================================
-- 13. ÍNDICES DE OPTIMIZACIÓN
-- ===================================================================

-- Índices para búsquedas frecuentes de Usuarios/Empleados
CREATE NONCLUSTERED INDEX IX_Empleados_Busqueda 
ON Empleados (ApellidoPaterno, Ciudad, AreaContratacion);

-- Índices para búsquedas frecuentes de Clientes
CREATE NONCLUSTERED INDEX IX_Clientes_Busqueda 
ON Clientes (RazonSocial_Nombre, Estado);
GO
