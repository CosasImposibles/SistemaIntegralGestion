<%@ Page Title="Inicio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="SistemaIntegralGestion._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <main>
        <div class="modern-header" style="margin-bottom: 40px;">
            <h1>🚀 Bienvenido al Sistema Integral de Gestión</h1>
            <p class="subtitle">Solución empresarial completa para la gestión de recursos y operaciones</p>
        </div>

        <div class="modern-grid">
            <div class="modern-card">
                <h3>💼 Gestión Empresarial</h3>
                <p>Sistema ERP completo para administrar todos los aspectos de tu negocio en un solo lugar.</p>
                <a href="Index.aspx" class="btn-modern">Acceder al Panel →</a>
            </div>

            <div class="modern-card">
                <h3>👥 Recursos Humanos</h3>
                <p>Control de empleados, nóminas automatizadas y gestión del personal de forma eficiente.</p>
                <a href="Usuarios.aspx" class="btn-modern">Ver Empleados →</a>
            </div>

            <div class="modern-card">
                <h3>📊 Gestión de Proyectos</h3>
                <p>Planifica, ejecuta y da seguimiento a tus proyectos con cronogramas y objetivos claros.</p>
                <a href="Proyectos.aspx" class="btn-modern">Ver Proyectos →</a>
            </div>
        </div>

        <div class="modern-form" style="margin-top: 40px; text-align: center;">
            <h2>Características Principales</h2>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-top: 30px; text-align: left;">
                <div>
                    <h4 style="color: var(--primary-color);">✨ Interfaz Moderna</h4>
                    <p style="color: var(--text-secondary);">Diseño intuitivo y fácil de usar</p>
                </div>
                <div>
                    <h4 style="color: var(--primary-color);">🔐 Seguro</h4>
                    <p style="color: var(--text-secondary);">Protección de datos empresariales</p>
                </div>
                <div>
                    <h4 style="color: var(--primary-color);">📱 Responsive</h4>
                    <p style="color: var(--text-secondary);">Acceso desde cualquier dispositivo</p>
                </div>
                <div>
                    <h4 style="color: var(--primary-color);">⚡ Rápido</h4>
                    <p style="color: var(--text-secondary);">Rendimiento optimizado</p>
                </div>
            </div>
        </div>
    </main>

</asp:Content>
