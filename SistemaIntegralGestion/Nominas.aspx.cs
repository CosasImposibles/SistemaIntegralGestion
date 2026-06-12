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
            if (!IsPostBack) { LlenarEmpleados(); CargarNominas(); }
        }

        private void LlenarEmpleados()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT EmpleadoID, Nombre FROM Empleados", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlEmpleados.DataTextField = "Nombre";
                ddlEmpleados.DataValueField = "EmpleadoID";
                ddlEmpleados.DataSource = dt;
                ddlEmpleados.DataBind();
            }
        }

        protected void btnCalcular_Click(object sender, EventArgs e)
        {
            decimal salarioBase = 0;
            int empleadoId = Convert.ToInt32(ddlEmpleados.SelectedValue);

            // 1. Obtener salario base
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlCommand cmd = new SqlCommand("SELECT SalarioBase FROM Empleados WHERE EmpleadoID = @ID", con);
                cmd.Parameters.AddWithValue("@ID", empleadoId);
                con.Open();
                salarioBase = Convert.ToDecimal(cmd.ExecuteScalar());
            }

            // 2. Lógica solicitada ("Investigar % de descuentos por ley")
            // Supongamos un 10% estimado combinado provisional de retenciones (ISR/IMSS)
            decimal descuentoLey = salarioBase * 0.10m;
            decimal totalNeto = salarioBase - descuentoLey;

            // 3. Guardar en tabla Nóminas
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Nominas (EmpleadoID, DescuentoLey, TotalNeto) VALUES (@EmpID, @Desc, @Neto)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@EmpID", empleadoId);
                cmd.Parameters.AddWithValue("@Desc", descuentoLey);
                cmd.Parameters.AddWithValue("@Neto", totalNeto);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            CargarNominas();
        }

        private void CargarNominas()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT n.NominaID, e.Nombre, n.FechaPeriodo, n.DescuentoLey, n.TotalNeto FROM Nominas n INNER JOIN Empleados e ON n.EmpleadoID = e.EmpleadoID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvNominas.DataSource = dt;
                gvNominas.DataBind();
            }
        }
    }
}