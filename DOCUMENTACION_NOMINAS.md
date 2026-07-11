# 📝 Documentación del Sistema de Nóminas

## 🎯 Descripción General

El módulo de nóminas calcula automáticamente los **descuentos de ley mexicanos** aplicables a cada empleado, incluyendo:

- **ISR** (Impuesto Sobre la Renta)
- **IMSS Obrero** (Cuotas del Seguro Social)
- **INFONAVIT** (Fondo de Vivienda)
- **Otras Deducciones** (Préstamos, faltas, etc.)

## 📊 Estructura de la Base de Datos

```sql
CREATE TABLE Nominas (
	NominaID INT PRIMARY KEY IDENTITY(1,1),
	EmpleadoID INT FOREIGN KEY REFERENCES Empleados(EmpleadoID),
	FechaPeriodo DATE DEFAULT GETDATE(),
	DiasTrabajados INT DEFAULT 15,           -- Quincenal por defecto
	SueldoBruto DECIMAL(18,2) NOT NULL,      -- Salario base antes de deducciones

	-- Descuentos de Ley Mexicanos
	ISR_Retenido DECIMAL(18,2) DEFAULT 0.00,      -- Art. 96 Ley del ISR
	IMSS_Obrero DECIMAL(18,2) DEFAULT 0.00,       -- Cuotas del Seguro Social
	INFONAVIT_Descuento DECIMAL(18,2) DEFAULT 0.00, -- Fondo de Vivienda
	OtrasDeducciones DECIMAL(18,2) DEFAULT 0.00,

	TotalDeducciones DECIMAL(18,2) DEFAULT 0.00,
	TotalNeto DECIMAL(18,2) NOT NULL              -- Salario neto final
);
```

## 💰 Descuentos Aplicados

### 1. ISR (Impuesto Sobre la Renta)

El cálculo del ISR se basa en la **Tabla del Artículo 96 de la Ley del ISR** para pagos quincenales 2024:

| Límite Inferior | Límite Superior | Cuota Fija | % Sobre Excedente |
|----------------|----------------|------------|-------------------|
| $0.00          | $1,768.96      | $0.00      | 1.92%            |
| $1,768.97      | $2,653.38      | $0.00      | 1.92%            |
| $2,653.39      | $4,472.84      | $16.98     | 6.40%            |
| $4,472.85      | $5,490.24      | $133.48    | 10.88%           |
| $5,490.25      | $6,538.44      | $244.21    | 16.00%           |
| $6,538.45      | $9,614.67      | $411.93    | 17.92%           |
| $9,614.68      | $19,229.33     | $963.64    | 21.36%           |
| $19,229.34     | $28,843.99     | $3,016.87  | 23.52%           |
| $28,844.00     | $48,073.32     | $5,278.45  | 30.00%           |
| $48,073.33     | $96,146.63     | $11,047.26 | 32.00%           |
| $96,146.64     | En adelante    | $26,430.67 | 35.00%           |

#### Fórmula de Cálculo:
```
ISR = Cuota Fija + ((Ingreso - Límite Inferior) * % Sobre Excedente)
```

#### Ejemplo:
Para un salario quincenal de **$8,000.00**:
- Límite inferior: $6,538.45
- Cuota fija: $411.93
- Excedente: $8,000.00 - $6,538.45 = $1,461.55
- ISR: $411.93 + ($1,461.55 × 17.92%) = **$673.89**

### 2. IMSS Obrero (Seguro Social)

El trabajador aporta aproximadamente **2.5%** de su salario para:
- Invalidez y Vida
- Cesantía en Edad Avanzada y Vejez
- Enfermedades y Maternidad

#### Fórmula:
```
IMSS Obrero = Sueldo Bruto × 2.5%
```

#### Ejemplo:
Para un salario de $8,000.00:
- IMSS: $8,000.00 × 2.5% = **$200.00**

### 3. INFONAVIT (Fondo de Vivienda)

- **Si tiene crédito activo**: Descuento del 5% del salario
- **Sin crédito**: 0% (el patrón aporta, no el trabajador)

En el sistema actual, **por defecto es 0%** (asumimos sin crédito).

#### Fórmula:
```
INFONAVIT = Sueldo Bruto × 5%  (solo si tiene crédito)
```

