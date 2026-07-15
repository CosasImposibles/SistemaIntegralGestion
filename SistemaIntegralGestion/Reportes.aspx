<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Reportes.aspx.cs" Inherits="SistemaIntegralGestion.Reportes" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Sistema Integral de Gestión Empresarial - Reportes y KPIs" />
    <title>Sistema Integral de Gestión | Reportes y Análisis</title>
    <link href="~/Content/Site.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* Adaptación gráfica integrada a tu framework CSS corporativo */
        .hero-section {
            margin-bottom: var(--spacing-2xl);
        }

        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: var(--spacing-lg);
            margin-bottom: var(--spacing-2xl);
        }

        .stat-box {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: var(--spacing-lg);
            border-radius: var(--radius-lg);
            text-align: center;
            box-shadow: var(--shadow-md);
            transition: all var(--transition-base);
            border: 1px solid rgba(255, 255, 255, 0.3);
            animation: fadeInUp 0.6s ease-out backwards;
            animation-delay: calc(var(--stat-index, 0) * 0.1s);
        }

        .stat-box:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-xl);
        }

        .stat-number {
            font-size: 2.2rem;
            font-weight: 900;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.85rem;
            font-weight: 600;
            margin-top: var(--spacing-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        /* Contenedores para Gráficos */
        .chart-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: var(--radius-xl);
            padding: var(--spacing-xl);
            box-shadow: var(--shadow-lg);
            border: 1px solid rgba(255, 255, 255, 0.3);
            margin-bottom: var(--spacing-xl);
        }

        .chart-title {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: var(--spacing-lg);
            display: flex;
            align-items: center;
            gap: var(--spacing-sm);
        }

        .chart-container.full-width {
            grid-column: 1 / -1;
        }

        /* Botones de acción */
        .action-bar {
            display: flex;
            justify-content: flex-end;
            gap: var(--spacing-md);
            margin-bottom: var(--spacing-xl);
        }

        .btn-export {
            padding: var(--spacing-sm) var(--spacing-xl);
            border-radius: var(--radius-md);
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: var(--spacing-sm);
            cursor: pointer;
            transition: all var(--transition-base);
            border: none;
            color: white;
            box-shadow: var(--shadow-md);
        }

        .btn-excel { background: linear-gradient(135deg, #1f8047, #13522b); }
        .btn-pdf { background: linear-gradient(135deg, #d93838, #991b1b); }

        .btn-export:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-xl);
            filter: brightness(1.1);
        }

        /* Tabla corporativa de proveedores */
        .supplier-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: var(--spacing-md);
            font-size: 0.9rem;
        }

        .supplier-table th {
            background: rgba(0, 0, 0, 0.04);
            color: var(--text-primary);
            text-align: left;
            padding: var(--spacing-md);
            font-weight: 700;
            border-bottom: 2px solid rgba(0, 0, 0, 0.08);
        }

        .supplier-table td {
            padding: var(--spacing-md);
            border-bottom: 1px solid rgba(0, 0, 0, 0.05);
            color: var(--text-secondary);
        }

        .supplier-table tr:hover {
            background: rgba(78, 115, 223, 0.05);
        }

        .badge-min {
            background: #1cc88a;
            color: white;
            padding: 2px 6px;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 700;
        }

        .stat-box:nth-child(1) { --stat-index: 0; }
        .stat-box:nth-child(2) { --stat-index: 1; }
        .stat-box:nth-child(3) { --stat-index: 2; }
        .stat-box:nth-child(4) { --stat-index: 3; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="modern-container">

            <div class="hero-section">
                <div class="modern-header">
                    <h1>📈 Reportes y Análisis Ejecutivo</h1>
                    <p class="subtitle">Monitoreo de KPIs en Tiempo Real y Generación de Estados de Operación</p>

                    <asp:HyperLink ID="lnkRegresar" runat="server" NavigateUrl="~/index.aspx" CssClass="btn-modern">
                        ⬅️ Volver al Panel Principal
                    </asp:HyperLink>
                </div>
            </div>

            <div class="action-bar">
                <asp:Button ID="btnExportarExcel" runat="server" OnClick="btnExportarExcel_Click" Text="📊 Exportar Excel" CssClass="btn-export btn-excel" />
                <asp:Button ID="btnExportarPDF" runat="server" OnClick="btnExportarPDF_Click" Text="📄 Exportar PDF" CssClass="btn-export btn-pdf" />
            </div>

            <div class="stats-bar">
                <div class="stat-box">
                    <div class="stat-number"><asp:Literal ID="litKpiNomina" runat="server">$0.00</asp:Literal></div>
                    <div class="stat-label">Inversión Nómina</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number"><asp:Literal ID="litKpiProyectos" runat="server">0</asp:Literal></div>
                    <div class="stat-label">Proyectos Activos</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number"><asp:Literal ID="litKpiImpuestos" runat="server">$0.00</asp:Literal></div>
                    <div class="stat-label">Retenciones Sat</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number">🔮</div>
                    <div class="stat-label">Análisis Predictivo</div>
                </div>
            </div>

            <div class="modern-grid">
                
                <div class="chart-container">
                    <div class="chart-title">📊 Distribución de Costos por Área</div>
                    <div style="position: relative; height:280px;">
                        <canvas id="chartAreas"></canvas>
                    </div>
                </div>

                <div class="chart-container">
                    <div class="chart-title">📐 Avance Real de Proyectos</div>
                    <div style="position: relative; height:280px;">
                        <canvas id="chartProyectos"></canvas>
                    </div>
                </div>

                <div class="chart-container full-width">
                    <div class="chart-title">🔮 Inteligencia Comercial y Predicción de Mercado</div>
                    <div style="position: relative; height:320px; width: 100%;">
                        <canvas id="chartPrediccionMercado"></canvas>
                    </div>
                </div>

                <div class="chart-container full-width">
                    <div class="chart-title">🤝 Análisis y Comparativa de Precios de Proveedores</div>
                    <div style="display: block; width: 100%; margin-top: 15px;">
                        <div style="width: 48%; float: left; margin-right: 4%;">
                            <table class="supplier-table" id="tablaProveedores">
                                <thead>
                                    <tr>
                                        <th>Insumo / Servicio</th>
                                        <th>Prov. Nexa</th>
                                        <th>Prov. Global</th>
                                        <th>Prov. Apex</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    </tbody>
                            </table>
                        </div>
                        
                        <div style="width: 48%; float: left; position: relative; height: 260px;">
                            <canvas id="chartProveedores"></canvas>
                        </div>
                        <div style="clear: both;"></div>
                    </div>
                </div>

            </div>

        </div>
    </form>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Recolección estructurada desde los controles Literales del CodeBehind
            const datosAreas = <asp:Literal ID="litJsonAreas" runat="server"></asp:Literal>;
            const datosProyectos = <asp:Literal ID="litJsonProyectos" runat="server"></asp:Literal>;
            const datosPrediccion = <asp:Literal ID="litJsonPrediccionMercado" runat="server"></asp:Literal>;
            const datosProveedores = <asp:Literal ID="litJsonProveedores" runat="server"></asp:Literal>;

            // Gráfico 1: Doughnut (Costos por Área)
            const ctxAreas = document.getElementById('chartAreas').getContext('2d');
            new Chart(ctxAreas, {
                type: 'doughnut',
                data: {
                    labels: datosAreas.map(x => x.Area),
                    datasets: [{
                        data: datosAreas.map(x => x.Monto),
                        backgroundColor: ['#4e73df', '#1cc88a', '#36b9cc', '#f6c23e', '#e74a3b']
                    }]
                },
                options: { responsive: true, maintainAspectRatio: false }
            });

            // Gráfico 2: Bar (Progreso de Proyectos)
            const ctxProyectos = document.getElementById('chartProyectos').getContext('2d');
            new Chart(ctxProyectos, {
                type: 'bar',
                data: {
                    labels: datosProyectos.map(x => x.Nombre),
                    datasets: [{
                        label: 'Progreso (%)',
                        data: datosProyectos.map(x => x.Progreso),
                        backgroundColor: '#4e73df',
                        borderRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: { y: { min: 0, max: 100 } }
                }
            });

            // Gráfico 3: Lineal Mixto (Tendencias Predictivas)
            const ctxMercado = document.getElementById('chartPrediccionMercado').getContext('2d');
            new Chart(ctxMercado, {
                type: 'line',
                data: {
                    labels: datosPrediccion.map(d => d.Mes),
                    datasets: [
                        {
                            label: 'Gasto Real Histórico ($)',
                            data: datosPredicration = datosPrediccion.map(d => d.Real),
                            borderColor: '#4e73df',
                            backgroundColor: '#4e73df',
                            borderWidth: 3,
                            pointRadius: 5,
                            spanGaps: false
                        },
                        {
                            label: 'Proyección Predictiva de Mercado ($)',
                            data: datosPrediccion.map(d => d.Prediccion),
                            borderColor: '#1cc88a',
                            borderDash: [6, 6],
                            backgroundColor: 'transparent',
                            borderWidth: 2,
                            pointRadius: 4
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'top' } },
                    scales: { y: { beginAtZero: false, grid: { color: 'rgba(0, 0, 0, 0.05)' } } }
                }
            });

            // Matrices y Lógica Dinámica de la Tabla de Proveedores
            const tbody = document.querySelector('#tablaProveedores tbody');
            datosProveedores.forEach(x => {
                const minPrecio = Math.min(x.ProvA, x.ProvB, x.ProvC);
                const format = (val) => val.toLocaleString('es-MX', { style: 'currency', currency: 'MXN' });
                const badge = (val) => val === minPrecio ? ` <span class="badge-min">Mejor Opción</span>` : '';

                const row = `<tr>
                    <td style="font-weight: 600; color: var(--text-primary);">${x.Insumo}</td>
                    <td>${format(x.ProvA)}${badge(x.ProvA)}</td>
                    <td>${format(x.ProvB)}${badge(x.ProvB)}</td>
                    <td>${format(x.ProvC)}${badge(x.ProvC)}</td>
                </tr>`;
                tbody.innerHTML += row;
            });

            // Gráfico 4: Barras Comparativas Agrupadas de Proveedores
            const ctxProv = document.getElementById('chartProveedores').getContext('2d');
            new Chart(ctxProv, {
                type: 'bar',
                data: {
                    labels: datosProveedores.map(x => x.Insumo),
                    datasets: [
                        { label: 'Nexa Corp', data: datosProveedores.map(x => x.ProvA), backgroundColor: '#4e73df' },
                        { label: 'Global Systems', data: datosProveedores.map(x => x.ProvB), backgroundColor: '#36b9cc' },
                        { label: 'Apex Solutions', data: datosProveedores.map(x => x.ProvC), backgroundColor: '#1cc88a' }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { position: 'bottom' } },
                    scales: { y: { beginAtZero: true, grid: { color: 'rgba(0, 0, 0, 0.05)' } } }
                }
            });
        });
    </script>
</body>
</html>