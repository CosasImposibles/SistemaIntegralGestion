using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace SistemaIntegralGestion
{
    public partial class Nominas : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            { 
                LlenarEmpleados(); 
                CargarNominas(); 
            }
        }

        /// <summary>
        /// Carga la lista de empleados en ambos dropdowns (automático y manual)
        /// </summary>
        private void LlenarEmpleados()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"SELECT EmpleadoID, 
                                CONCAT(Nombre, ' ', ApellidoPaterno, ' ', ApellidoMaterno) AS NombreCompleto 
                                FROM Empleados 
                                WHERE Estatus = 'Activo'
                                ORDER BY Nombre, ApellidoPaterno";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // Llenar dropdown para modo automático
                ddlEmpleados.DataTextField = "NombreCompleto";
                ddlEmpleados.DataValueField = "EmpleadoID";
                ddlEmpleados.DataSource = dt;
                ddlEmpleados.DataBind();
                ddlEmpleados.Items.Insert(0, new ListItem("-- Seleccione un empleado --", "0"));

                // Llenar dropdown para modo manual
                ddlEmpleadosManual.DataTextField = "NombreCompleto";
                ddlEmpleadosManual.DataValueField = "EmpleadoID";
                ddlEmpleadosManual.DataSource = dt;
                ddlEmpleadosManual.DataBind();
                ddlEmpleadosManual.Items.Insert(0, new ListItem("-- Seleccione un empleado --", "0"));
            }
        }

        /// <summary>
        /// MODO AUTOMÁTICO: Cálculo automático de deducciones según ley mexicana
        /// </summary>
        protected void btnCalcularAuto_Click(object sender, EventArgs e)
        {
            try
            {
                int empleadoId = Convert.ToInt32(ddlEmpleados.SelectedValue);

                if (empleadoId == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                        "alert('⚠️ Por favor seleccione un empleado.');", true);
                    return;
                }

                int diasTrabajados = Convert.ToInt32(txtDiasTrabajados.Text);
                decimal salarioBase = 0;

                // 1. Obtener salario base del empleado
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand("SELECT SalarioBase FROM Empleados WHERE EmpleadoID = @ID", con);
                    cmd.Parameters.AddWithValue("@ID", empleadoId);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        salarioBase = Convert.ToDecimal(result);
                    }
                    else
                    {
                        ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                            "alert('❌ No se pudo obtener el salario del empleado.');", true);
                        return;
                    }
                }

                // 2. Calcular sueldo proporcional a días trabajados
                decimal sueldoBruto = (salarioBase / 15) * diasTrabajados; // Asumiendo periodo quincenal

                // 3. CÁLCULO AUTOMÁTICO DE DEDUCCIONES
                decimal isr = CalcularISR(sueldoBruto);
                decimal imssObrero = sueldoBruto * 0.025m;  // 2.5% aproximado
                decimal infonavit = 0.00m;                   // Por defecto 0% (puede mejorarse con lógica adicional)
                decimal otrasDeducciones = 0.00m;

                decimal totalDeducciones = isr + imssObrero + infonavit + otrasDeducciones;
                decimal totalNeto = sueldoBruto - totalDeducciones;

                // 4. Guardar en la base de datos
                GuardarNomina(empleadoId, diasTrabajados, sueldoBruto, isr, imssObrero, infonavit, otrasDeducciones, totalDeducciones, totalNeto);

                ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                    "alert('✅ Nómina calculada y registrada automáticamente.\\n\\n💰 Sueldo Neto: $" + totalNeto.ToString("N2") + "');", true);

                CargarNominas();
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                    "alert('❌ Error al calcular nómina automática: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }

        /// <summary>
        /// MODO MANUAL: El usuario ingresa manualmente todas las deducciones
        /// </summary>
        protected void btnCalcularManual_Click(object sender, EventArgs e)
        {
            try
            {
                int empleadoId = Convert.ToInt32(ddlEmpleadosManual.SelectedValue);

                if (empleadoId == 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                        "alert('⚠️ Por favor seleccione un empleado.');", true);
                    return;
                }

                // Obtener todos los valores ingresados manualmente
                int diasTrabajados = Convert.ToInt32(txtDiasManual.Text);
                decimal sueldoBruto = Convert.ToDecimal(txtSueldoBrutoManual.Text);
                decimal isr = Convert.ToDecimal(txtISRManual.Text);
                decimal imss = Convert.ToDecimal(txtIMSSManual.Text);
                decimal infonavit = Convert.ToDecimal(txtInfonavitManual.Text);
                decimal otras = Convert.ToDecimal(txtOtrasManual.Text);

                // Calcular totales
                decimal totalDeducciones = isr + imss + infonavit + otras;
                decimal totalNeto = sueldoBruto - totalDeducciones;

                // Validación básica
                if (totalNeto < 0)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                        "alert('⚠️ El sueldo neto no puede ser negativo. Revise las deducciones ingresadas.');", true);
                    return;
                }

                // Guardar en la base de datos
                GuardarNomina(empleadoId, diasTrabajados, sueldoBruto, isr, imss, infonavit, otras, totalDeducciones, totalNeto);

                ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                    "alert('✅ Nómina registrada manualmente con éxito.\\n\\n💰 Sueldo Neto: $" + totalNeto.ToString("N2") + "');", true);

                // Limpiar formulario manual
                LimpiarFormularioManual();
                CargarNominas();
            }
            catch (FormatException)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                    "alert('❌ Error: Verifique que todos los campos numéricos contengan valores válidos.');", true);
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                    "alert('❌ Error al registrar nómina manual: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }

        /// <summary>
        /// Método centralizado para guardar nómina en la base de datos
        /// </summary>
        private void GuardarNomina(int empleadoId, int diasTrabajados, decimal sueldoBruto, 
            decimal isr, decimal imss, decimal infonavit, decimal otras, 
            decimal totalDeducciones, decimal totalNeto)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"INSERT INTO Nominas 
                    (EmpleadoID, FechaPeriodo, DiasTrabajados, SueldoBruto, 
                     ISR_Retenido, IMSS_Obrero, INFONAVIT_Descuento, OtrasDeducciones, 
                     TotalDeducciones, TotalNeto) 
                    VALUES 
                    (@EmpID, @Fecha, @Dias, @Bruto, 
                     @ISR, @IMSS, @INFONAVIT, @Otras, 
                     @TotalDesc, @Neto)";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@EmpID", empleadoId);
                cmd.Parameters.AddWithValue("@Fecha", DateTime.Now.Date);
                cmd.Parameters.AddWithValue("@Dias", diasTrabajados);
                cmd.Parameters.AddWithValue("@Bruto", sueldoBruto);
                cmd.Parameters.AddWithValue("@ISR", isr);
                cmd.Parameters.AddWithValue("@IMSS", imss);
                cmd.Parameters.AddWithValue("@INFONAVIT", infonavit);
                cmd.Parameters.AddWithValue("@Otras", otras);
                cmd.Parameters.AddWithValue("@TotalDesc", totalDeducciones);
                cmd.Parameters.AddWithValue("@Neto", totalNeto);

                con.Open();
                cmd.ExecuteNonQuery();
            }
        }

        /// <summary>
        /// Calcula el ISR según la tabla del Artículo 96 de la Ley del ISR (simplificado quincenal 2024)
        /// </summary>
        private decimal CalcularISR(decimal ingreso)
        {
            // Tabla de ISR quincenal 2024 (simplificada)
            // Fuente: Artículo 96 de la Ley del ISR

            if (ingreso <= 1768.96m)
            {
                // Límite inferior de la tabla: 0% de ISR
                return 0.00m;
            }
            else if (ingreso <= 2653.38m)
            {
                // Tarifa: 1.92%
                decimal excedente = ingreso - 1768.96m;
                return excedente * 0.0192m;
            }
            else if (ingreso <= 4472.84m)
            {
                // Tarifa: 6.40%
                decimal limiteInferior = 2653.38m;
                decimal cuotaFija = 16.98m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.064m);
            }
            else if (ingreso <= 5490.24m)
            {
                // Tarifa: 10.88%
                decimal limiteInferior = 4472.84m;
                decimal cuotaFija = 133.48m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.1088m);
            }
            else if (ingreso <= 6538.44m)
            {
                // Tarifa: 16.00%
                decimal limiteInferior = 5490.24m;
                decimal cuotaFija = 244.21m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.16m);
            }
            else if (ingreso <= 9614.67m)
            {
                // Tarifa: 17.92%
                decimal limiteInferior = 6538.44m;
                decimal cuotaFija = 411.93m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.1792m);
            }
            else if (ingreso <= 19229.33m)
            {
                // Tarifa: 21.36%
                decimal limiteInferior = 9614.67m;
                decimal cuotaFija = 963.64m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.2136m);
            }
            else if (ingreso <= 28843.99m)
            {
                // Tarifa: 23.52%
                decimal limiteInferior = 19229.33m;
                decimal cuotaFija = 3016.87m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.2352m);
            }
            else if (ingreso <= 48073.32m)
            {
                // Tarifa: 30.00%
                decimal limiteInferior = 28843.99m;
                decimal cuotaFija = 5278.45m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.30m);
            }
            else if (ingreso <= 96146.63m)
            {
                // Tarifa: 32.00%
                decimal limiteInferior = 48073.32m;
                decimal cuotaFija = 11047.26m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.32m);
            }
            else
            {
                // Tarifa: 35.00% (máxima)
                decimal limiteInferior = 96146.63m;
                decimal cuotaFija = 26430.67m;
                decimal excedente = ingreso - limiteInferior;
                return cuotaFija + (excedente * 0.35m);
            }
        }

        /// <summary>
        /// Carga el historial de nóminas procesadas
        /// </summary>
        private void CargarNominas()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        n.NominaID,
                        CONCAT(e.Nombre, ' ', e.ApellidoPaterno, ' ', e.ApellidoMaterno) AS Empleado,
                        n.FechaPeriodo,
                        n.DiasTrabajados,
                        n.SueldoBruto,
                        n.ISR_Retenido,
                        n.IMSS_Obrero,
                        n.INFONAVIT_Descuento,
                        n.TotalDeducciones,
                        n.TotalNeto
                    FROM Nominas n 
                    INNER JOIN Empleados e ON n.EmpleadoID = e.EmpleadoID
                    ORDER BY n.FechaPeriodo DESC, n.NominaID DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvNominas.DataSource = dt;
                gvNominas.DataBind();
            }
        }

        /// <summary>
        /// Limpia los campos del formulario manual después de registrar
        /// </summary>
        private void LimpiarFormularioManual()
        {
            ddlEmpleadosManual.SelectedIndex = 0;
            txtDiasManual.Text = "15";
            txtSueldoBrutoManual.Text = string.Empty;
            txtISRManual.Text = "0";
            txtIMSSManual.Text = "0";
            txtInfonavitManual.Text = "0";
            txtOtrasManual.Text = "0";
        }

        /// <summary>
        /// Evento para actualizar el historial manualmente
        /// </summary>
        protected void btnActualizar_Click(object sender, EventArgs e)
        {
            CargarNominas();
            ClientScript.RegisterStartupScript(this.GetType(), "alert", 
                "alert('🔄 Historial actualizado correctamente.');", true);
        }
    }
}