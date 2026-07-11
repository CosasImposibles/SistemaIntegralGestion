<%@ Page Title="Acerca de" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="SistemaIntegralGestion.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <div class="modern-header">
            <h1 id="title">ℹ️ Acerca del Sistema</h1>
            <p class="subtitle">Sistema Integral de Gestión Empresarial (ERP)</p>
        </div>

        <div class="modern-form">
            <h2>Descripción del Sistema</h2>
            <p style="color: var(--text-secondary); line-height: 1.8; font-size: 1.05rem;">
                El <strong>Sistema Integral de Gestión</strong> es una solución ERP moderna diseñada para optimizar 
                los procesos empresariales. Permite gestionar recursos humanos, proveedores, clientes, cotizaciones, 
                nóminas y proyectos de manera integrada y eficiente.
            </p>
        </div>

        <div class="modern-grid" style="margin-top: 30px;">
            <div class="modern-card">
                <h3>🎯 Misión</h3>
                <p>Proporcionar herramientas tecnológicas modernas que faciliten la gestión empresarial integral.</p>
            </div>

            <div class="modern-card">
                <h3>👁️ Visión</h3>
                <p>Ser el sistema ERP de referencia para empresas que buscan eficiencia y modernidad.</p>
            </div>

            <div class="modern-card">
                <h3>💡 Valores</h3>
                <p>Innovación, Eficiencia, Seguridad y Facilidad de Uso en cada funcionalidad.</p>
            </div>
        </div>

        <div class="modern-form" style="margin-top: 30px;">
            <h2>Módulos Disponibles</h2>
            <ul style="list-style: none; padding: 0;">
                <li style="padding: 10px 0; border-bottom: 1px solid var(--border-color);">👥 <strong>Usuarios/Empleados:</strong> Gestión completa del personal</li>
                <li style="padding: 10px 0; border-bottom: 1px solid var(--border-color);">🏢 <strong>Proveedores/Clientes:</strong> Administración de entidades comerciales</li>
                <li style="padding: 10px 0; border-bottom: 1px solid var(--border-color);">💰 <strong>Insumos/Cotizaciones:</strong> Control de precios y materiales</li>
                <li style="padding: 10px 0; border-bottom: 1px solid var(--border-color);">📝 <strong>Nóminas:</strong> Cálculo automático de salarios</li>
                <li style="padding: 10px 0;">📊 <strong>Proyectos:</strong> Planeación y seguimiento estratégico</li>
            </ul>
        </div>
    </main>
</asp:Content>
