using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.IO;
using OfficeOpenXml;
using iTextSharp.text;
using iTextSharp.text.pdf;

namespace SistemaIntegralGestion
{
    public partial class Reportes : System.Web.UI.Page
    {
        private string connString = "Data Source=.;Initial Catalog=SistemaIntegralGestionDB;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CargarDashboard();
            }
        }

        private void CargarDashboard()
        {
            var listaAreas = new List<object>();
            var listaProyectos = new List<object>();
            decimal totalNomina = 0;
            decimal totalImpuestos = 0;
            int totalProyectosActivos = 0;

            using (SqlConnection conn = new SqlConnection(connString))
            {
                // 1. Mapeo de Vistas de Nóminas
                string queryNominas = "SELECT AreaContratacion, TotalNetoPagado, TotalImpuestosRetenidos FROM vw_Dashboard_ResumenNominas";
                using (SqlCommand cmd = new SqlCommand(queryNominas, conn))
                {
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            decimal neto = reader.IsDBNull(1) ? 0 : reader.GetDecimal(1);
                            decimal impuesto = reader.IsDBNull(2) ? 0 : reader.GetDecimal(2);

                            totalNomina += neto;
                            totalImpuestos += impuesto;

                            listaAreas.Add(new
                            {
                                Area = reader["AreaContratacion"].ToString(),
                                Monto = neto
                            });
                        }
                    }
                }

                // 2. Mapeo de Vista de Carga de Proyectos
                string queryProyectos = "SELECT NombreProyecto, PorcentajeProgreso, Estatus FROM vw_Dashboard_CargaProyectos";
                using (SqlCommand cmd = new SqlCommand(queryProyectos, conn))
                {
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string estatus = reader["Estatus"].ToString();
                            if (estatus == "En Desarrollo" || estatus == "Planeacion")
                            {
                                totalProyectosActivos++;
                            }

                            listaProyectos.Add(new
                            {
                                Nombre = reader["NombreProyecto"].ToString(),
                                Progreso = reader.GetDecimal(1)
                            });
                        }
                    }
                }
            }

            // 3. Simulación y Procesamiento de Predicción de Mercado (Volatilidad de Costos)
            var listaPrediccionMercado = new List<object>
            {
                new { Mes = "Ene", Real = 42000, Prediccion = 42000 },
                new { Mes = "Feb", Real = 44500, Prediccion = 44000 },
                new { Mes = "Mar", Real = 46000, Prediccion = 46200 },
                new { Mes = "Abr", Real = 49000, Prediccion = 48500 },
                new { Mes = "May", Real = (object)null, Prediccion = 51000 },
                new { Mes = "Jun", Real = (object)null, Prediccion = 53800 }
            };

            // 4. Procesamiento de Comparación de Precios de Proveedores (Inteligencia de Abastecimiento)
            var listaProveedores = new List<object>
            {
                new { Insumo = "Infraestructura Cloud", ProvA = 12500, ProvB = 14200, ProvC = 11800 },
                new { Insumo = "Licenciamiento Software", ProvA = 8500, ProvB = 7900, ProvC = 9100 },
                new { Insumo = "Consultoría Externa", ProvA = 22000, ProvB = 19500, ProvC = 21000 },
                new { Insumo = "Soporte Técnico Anual", ProvA = 6000, ProvB = 6500, ProvC = 5800 }
            };

            // Inyectar datos planos a tus cajas de texto de KPIs
            litKpiNomina.Text = string.Format("{0:C}", totalNomina);
            litKpiImpuestos.Text = string.Format("{0:C}", totalImpuestos);
            litKpiProyectos.Text = totalProyectosActivos.ToString();

            // Inyectar objetos serializados directamente sobre los controles literales del script
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            litJsonAreas.Text = serializer.Serialize(listaAreas);
            litJsonProyectos.Text = serializer.Serialize(listaProyectos);
            litJsonPrediccionMercado.Text = serializer.Serialize(listaPrediccionMercado);
            litJsonProveedores.Text = serializer.Serialize(listaProveedores);
        }

        protected void btnExportarExcel_Click(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT AreaContratacion AS [Área], TotalEmpleados AS [Total Colaboradores], TotalNetoPagado AS [Total Neto Distribuido] FROM vw_Dashboard_ResumenNominas";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dt);
                    }
                }
            }

            // Configuración nativa y fuertemente tipada de EPPlus v8+
            ExcelPackage.License.SetNonCommercialPersonal("Antar Haua Rodriguez");

            using (ExcelPackage package = new ExcelPackage())
            {
                ExcelWorksheet worksheet = package.Workbook.Worksheets.Add("Costos Operativos");
                worksheet.Cells["A1"].LoadFromDataTable(dt, true);
                worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();

                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment; filename=Reporte_Costos_" + DateTime.Now.ToString("yyyyMMdd") + ".xlsx");
                Response.BinaryWrite(package.GetAsByteArray());
                Response.Flush();
                Response.End();
            }
        }

        protected void btnExportarPDF_Click(object sender, EventArgs e)
        {
            DataTable dtProyectos = new DataTable();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT NombreProyecto, PorcentajeProgreso, Estatus, PersonalAsignado FROM vw_Dashboard_CargaProyectos";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        da.Fill(dtProyectos);
                    }
                }
            }

            Document pdfDoc = new Document(PageSize.LETTER, 40f, 40f, 40f, 40f);
            using (MemoryStream memoryStream = new MemoryStream())
            {
                PdfWriter writer = PdfWriter.GetInstance(pdfDoc, memoryStream);
                pdfDoc.Open();

                Font fontTitulo = FontFactory.GetFont("Helvetica", 18, Font.BOLD, BaseColor.DARK_GRAY);
                Font fontSubtitulo = FontFactory.GetFont("Helvetica", 10, Font.ITALIC, BaseColor.GRAY);
                Font fontCelda = FontFactory.GetFont("Helvetica", 10, Font.NORMAL, BaseColor.BLACK);
                Font fontCabecera = FontFactory.GetFont("Helvetica", 10, Font.BOLD, BaseColor.WHITE);

                Paragraph titulo = new Paragraph("SISTEMA INTEGRAL DE GESTIÓN", fontTitulo);
                pdfDoc.Add(titulo);

                Paragraph subtitulo = new Paragraph("Reporte de Proyectos - " + DateTime.Now.ToString("dd/MM/yyyy"), fontSubtitulo);
                subtitulo.SpacingAfter = 20f;
                pdfDoc.Add(subtitulo);

                PdfPTable table = new PdfPTable(4);
                table.WidthPercentage = 100;
                table.SetWidths(new float[] { 40f, 20f, 20f, 20f });

                string[] cabeceras = { "Proyecto", "Progreso", "Estatus", "Personal" };
                foreach (string cabecera in cabeceras)
                {
                    PdfPCell cell = new PdfPCell(new Phrase(cabecera, fontCabecera))
                    {
                        BackgroundColor = new BaseColor(78, 115, 223),
                        HorizontalAlignment = Element.ALIGN_CENTER,
                        Padding = 8f
                    };
                    table.AddCell(cell);
                }

                foreach (DataRow row in dtProyectos.Rows)
                {
                    table.AddCell(new PdfPCell(new Phrase(row["NombreProyecto"].ToString(), fontCelda)) { Padding = 6f });
                    table.AddCell(new PdfPCell(new Phrase(Convert.ToDecimal(row["PorcentajeProgreso"]).ToString("0.0") + "%", fontCelda)) { Padding = 6f, HorizontalAlignment = Element.ALIGN_RIGHT });
                    table.AddCell(new PdfPCell(new Phrase(row["Estatus"].ToString(), fontCelda)) { Padding = 6f, HorizontalAlignment = Element.ALIGN_CENTER });
                    table.AddCell(new PdfPCell(new Phrase(row["PersonalAsignado"].ToString(), fontCelda)) { Padding = 6f, HorizontalAlignment = Element.ALIGN_CENTER });
                }

                pdfDoc.Add(table);
                pdfDoc.Close();

                byte[] bytes = memoryStream.ToArray();
                Response.Clear();
                Response.ContentType = "application/pdf";
                Response.AddHeader("Content-Disposition", "attachment; filename=Reporte_Proyectos_" + DateTime.Now.ToString("yyyyMMdd") + ".pdf");
                Response.BinaryWrite(bytes);
                Response.Flush();
                Response.End();
            }
        }
    }
}