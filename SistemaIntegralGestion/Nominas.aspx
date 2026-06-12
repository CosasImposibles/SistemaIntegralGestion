<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Nominas.aspx.cs" Inherits="SistemaIntegralGestion.Nominas" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Cálculo de Nóminas</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Procesar Nómina de Empleado</h2>
        Seleccione Empleado: <asp:DropDownList ID="ddlEmpleados" runat="server"></asp:DropDownList><br /><br />
        <asp:Button ID="btnCalcular" runat="server" Text="Calcular y Registrar Nómina" OnClick="btnCalcular_Click" />
        <br /><br />
        <asp:GridView ID="gvNominas" runat="server"></asp:GridView>
    </form>
</body>
</html>
