<%@ Page Title="Contacto" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="SistemaIntegralGestion.Contact" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <main aria-labelledby="title">
        <div class="modern-header">
            <h1 id="title">📧 Contacto</h1>
            <p class="subtitle">Estamos aquí para ayudarte</p>
        </div>

        <div class="modern-grid">
            <div class="modern-card">
                <h3>📍 Dirección</h3>
                <address style="font-style: normal; color: var(--text-secondary);">
                    Av. Principal #123<br />
                    Colonia Centro<br />
                    Ciudad, CP 12345<br />
                    México
                </address>
            </div>

            <div class="modern-card">
                <h3>📞 Teléfono</h3>
                <address style="font-style: normal; color: var(--text-secondary);">
                    <abbr title="Teléfono">Tel:</abbr> +52 (55) 1234-5678<br />
                    <abbr title="WhatsApp">WhatsApp:</abbr> +52 (55) 8765-4321
                </address>
            </div>

            <div class="modern-card">
                <h3>✉️ Email</h3>
                <address style="font-style: normal; color: var(--text-secondary);">
                    <strong>Soporte:</strong><br />
                    <a href="mailto:soporte@sistemagestion.com" style="color: var(--primary-color);">soporte@sistemagestion.com</a>
                    <br /><br />
                    <strong>Ventas:</strong><br />
                    <a href="mailto:ventas@sistemagestion.com" style="color: var(--primary-color);">ventas@sistemagestion.com</a>
                </address>
            </div>
        </div>

        <div class="modern-form" style="margin-top: 30px;">
            <h2>Envíanos un Mensaje</h2>
            <div class="form-group">
                <label class="form-label">Nombre Completo:</label>
                <input type="text" class="form-control" placeholder="Tu nombre" />
            </div>
            <div class="form-group">
                <label class="form-label">Email:</label>
                <input type="email" class="form-control" placeholder="tu@email.com" />
            </div>
            <div class="form-group">
                <label class="form-label">Mensaje:</label>
                <textarea class="form-control" rows="5" placeholder="Escribe tu mensaje aquí..."></textarea>
            </div>
            <button type="button" class="btn-submit">📨 Enviar Mensaje</button>
        </div>

        <div class="modern-form" style="margin-top: 30px; text-align: center;">
            <h2>Horarios de Atención</h2>
            <p style="color: var(--text-secondary); font-size: 1.1rem; margin-top: 20px;">
                <strong>Lunes a Viernes:</strong> 9:00 AM - 6:00 PM<br />
                <strong>Sábados:</strong> 9:00 AM - 2:00 PM<br />
                <strong>Domingos:</strong> Cerrado
            </p>
        </div>
    </main>
</asp:Content>
