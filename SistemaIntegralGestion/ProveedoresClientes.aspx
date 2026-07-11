<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProveedoresClientes.aspx.cs" Inherits="SistemaIntegralGestion.ProveedoresClientes" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Proveedores y Clientes</title>
    <link href="~/Content/Site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="modern-container">
            <a href="Index.aspx" class="btn-back">← Volver al Panel</a>

            <div class="modern-header">
                <h1>🏢 Proveedores y Clientes</h1>
                <p class="subtitle">Administración de entidades comerciales</p>
            </div>

            <div class="modern-form">
                <h2>Registro de Proveedores / Clientes</h2>

                <div class="form-group">
                    <label class="form-label">Razón Social:</label>
                    <asp:TextBox ID="txtRazonSocial" runat="server" placeholder="Ej: Distribuidora del Norte S.A. de C.V."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">RFC (13 caracteres):</label>
                    <asp:TextBox ID="txtRFC" runat="server" MaxLength="13" placeholder="ABC123456XYZ"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Tipo de Entidad:</label>
                    <asp:DropDownList ID="ddlTipo" runat="server">
                        <asp:ListItem Text="Proveedor" Value="Proveedor"></asp:ListItem>
                        <asp:ListItem Text="Cliente" Value="Cliente"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <asp:Button ID="btnGuardar" runat="server" Text="💼 Registrar Entidad" OnClick="btnGuardar_Click" CssClass="btn-submit" />
            </div>

            <div class="modern-table-container">
                <h2 style="margin-bottom: 20px; color: var(--text-primary);">📋 Catálogo de Entidades</h2>
                <asp:GridView ID="gvEntidades" runat="server"></asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>