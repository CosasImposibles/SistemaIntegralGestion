<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Index.aspx.cs" Inherits="SistemaIntegralGestion.Index" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="description" content="Sistema Integral de Gestión Empresarial - ERP Profesional" />
    <title>Sistema Integral de Gestión | Panel Principal</title>
    <link href="~/Content/Site.css" rel="stylesheet" />
    <style>
        /* Estilos específicos para el panel principal */
        .hero-section {
            margin-bottom: var(--spacing-2xl);
        }

        .stats-bar {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
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
            font-size: 2.5rem;
            font-weight: 900;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .stat-label {
            color: var(--text-secondary);
            font-size: 0.9rem;
            font-weight: 600;
            margin-top: var(--spacing-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .module-icon {
            font-size: 2.5rem;
            margin-bottom: var(--spacing-md);
            display: inline-block;
            animation: bounce 2s ease-in-out infinite;
        }

        @keyframes bounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }

        .modern-card:nth-child(1) { --card-index: 0; }
        .modern-card:nth-child(2) { --card-index: 1; }
        .modern-card:nth-child(3) { --card-index: 2; }
        .modern-card:nth-child(4) { --card-index: 3; }
        .modern-card:nth-child(5) { --card-index: 4; }
        .modern-card:nth-child(6) { --card-index: 5; }

        .stat-box:nth-child(1) { --stat-index: 0; }
        .stat-box:nth-child(2) { --stat-index: 1; }
        .stat-box:nth-child(3) { --stat-index: 2; }
        .stat-box:nth-child(4) { --stat-index: 3; }

        .feature-badge {
            display: inline-block;
            background: linear-gradient(135deg, var(--success-color), var(--accent-color));
            color: white;
            padding: 4px 12px;
            border-radius: var(--radius-full);
            font-size: 0.75rem;
            font-weight: 700;
            margin-left: var(--spacing-sm);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .quick-actions {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            padding: var(--spacing-xl);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow-lg);
            margin-top: var(--spacing-2xl);
            text-align: center;
        }

        .quick-actions h3 {
            font-size: 1.5rem;
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: var(--spacing-lg);
        }

        .quick-links {
            display: flex;
            justify-content: center;
            gap: var(--spacing-md);
            flex-wrap: wrap;
        }

        .quick-link {
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: white;
            padding: var(--spacing-md) var(--spacing-xl);
            border-radius: var(--radius-md);
            text-decoration: none;
            font-weight: 700;
            transition: all var(--transition-base);
            box-shadow: var(--shadow-md);
        }

        .quick-link:hover {
            transform: translateY(-3px) scale(1.05);
            box-shadow: var(--shadow-xl);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="modern-container">

            <!-- HERO HEADER -->
            <div class="hero-section">
                <div class="modern-header">
                    <h1>🚀 Sistema Integral de Gestión Empresarial</h1>
                    <p class="subtitle">Plataforma ERP de Nivel Enterprise para Control Total de Operaciones</p>
                </div>
            </div>

            <!-- BARRA DE ESTADÍSTICAS -->
            <div class="stats-bar">
                <div class="stat-box">
                    <div class="stat-number">5</div>
                    <div class="stat-label">Módulos Activos</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number">100%</div>
                    <div class="stat-label">Cumplimiento</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number">24/7</div>
                    <div class="stat-label">Disponibilidad</div>
                </div>
                <div class="stat-box">
                    <div class="stat-number">⚡</div>
                    <div class="stat-label">Respuesta Rápida</div>
                </div>
            </div>

            <!-- GRID DE MÓDULOS PRINCIPALES -->
            <div class="modern-grid">

                <!-- MÓDULO: USUARIOS/EMPLEADOS -->
                <div class="modern-card">
                    <div class="module-icon">👥</div>
                    <h3>
                        Gestión de Personal
                        <span class="feature-badge">NUEVO</span>
                    </h3>
                    <p>
                        Sistema completo de administración de empleados con validaciones CURP, RFC, NSS 
                        y control de datos fiscales. Cumplimiento total con la normativa laboral mexicana.
                    </p>
                    <asp:HyperLink ID="lnkUsuarios" runat="server" NavigateUrl="~/Usuarios.aspx" CssClass="btn-modern">
                        Acceder al Módulo →
                    </asp:HyperLink>
                </div>

                <!-- MÓDULO: PROVEEDORES Y CLIENTES -->
                <div class="modern-card">
                    <div class="module-icon">🏢</div>
                    <h3>Entidades Comerciales</h3>
                    <p>
                        Catálogo unificado de proveedores y clientes. Gestión de RFC, razón social, 
                        contactos y relaciones comerciales en una sola plataforma integrada.
                    </p>
                    <asp:HyperLink ID="lnkProveedores" runat="server" NavigateUrl="~/ProveedoresClientes.aspx" CssClass="btn-modern">
                        Acceder al Módulo →
                    </asp:HyperLink>
                </div>

                <!-- MÓDULO: INSUMOS Y COTIZACIONES -->
                <div class="modern-card">
                    <div class="module-icon">💰</div>
                    <h3>Cotizaciones e Insumos</h3>
                    <p>
                        Control de precios, presupuestos y materiales cotizados. Soporte multimoneda 
                        con conversiones automáticas y trazabilidad completa de proveedores.
                    </p>
                    <asp:HyperLink ID="lnkInsumos" runat="server" NavigateUrl="~/Insumos.aspx" CssClass="btn-modern">
                        Acceder al Módulo →
                    </asp:HyperLink>
                </div>

                <!-- MÓDULO: NÓMINAS -->
                <div class="modern-card">
                    <div class="module-icon">💼</div>
                    <h3>
                        Nóminas Profesionales
                        <span class="feature-badge">PRO</span>
                    </h3>
                    <p>
                        Sistema dual de cálculo automático y manual. Cumplimiento fiscal SAT 2024 con 
                        cálculo de ISR, IMSS e INFONAVIT. Interfaz ultra moderna y profesional.
                    </p>
                    <asp:HyperLink ID="lnkNominas" runat="server" NavigateUrl="~/Nominas.aspx" CssClass="btn-modern">
                        Acceder al Módulo →
                    </asp:HyperLink>
                </div>

                <!-- MÓDULO: PROYECTOS -->
                <div class="modern-card">
                    <div class="module-icon">📊</div>
                    <h3>Gestión de Proyectos</h3>
                    <p>
                        Planeación estratégica, definición de objetivos, metas y cronogramas operacionales. 
                        Control de avance y asignación de recursos humanos por proyecto.
                    </p>
                    <asp:HyperLink ID="lnkProyectos" runat="server" NavigateUrl="~/Proyectos.aspx" CssClass="btn-modern">
                        Acceder al Módulo →
                    </asp:HyperLink>
                </div>

                <!-- MÓDULO: REPORTES (FUTURO) -->
                <div class="modern-card">
                    <div class="module-icon">📈</div>
                    <h3>Reportes y Análisis</h3>
                    <p>
                        Dashboards ejecutivos, KPIs en tiempo real, exportación a PDF/Excel y análisis 
                        predictivo. 
                    </p>
                    <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl="~/Reportes.aspx" CssClass="btn-modern">
                         Acceder al Módulo →
                    </asp:HyperLink>
                </div>

            </div>

            <!-- ACCIONES RÁPIDAS -->
            <div class="quick-actions">
                <h3>🎯 Accesos Directos</h3>
                <div class="quick-links">
                    <a href="Usuarios.aspx" class="quick-link">➕ Nuevo Empleado</a>
                    <a href="Nominas.aspx" class="quick-link">💵 Calcular Nómina</a>
                    <a href="Proyectos.aspx" class="quick-link">📋 Crear Proyecto</a>
                    <a href="Insumos.aspx" class="quick-link">🛒 Nueva Cotización</a>
                </div>
            </div>

        </div>
    </form>

    <script>
        // Animación de contadores cuando entra en viewport
        document.addEventListener('DOMContentLoaded', function() {
            const observerOptions = {
                threshold: 0.5
            };

            const observer = new IntersectionObserver(function(entries) {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.animationPlayState = 'running';
                    }
                });
            }, observerOptions);

            document.querySelectorAll('.stat-box').forEach(box => {
                observer.observe(box);
            });
        });
    </script>
</body>
</html>