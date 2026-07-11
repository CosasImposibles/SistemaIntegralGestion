<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Nominas.aspx.cs" Inherits="SistemaIntegralGestion.Nominas" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sistema de Nóminas Profesional</title>
    <link href="~/Content/Site.css" rel="stylesheet" />
    <style>
        /* Estilos adicionales para nóminas profesionales */
        .payroll-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            border-radius: 20px;
            margin-bottom: 30px;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3);
        }
        .payroll-hero h1 {
            font-size: 2.5rem;
            margin: 0 0 10px 0;
            font-weight: 700;
        }
        .payroll-hero p {
            font-size: 1.1rem;
            opacity: 0.95;
            margin: 0;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border-left: 4px solid var(--primary-color);
        }
        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .stat-icon {
            font-size: 2rem;
            margin-bottom: 10px;
        }
        .stat-label {
            font-size: 0.85rem;
            color: var(--text-secondary);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 5px;
        }
        .stat-value {
            font-size: 1.3rem;
            font-weight: 700;
            color: var(--primary-color);
        }
        .mode-selector {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        .mode-tabs {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
            border-bottom: 2px solid #e0e0e0;
        }
        .mode-tab {
            flex: 1;
            padding: 15px 20px;
            background: transparent;
            border: none;
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-secondary);
            cursor: pointer;
            transition: all 0.3s ease;
            position: relative;
        }
        .mode-tab.active {
            color: var(--primary-color);
        }
        .mode-tab.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--primary-color);
        }
        .mode-content {
            display: none;
        }
        .mode-content.active {
            display: block;
            animation: fadeIn 0.3s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .calculation-panel {
            background: #f8f9fa;
            padding: 25px;
            border-radius: 12px;
            margin-top: 20px;
        }
        .calculation-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
        }
        .info-alert {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin: 20px 0;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .info-alert-icon {
            font-size: 2rem;
            flex-shrink: 0;
        }
        .table-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-warning { background: #fff3cd; color: #856404; }
        .badge-info { background: #d1ecf1; color: #0c5460; }
    </style>
    <script type="text/javascript">
        function switchMode(mode) {
            // Ocultar todos los contenidos
            document.querySelectorAll('.mode-content').forEach(el => el.classList.remove('active'));
            document.querySelectorAll('.mode-tab').forEach(el => el.classList.remove('active'));

            // Mostrar el contenido seleccionado
            document.getElementById(mode + '-content').classList.add('active');
            document.getElementById(mode + '-tab').classList.add('active');

            // Actualizar campo hidden para el servidor
            document.getElementById('<%= hdnModoCalculo.ClientID %>').value = mode;
        }

        function calcularEnCliente() {
            var bruto = parseFloat(document.getElementById('<%= txtSueldoBrutoManual.ClientID %>').value) || 0;
            var isr = parseFloat(document.getElementById('<%= txtISRManual.ClientID %>').value) || 0;
            var imss = parseFloat(document.getElementById('<%= txtIMSSManual.ClientID %>').value) || 0;
            var infonavit = parseFloat(document.getElementById('<%= txtInfonavitManual.ClientID %>').value) || 0;
            var otras = parseFloat(document.getElementById('<%= txtOtrasManual.ClientID %>').value) || 0;

            var totalDeducciones = isr + imss + infonavit + otras;
            var neto = bruto - totalDeducciones;

            document.getElementById('preview-bruto').innerText = '$' + bruto.toFixed(2);
            document.getElementById('preview-deducciones').innerText = '$' + totalDeducciones.toFixed(2);
            document.getElementById('preview-neto').innerText = '$' + neto.toFixed(2);
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div class="modern-container">
            <a href="Index.aspx" class="btn-back">← Regresar al Panel Principal</a>

            <div class="payroll-hero">
                <h1>💼 Sistema de Nóminas Profesional</h1>
                <p>Gestión integral de cálculo de nómina con cumplimiento fiscal mexicano</p>
            </div>

            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon">📊</div>
                    <div class="stat-label">ISR 2024</div>
                    <div class="stat-value">Art. 96 LISR</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🏥</div>
                    <div class="stat-label">IMSS Obrero</div>
                    <div class="stat-value">2.5%</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">🏠</div>
                    <div class="stat-label">INFONAVIT</div>
                    <div class="stat-value">Variable</div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon">✅</div>
                    <div class="stat-label">Cumplimiento</div>
                    <div class="stat-value">100%</div>
                </div>
            </div>

            <div class="mode-selector">
                <h2 style="margin-bottom: 20px; color: var(--text-primary);">⚙️ Seleccionar Modo de Cálculo</h2>

                <div class="mode-tabs">
                    <button type="button" id="automatico-tab" class="mode-tab active" onclick="switchMode('automatico')">
                        🤖 Cálculo Automático
                    </button>
                    <button type="button" id="manual-tab" class="mode-tab" onclick="switchMode('manual')">
                        ✍️ Cálculo Manual
                    </button>
                </div>

                <asp:HiddenField ID="hdnModoCalculo" runat="server" Value="automatico" />

                <!-- MODO AUTOMÁTICO -->
                <div id="automatico-content" class="mode-content active">
                    <div class="info-alert">
                        <span class="info-alert-icon">🤖</span>
                        <div>
                            <strong>Modo Automático Activado</strong><br/>
                            El sistema calculará automáticamente ISR, IMSS e INFONAVIT según la normativa vigente 2024.
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">👤 Seleccione Empleado:</label>
                        <asp:DropDownList ID="ddlEmpleados" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label class="form-label">📅 Días Trabajados (Periodo):</label>
                        <asp:TextBox ID="txtDiasTrabajados" runat="server" TextMode="Number" Text="15" CssClass="form-control"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="rfvDias" runat="server" ControlToValidate="txtDiasTrabajados" 
                            ErrorMessage="Ingrese los días trabajados" CssClass="text-danger" Display="Dynamic" ValidationGroup="Auto" />
                        <asp:RangeValidator ID="rvDias" runat="server" ControlToValidate="txtDiasTrabajados" 
                            MinimumValue="1" MaximumValue="31" Type="Integer" 
                            ErrorMessage="Los días deben estar entre 1 y 31" CssClass="text-danger" Display="Dynamic" ValidationGroup="Auto" />
                    </div>

                    <asp:Button ID="btnCalcularAuto" runat="server" Text="🧮 Calcular y Registrar Nómina Automática" 
                        OnClick="btnCalcularAuto_Click" CssClass="btn-submit" ValidationGroup="Auto" />
                </div>

                <!-- MODO MANUAL -->
                <div id="manual-content" class="mode-content">
                    <div class="info-alert" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                        <span class="info-alert-icon">✍️</span>
                        <div>
                            <strong>Modo Manual Activado</strong><br/>
                            Ingrese manualmente todos los importes de deducciones. Útil para casos especiales, ajustes o correcciones.
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">👤 Seleccione Empleado:</label>
                        <asp:DropDownList ID="ddlEmpleadosManual" runat="server" CssClass="form-control"></asp:DropDownList>
                    </div>

                    <div class="calculation-panel">
                        <h3 style="margin-bottom: 20px; color: var(--text-primary);">💰 Importes Salariales</h3>

                        <div class="calculation-row">
                            <div class="form-group">
                                <label class="form-label">📅 Días Trabajados:</label>
                                <asp:TextBox ID="txtDiasManual" runat="server" TextMode="Number" Text="15" CssClass="form-control" onchange="calcularEnCliente()"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvDiasManual" runat="server" ControlToValidate="txtDiasManual" 
                                    ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" ValidationGroup="Manual" />
                            </div>

                            <div class="form-group">
                                <label class="form-label">💵 Sueldo Bruto:</label>
                                <asp:TextBox ID="txtSueldoBrutoManual" runat="server" TextMode="Number" step="0.01" CssClass="form-control" onchange="calcularEnCliente()"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvBruto" runat="server" ControlToValidate="txtSueldoBrutoManual" 
                                    ErrorMessage="Requerido" CssClass="text-danger" Display="Dynamic" ValidationGroup="Manual" />
                            </div>
                        </div>

                        <h3 style="margin: 25px 0 20px 0; color: var(--text-primary);">📉 Deducciones Detalladas</h3>

                        <div class="calculation-row">
                            <div class="form-group">
                                <label class="form-label">📊 ISR Retenido:</label>
                                <asp:TextBox ID="txtISRManual" runat="server" TextMode="Number" step="0.01" Text="0" CssClass="form-control" onchange="calcularEnCliente()"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">🏥 IMSS Obrero:</label>
                                <asp:TextBox ID="txtIMSSManual" runat="server" TextMode="Number" step="0.01" Text="0" CssClass="form-control" onchange="calcularEnCliente()"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">🏠 INFONAVIT:</label>
                                <asp:TextBox ID="txtInfonavitManual" runat="server" TextMode="Number" step="0.01" Text="0" CssClass="form-control" onchange="calcularEnCliente()"></asp:TextBox>
                            </div>

                            <div class="form-group">
                                <label class="form-label">📝 Otras Deducciones:</label>
                                <asp:TextBox ID="txtOtrasManual" runat="server" TextMode="Number" step="0.01" Text="0" CssClass="form-control" onchange="calcularEnCliente()"></asp:TextBox>
                            </div>
                        </div>

                        <div style="background: white; padding: 20px; border-radius: 10px; margin-top: 20px; border: 2px solid var(--primary-color);">
                            <h4 style="margin-top: 0; color: var(--primary-color);">📋 Vista Previa del Cálculo</h4>
                            <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; text-align: center;">
                                <div>
                                    <div style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 5px;">Sueldo Bruto</div>
                                    <div id="preview-bruto" style="font-size: 1.5rem; font-weight: 700; color: #28a745;">$0.00</div>
                                </div>
                                <div>
                                    <div style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 5px;">Total Deducciones</div>
                                    <div id="preview-deducciones" style="font-size: 1.5rem; font-weight: 700; color: #dc3545;">$0.00</div>
                                </div>
                                <div>
                                    <div style="font-size: 0.85rem; color: var(--text-secondary); margin-bottom: 5px;">Sueldo Neto</div>
                                    <div id="preview-neto" style="font-size: 1.5rem; font-weight: 700; color: var(--primary-color);">$0.00</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <asp:Button ID="btnCalcularManual" runat="server" Text="💾 Registrar Nómina Manual" 
                        OnClick="btnCalcularManual_Click" CssClass="btn-submit" ValidationGroup="Manual" 
                        style="margin-top: 20px;" />
                </div>
            </div>

            <div class="modern-table-container">
                <div class="table-header">
                    <h2 style="margin: 0; color: var(--text-primary);">📊 Historial de Nóminas Procesadas</h2>
                    <div>
                        <asp:Button ID="btnActualizar" runat="server" Text="🔄 Actualizar" OnClick="btnActualizar_Click" CssClass="btn-modern" />
                    </div>
                </div>
                <asp:GridView ID="gvNominas" runat="server" AutoGenerateColumns="false" CssClass="table">
                    <Columns>
                        <asp:BoundField DataField="NominaID" HeaderText="ID" ItemStyle-Width="60px" />
                        <asp:BoundField DataField="Empleado" HeaderText="Empleado" ItemStyle-Font-Bold="true" />
                        <asp:BoundField DataField="FechaPeriodo" HeaderText="Fecha" DataFormatString="{0:dd/MM/yyyy}" />
                        <asp:BoundField DataField="DiasTrabajados" HeaderText="Días" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="SueldoBruto" HeaderText="Sueldo Bruto" DataFormatString="{0:C2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="ISR_Retenido" HeaderText="ISR" DataFormatString="{0:C2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="IMSS_Obrero" HeaderText="IMSS" DataFormatString="{0:C2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="INFONAVIT_Descuento" HeaderText="INFONAVIT" DataFormatString="{0:C2}" ItemStyle-HorizontalAlign="Right" />
                        <asp:BoundField DataField="TotalDeducciones" HeaderText="Total Desc." DataFormatString="{0:C2}" ItemStyle-HorizontalAlign="Right" ItemStyle-ForeColor="#dc3545" />
                        <asp:BoundField DataField="TotalNeto" HeaderText="Sueldo Neto" DataFormatString="{0:C2}" ItemStyle-Font-Bold="true" ItemStyle-ForeColor="#28a745" ItemStyle-HorizontalAlign="Right" ItemStyle-Font-Size="1.1em" />
                    </Columns>
                </asp:GridView>
            </div>
        </div>
    </form>
</body>
</html>
