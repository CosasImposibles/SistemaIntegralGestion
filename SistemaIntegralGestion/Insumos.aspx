<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Insumos.aspx.cs" Inherits="SistemaIntegralGestion.Insumos" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Insumos y Cotizaciones</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Cotizaciones por Proveedor</h2>
        Seleccione Proveedor: <asp:DropDownList ID="ddlProveedores" runat="server"></asp:DropDownList><br /><br />
        Nombre del Insumo: <asp:TextBox ID="txtInsumo" runat="server"></asp:TextBox><br /><br />
        Precio Unitario ($): <asp:TextBox ID="txtPrecio" runat="server"></asp:TextBox><br /><br />
        <asp:Button ID="btnGuardar" runat="server" Text="Agregar Cotización" OnClick="btnGuardar_Click" />
        <br /><br />
        <asp:GridView ID="gvCotizaciones" runat="server"></asp:GridView>
    </form>
</body>
</html>