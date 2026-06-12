<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="SistemaIntegralGestion.Proyectos" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Proyección de Proyectos</title>
</head>
<body>
    <form id="form1" runat="server">
        <h2>Alta de Proyectos (Proyección)</h2>
        Nombre Proyecto: <asp:TextBox ID="txtNombre" runat="server"></asp:TextBox><br /><br />
        Objetivo: <asp:TextBox ID="txtObjetivo" runat="server" TextMode="MultiLine"></asp:TextBox><br /><br />
        Metas: <asp:TextBox ID="txtMetas" runat="server" TextMode="MultiLine"></asp:TextBox><br /><br />
        Fecha Inicio (AAAA-MM-DD): <asp:TextBox ID="txtInicio" runat="server"></asp:TextBox><br /><br />
        Fecha Fin (AAAA-MM-DD): <asp:TextBox ID="txtFin" runat="server"></asp:TextBox><br /><br />
        <asp:Button ID="btnGuardar" runat="server" Text="Crear Proyecto" OnClick="btnGuardar_Click" />
        <br /><br />
        <asp:GridView ID="gvProyectos" runat="server"></asp:GridView>
    </form>
</body>
</html>