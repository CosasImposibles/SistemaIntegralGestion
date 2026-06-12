<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ProveedoresClientes.aspx.cs" Inherits="SistemaIntegralGestion.ProveedoresClientes" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Proveedores y Clientes</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Registro de Proveedores / Clientes</h2>
        Razón Social: <asp:TextBox ID="txtRazonSocial" runat="server"></asp:TextBox><br /><br />
        RFC: <asp:TextBox ID="txtRFC" runat="server" MaxLength="13"></asp:TextBox><br /><br />
        Tipo de Entidad: 
        <asp:DropDownList ID="ddlTipo" runat="server">
            <asp:ListItem Text="Proveedor" Value="Proveedor"></asp:ListItem>
            <asp:ListItem Text="Cliente" Value="Cliente"></asp:ListItem>
        </asp:DropDownList><br /><br />
        <asp:Button ID="btnGuardar" runat="server" Text="Registrar" OnClick="btnGuardar_Click" />
        <br /><br />
        <asp:GridView ID="gvEntidades" runat="server"></asp:GridView>
    </form>
</body>
</html>