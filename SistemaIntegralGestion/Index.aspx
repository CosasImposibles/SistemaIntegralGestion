<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="SistemaIntegralGestion.Index" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Sistema Integral de Gestión - Panel Principal</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 20px;
            color: #333;
        }
        .header {
            text-align: center;
            padding: 20px 0;
            background-color: #2c3e50;
            color: white;
            border-radius: 8px;
            margin-bottom: 30px;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }
        .card {
            background-color: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
        }
        .card h3 {
            margin-top: 0;
            color: #2c3e50;
        }
        .card p {
            font-size: 14px;
            color: #7f8c8d;
            min-height: 40px;
        }
        .btn-link {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 4px;
            font-weight: bold;
            transition: background-color 0.2s;
        }
        .btn-link:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="header">
            <h1>Sistema Integral de Gestión (ERP)</h1>
            <p>Panel de Control y Acceso Directo a Módulos</p>
        </div>

        <div class="container">
            <div class="card">
                <h3>👥 Usuarios / Empleados</h3>
                <p>Gestión del personal de la empresa, altas de empleados y control de CURP.</p>
                <asp:HyperLink ID="lnkUsuarios" runat="server" NavigateUrl="~/Usuarios.aspx" CssClass="btn-link">Ir a Usuarios</asp:HyperLink>
            </div>

            <div class="card">
                <h3>🏢 Proveedores y Clientes</h3>
                <p>Administración del catálogo de clientes y proveedores mediante RFC / Razón Social.</p>
                <asp:HyperLink ID="lnkProveedores" runat="server" NavigateUrl="~/ProveedoresClientes.aspx" CssClass="btn-link">Ir a Entidades</asp:HyperLink>
            </div>

            <div class="card">
                <h3>💰 Insumos y Cotizaciones</h3>
                <p>Control de precios, presupuestos y materiales cotizados por proveedores externos.</p>
                <asp:HyperLink ID="lnkInsumos" runat="server" NavigateUrl="~/Insumos.aspx" CssClass="btn-link">Ir a Cotizaciones</asp:HyperLink>
            </div>

            <div class="card">
                <h3>📝 Nóminas</h3>
                <p>Cálculo automático de sueldos netos aplicando los descuentos de ley vigentes.</p>
                <asp:HyperLink ID="lnkNominas" runat="server" NavigateUrl="~/Nominas.aspx" CssClass="btn-link">Ir a Nóminas</asp:HyperLink>
            </div>

            <div class="card">
                <h3>📊 Proyectos (Proyección)</h3>
                <p>Planeación, objetivos, metas y cronogramas operacionales de proyectos.</p>
                <asp:HyperLink ID="lnkProyectos" runat="server" NavigateUrl="~/Proyectos.aspx" CssClass="btn-link">Ir a Proyectos</asp:HyperLink>
            </div>
        </div>
    </form>
</body>
</html>