### 4. Otras Deducciones

- Préstamos personales
- Faltas o retardos
- Pensiones alimenticias
- Descuentos por fondo de ahorro

Por defecto: **$0.00**

## 🧮 Cálculo Completo de Nómina

### Proceso de Cálculo:

```
1. Sueldo Bruto = Salario Base del Empleado
2. ISR = Cálculo según tabla del Art. 96
3. IMSS Obrero = Sueldo Bruto × 2.5%
4. INFONAVIT = 0% (o 5% si tiene crédito)
5. Total Deducciones = ISR + IMSS + INFONAVIT + Otras
6. Sueldo Neto = Sueldo Bruto - Total Deducciones
```

### Ejemplo Completo:

**Empleado:** Juan Pérez  
**Salario Base Quincenal:** $10,000.00  
**Días Trabajados:** 15

**Cálculos:**
```
Sueldo Bruto:          $10,000.00

Deducciones:
- ISR (21.36%):        $  1,046.85
- IMSS (2.5%):         $    250.00
- INFONAVIT (0%):      $      0.00
- Otras:               $      0.00
					   -----------
Total Deducciones:     $  1,296.85

Sueldo Neto:           $  8,703.15
```

## 📋 Uso del Sistema

### 1. Calcular Nómina

1. Accede a **Nominas.aspx**
2. Selecciona un empleado del dropdown
3. Haz clic en "🧮 Calcular y Registrar Nómina"
4. El sistema:
   - Obtiene el salario base del empleado
   - Calcula ISR según la tabla oficial
   - Calcula IMSS (2.5%)
   - Aplica INFONAVIT si corresponde
   - Guarda el registro completo en la base de datos
   - Muestra el desglose en el GridView

### 2. Visualizar Historial

El GridView muestra:
- ID de Nómina
- Nombre del Empleado
- Fecha del Periodo
- Días Trabajados
- Sueldo Bruto
- ISR Retenido
- IMSS Obrero
- INFONAVIT
- Total Deducciones
- **Sueldo Neto Final**

## 🔧 Personalización

### Ajustar Porcentaje de IMSS

En `Nominas.aspx.cs`, línea ~70:
```csharp
decimal imssObrero = sueldoBruto * 0.025m; // Cambiar 0.025 (2.5%)
```

### Activar INFONAVIT

En `Nominas.aspx.cs`, línea ~74:
```csharp
// Cambiar de 0.00m a:
decimal infonavit = sueldoBruto * 0.05m; // 5% si tiene crédito
```

### Agregar Otras Deducciones

Puedes agregar lógica adicional antes de línea ~77:
```csharp
decimal otrasDeducciones = 0.00m;

// Ejemplo: descontar préstamo
if (tienePrestamoActivo)
{
	otrasDeducciones += montoPrestamo;
}

// Ejemplo: descontar faltas
if (diasFaltas > 0)
{
	decimal descuentoPorFalta = (sueldoBruto / 15) * diasFaltas;
	otrasDeducciones += descuentoPorFalta;
}
```

## 📚 Referencias Legales

1. **Ley del Impuesto Sobre la Renta** - Artículo 96 (Tarifas y Tablas)
2. **Ley del Seguro Social** - Cuotas obrero-patronales
3. **Ley del INFONAVIT** - Descuentos por créditos de vivienda
4. **Código Fiscal de la Federación** - Obligaciones fiscales

## ⚠️ Notas Importantes

- Las **tarifas del ISR** se actualizan anualmente (estas son de 2024)
- El **porcentaje del IMSS** puede variar ligeramente según el salario y prestaciones
- El **INFONAVIT** solo se descuenta si el trabajador tiene un crédito activo
- Los cálculos son **orientativos** y deben validarse con un contador

## 🚀 Mejoras Futuras

- [ ] Agregar campo para días trabajados variables
- [ ] Configurar INFONAVIT desde la interfaz
- [ ] Calcular aguinaldo y prima vacacional
- [ ] Generar recibos de nómina en PDF
- [ ] Exportar a Excel para reportes contables
- [ ] Integración con SAT para timbrado de nómina electrónica

---

**Desarrollado para el Sistema Integral de Gestión**  
**Versión 1.0 - 2024**
