<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="SistemaIntegralGestion.Proyectos" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Proyección de Proyectos</title>
    <link href="~/Content/Site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="modern-container">
            <a href="Index.aspx" class="btn-back">← Volver al Panel</a>

            <div class="modern-header">
                <h1>📊 Proyección de Proyectos</h1>
                <p class="subtitle">Planeación estratégica y seguimiento</p>
            </div>

            <div class="modern-form">
                <h2>Alta de Proyectos</h2>

                <div class="form-group">
                    <label class="form-label">Nombre del Proyecto:</label>
                    <asp:TextBox ID="txtNombre" runat="server" placeholder="Ej: Expansión sucursal norte"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Objetivo:</label>
                    <asp:TextBox ID="txtObjetivo" runat="server" TextMode="MultiLine" placeholder="Describe el objetivo principal del proyecto..."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Metas:</label>
                    <asp:TextBox ID="txtMetas" runat="server" TextMode="MultiLine" placeholder="Lista las metas específicas..."></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Fecha de Inicio:</label>
                    <asp:TextBox ID="txtInicio" runat="server" TextMode="Date"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label class="form-label">Fecha de Fin:</label>
                    <asp:TextBox ID="txtFin" runat="server" TextMode="Date"></asp:TextBox>
                </div>

                <asp:Button ID="btnGuardar" runat="server" Text="✨ Crear Proyecto" OnClick="btnGuardar_Click" CssClass="btn-submit" />
            </div>

            <div class="modern-table-container">
                <h2 style="margin-bottom: 20px; color: var(--text-primary);">📋 Lista de Proyectos</h2>
                <asp:GridView ID="gvProyectos" runat="server"></asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>