CREATE DATABASE SistemaIntegralGestionDB;
GO

USE SistemaIntegralGestionDB;
GO


CREATE TABLE Empleados (
    EmpleadoID INT PRIMARY KEY IDENTITY(1,1),
    Nombre VARCHAR(100) NOT NULL,
    CURP VARCHAR(18) UNIQUE NOT NULL,
    Email VARCHAR(100),
    SalarioBase DECIMAL(18,2) NOT NULL
);

CREATE TABLE Entidades (
    EntidadID INT PRIMARY KEY IDENTITY(1,1),
    RazonSocial VARCHAR(150) NOT NULL,
    RFC VARCHAR(13) UNIQUE NOT NULL,
    Tipo VARCHAR(20) CHECK (Tipo IN ('Proveedor', 'Cliente'))
);


CREATE TABLE InsumosCotizaciones (
    CotizacionID INT PRIMARY KEY IDENTITY(1,1),
    ProveedorID INT FOREIGN KEY REFERENCES Entidades(EntidadID),
    Insumo VARCHAR(100) NOT NULL,
    Precio DECIMAL(18,2) NOT NULL
);

CREATE TABLE Nominas (
    NominaID INT PRIMARY KEY IDENTITY(1,1),
    EmpleadoID INT FOREIGN KEY REFERENCES Empleados(EmpleadoID),
    FechaPeriodo DATE DEFAULT GETDATE(),
    DescuentoLey DECIMAL(18,2), -- IMSS / ISR calculado
    TotalNeto DECIMAL(18,2)
);

CREATE TABLE Proyectos (
    ProyectoID INT PRIMARY KEY IDENTITY(1,1),
    NombreProyecto VARCHAR(150) NOT NULL,
    Objetivo TEXT,
    Metas TEXT,
    FechaInicio DATE,
    FechaFin DATE
);
GO