<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="SistemaIntegralGestion.Usuarios" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Usuarios / Empleados</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Registro de Empleados</h2>
        Nombre: <asp:TextBox ID="txtNombre" runat="server"></asp:TextBox><br /><br />
        CURP: <asp:TextBox ID="txtCURP" runat="server" MaxLength="18"></asp:TextBox><br /><br />
        Email: <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox><br /><br />
        Salario Base $: <asp:TextBox ID="txtSalario" runat="server"></asp:TextBox><br /><br />
        <asp:Button ID="btnGuardar" runat="server" Text="Guardar Empleado" OnClick="btnGuardar_Click" />
        <br /><br />
        <asp:GridView ID="gvEmpleados" runat="server" AutoGenerateColumns="true"></asp:GridView>
    </form>
</body>
</html>