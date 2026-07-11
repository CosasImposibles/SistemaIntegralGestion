<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="SistemaIntegralGestion.Usuarios" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Usuarios / Empleados</title>
    <link href="~/Content/Site.css" rel="stylesheet" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="modern-container">
            <a href="Index.aspx" class="btn-back">← Volver al Panel</a>

            <div class="modern-header">
                <h1>👥 Usuarios / Empleados</h1>
                <p class="subtitle">Gestión completa del personal de la empresa</p>
            </div>

            <div class="modern-form">
                <h2>Registro de Empleados</h2>

                <!-- Sección: Datos Personales -->
                <div style="background: var(--light-bg); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                    <h3 style="color: var(--primary-color); margin-bottom: 15px;">📋 Datos Personales</h3>

                    <div class="form-group">
                        <label class="form-label">Nombre(s):</label>
                        <asp:TextBox ID="txtNombre" runat="server" placeholder="Ej: Juan"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" 
                            ErrorMessage="El nombre es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Apellido Paterno:</label>
                        <asp:TextBox ID="txtApellidoPaterno" runat="server" placeholder="Ej: Pérez"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvApellidoP" runat="server" ControlToValidate="txtApellidoPaterno" 
                            ErrorMessage="El apellido paterno es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Apellido Materno:</label>
                        <asp:TextBox ID="txtApellidoMaterno" runat="server" placeholder="Ej: García"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvApellidoM" runat="server" ControlToValidate="txtApellidoMaterno" 
                            ErrorMessage="El apellido materno es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">CURP (18 caracteres):</label>
                        <asp:TextBox ID="txtCURP" runat="server" MaxLength="18" placeholder="ABCD123456HDFRNN01"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCURP" runat="server" ControlToValidate="txtCURP" 
                            ErrorMessage="El CURP es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revCURP" runat="server" ControlToValidate="txtCURP"
                            ValidationExpression="^[A-Z]{4}\d{6}[HM][A-Z]{5}[0-9A-Z]\d$"
                            ErrorMessage="Formato de CURP inválido" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">RFC (13 caracteres):</label>
                        <asp:TextBox ID="txtRFC" runat="server" MaxLength="13" placeholder="ABCD123456XYZ"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvRFC" runat="server" ControlToValidate="txtRFC" 
                            ErrorMessage="El RFC es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <!-- Sección: Contacto -->
                <div style="background: var(--light-bg); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                    <h3 style="color: var(--primary-color); margin-bottom: 15px;">📞 Información de Contacto</h3>

                    <div class="form-group">
                        <label class="form-label">Email:</label>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="correo@ejemplo.com"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" 
                            ErrorMessage="El email es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Teléfono Principal:</label>
                        <asp:TextBox ID="txtTelefono1" runat="server" MaxLength="15" placeholder="5512345678"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvTelefono1" runat="server" ControlToValidate="txtTelefono1" 
                            ErrorMessage="El teléfono principal es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Teléfono Secundario (Opcional):</label>
                        <asp:TextBox ID="txtTelefono2" runat="server" MaxLength="15" placeholder="5587654321"></asp:TextBox>
                    </div>
                </div>

                <!-- Sección: Dirección -->
                <div style="background: var(--light-bg); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                    <h3 style="color: var(--primary-color); margin-bottom: 15px;">🏠 Dirección</h3>

                    <div class="form-group">
                        <label class="form-label">Calle y Número:</label>
                        <asp:TextBox ID="txtDireccion" runat="server" placeholder="Av. Principal #123"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDireccion" runat="server" ControlToValidate="txtDireccion" 
                            ErrorMessage="La dirección es obligatoria" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Colonia:</label>
                        <asp:TextBox ID="txtColonia" runat="server" placeholder="Centro"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvColonia" runat="server" ControlToValidate="txtColonia" 
                            ErrorMessage="La colonia es obligatoria" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Código Postal (5 dígitos):</label>
                        <asp:TextBox ID="txtCodigoPostal" runat="server" MaxLength="5" placeholder="12345"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCP" runat="server" ControlToValidate="txtCodigoPostal" 
                            ErrorMessage="El código postal es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revCP" runat="server" ControlToValidate="txtCodigoPostal"
                            ValidationExpression="^\d{5}$" ErrorMessage="Debe ser de 5 dígitos" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Ciudad:</label>
                        <asp:TextBox ID="txtCiudad" runat="server" placeholder="Ciudad de México"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvCiudad" runat="server" ControlToValidate="txtCiudad" 
                            ErrorMessage="La ciudad es obligatoria" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Estado:</label>
                        <asp:DropDownList ID="ddlEstado" runat="server">
                            <asp:ListItem Text="-- Seleccione un estado --" Value=""></asp:ListItem>
                            <asp:ListItem Text="Aguascalientes" Value="Aguascalientes"></asp:ListItem>
                            <asp:ListItem Text="Baja California" Value="Baja California"></asp:ListItem>
                            <asp:ListItem Text="Baja California Sur" Value="Baja California Sur"></asp:ListItem>
                            <asp:ListItem Text="Campeche" Value="Campeche"></asp:ListItem>
                            <asp:ListItem Text="Chiapas" Value="Chiapas"></asp:ListItem>
                            <asp:ListItem Text="Chihuahua" Value="Chihuahua"></asp:ListItem>
                            <asp:ListItem Text="Ciudad de México" Value="Ciudad de México"></asp:ListItem>
                            <asp:ListItem Text="Coahuila" Value="Coahuila"></asp:ListItem>
                            <asp:ListItem Text="Colima" Value="Colima"></asp:ListItem>
                            <asp:ListItem Text="Durango" Value="Durango"></asp:ListItem>
                            <asp:ListItem Text="Guanajuato" Value="Guanajuato"></asp:ListItem>
                            <asp:ListItem Text="Guerrero" Value="Guerrero"></asp:ListItem>
                            <asp:ListItem Text="Hidalgo" Value="Hidalgo"></asp:ListItem>
                            <asp:ListItem Text="Jalisco" Value="Jalisco"></asp:ListItem>
                            <asp:ListItem Text="México" Value="México"></asp:ListItem>
                            <asp:ListItem Text="Michoacán" Value="Michoacán"></asp:ListItem>
                            <asp:ListItem Text="Morelos" Value="Morelos"></asp:ListItem>
                            <asp:ListItem Text="Nayarit" Value="Nayarit"></asp:ListItem>
                            <asp:ListItem Text="Nuevo León" Value="Nuevo León"></asp:ListItem>
                            <asp:ListItem Text="Oaxaca" Value="Oaxaca"></asp:ListItem>
                            <asp:ListItem Text="Puebla" Value="Puebla"></asp:ListItem>
                            <asp:ListItem Text="Querétaro" Value="Querétaro"></asp:ListItem>
                            <asp:ListItem Text="Quintana Roo" Value="Quintana Roo"></asp:ListItem>
                            <asp:ListItem Text="San Luis Potosí" Value="San Luis Potosí"></asp:ListItem>
                            <asp:ListItem Text="Sinaloa" Value="Sinaloa"></asp:ListItem>
                            <asp:ListItem Text="Sonora" Value="Sonora"></asp:ListItem>
                            <asp:ListItem Text="Tabasco" Value="Tabasco"></asp:ListItem>
                            <asp:ListItem Text="Tamaulipas" Value="Tamaulipas"></asp:ListItem>
                            <asp:ListItem Text="Tlaxcala" Value="Tlaxcala"></asp:ListItem>
                            <asp:ListItem Text="Veracruz" Value="Veracruz"></asp:ListItem>
                            <asp:ListItem Text="Yucatán" Value="Yucatán"></asp:ListItem>
                            <asp:ListItem Text="Zacatecas" Value="Zacatecas"></asp:ListItem>
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="rfvEstado" runat="server" ControlToValidate="ddlEstado" 
                            InitialValue="" ErrorMessage="Debe seleccionar un estado" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>
                </div>

                <!-- Sección: Información Laboral -->
                <div style="background: var(--light-bg); padding: 20px; border-radius: var(--radius-md); margin-bottom: 20px;">
                    <h3 style="color: var(--primary-color); margin-bottom: 15px;">💼 Información Laboral</h3>

                    <div class="form-group">
                        <label class="form-label">Fecha de Contratación:</label>
                        <asp:TextBox ID="txtFechaContratacion" runat="server" TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFechaContratacion" runat="server" ControlToValidate="txtFechaContratacion" 
                            ErrorMessage="La fecha de contratación es obligatoria" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Área de Contratación:</label>
                        <asp:TextBox ID="txtAreaContratacion" runat="server" placeholder="Ej: Recursos Humanos, Ventas, Bodega"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvArea" runat="server" ControlToValidate="txtAreaContratacion" 
                            ErrorMessage="El área es obligatoria" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">NSS (Número de Seguro Social - 11 dígitos):</label>
                        <asp:TextBox ID="txtNSS" runat="server" MaxLength="11" placeholder="12345678901"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvNSS" runat="server" ControlToValidate="txtNSS" 
                            ErrorMessage="El NSS es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="revNSS" runat="server" ControlToValidate="txtNSS"
                            ValidationExpression="^\d{11}$" ErrorMessage="Debe ser de 11 dígitos" ForeColor="Red" Display="Dynamic"></asp:RegularExpressionValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Fecha de Alta en Salud:</label>
                        <asp:TextBox ID="txtFechaAltaSalud" runat="server" TextMode="Date"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvFechaAltaSalud" runat="server" ControlToValidate="txtFechaAltaSalud" 
                            ErrorMessage="La fecha de alta en salud es obligatoria" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Salario Base (Quincenal - $):</label>
                        <asp:TextBox ID="txtSalario" runat="server" TextMode="Number" placeholder="15000.00" step="0.01"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvSalario" runat="server" ControlToValidate="txtSalario" 
                            ErrorMessage="El salario es obligatorio" ForeColor="Red" Display="Dynamic"></asp:RequiredFieldValidator>
                        <asp:RangeValidator ID="rvSalario" runat="server" ControlToValidate="txtSalario"
                            MinimumValue="0" MaximumValue="999999" Type="Double"
                            ErrorMessage="El salario debe ser mayor a 0" ForeColor="Red" Display="Dynamic"></asp:RangeValidator>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Estatus:</label>
                        <asp:DropDownList ID="ddlEstatus" runat="server">
                            <asp:ListItem Text="Activo" Value="Activo" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="Inactivo" Value="Inactivo"></asp:ListItem>
                            <asp:ListItem Text="Pendiente_Eliminacion" Value="Pendiente_Eliminacion"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>

                <asp:Button ID="btnGuardar" runat="server" Text="💾 Guardar Empleado" OnClick="btnGuardar_Click" CssClass="btn-submit" />
            </div>

            <div class="modern-table-container">
                <h2 style="margin-bottom: 20px; color: var(--text-primary);">📋 Lista de Empleados</h2>
                <asp:GridView ID="gvEmpleados" runat="server" AutoGenerateColumns="false" CssClass="table">
                    <Columns>
                        <asp:BoundField DataField="EmpleadoID" HeaderText="ID" />
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                        <asp:BoundField DataField="ApellidoPaterno" HeaderText="Apellido P." />
                        <asp:BoundField DataField="ApellidoMaterno" HeaderText="Apellido M." />
                        <asp:BoundField DataField="CURP" HeaderText="CURP" />
                        <asp:BoundField DataField="RFC" HeaderText="RFC" />
                        <asp:BoundField DataField="Email" HeaderText="Email" />
                        <asp:BoundField DataField="Telefono1" HeaderText="Teléfono" />
                        <asp:BoundField DataField="AreaContratacion" HeaderText="Área" />
                        <asp:BoundField DataField="SalarioBase" HeaderText="Salario" DataFormatString="{0:C2}" />
                        <asp:BoundField DataField="Estatus" HeaderText="Estatus" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>