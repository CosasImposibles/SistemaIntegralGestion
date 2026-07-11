<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Insumos.aspx.cs" Inherits="SistemaIntegralGestion.Insumos" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Insumos y Cotizaciones</title>
    <link href="~/Content/Site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="modern-container">
            <a href="Index.aspx" class="btn-back">← Volver al Panel</a>

            <div class="modern-header">
                <h1>💰 Insumos y Cotizaciones</h1>
                <p class="subtitle">Control de precios y materiales</p>
            </div>

            <div class="modern-form">
                <h2>Cotizaciones por Proveedor</h2>

                <div class="form-group">
                    <label class="form-label">Seleccione Proveedor:</label>
                    <asp:DropDownList ID="ddlProveedores" runat="server"></asp:DropDownList>
                </div>

                <div class="form-group">
                    <label class="form-label">Nombre del Insumo:</label>
                    <asp:TextBox ID="txtInsumo" runat="server" placeholder="Ej: Cemento gris 50kg"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Precio Unitario ($):</label>
                    <asp:TextBox ID="txtPrecio" runat="server" TextMode="Number" placeholder="250.00"></asp:TextBox>
                </div>

                <asp:Button ID="btnGuardar" runat="server" Text="📦 Agregar Cotización" OnClick="btnGuardar_Click" CssClass="btn-submit" />
            </div>

            <div class="modern-table-container">
                <h2 style="margin-bottom: 20px; color: var(--text-primary);">📋 Lista de Cotizaciones</h2>
                <asp:GridView ID="gvCotizaciones" runat="server"></asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>