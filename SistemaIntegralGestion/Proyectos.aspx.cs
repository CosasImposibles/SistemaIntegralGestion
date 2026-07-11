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
    public partial class Proyectos : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { CargarProyectos(); }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Proyectos (NombreProyecto, Objetivo, Metas, FechaInicio, FechaFin) VALUES (@Nombre, @Obj, @Metas, @Inicio, @Fin)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text);
                cmd.Parameters.AddWithValue("@Obj", txtObjetivo.Text);
                cmd.Parameters.AddWithValue("@Metas", txtMetas.Text);
                cmd.Parameters.AddWithValue("@Inicio", Convert.ToDateTime(txtInicio.Text));
                cmd.Parameters.AddWithValue("@Fin", Convert.ToDateTime(txtFin.Text));
                con.Open();
                cmd.ExecuteNonQuery();
            }
            CargarProyectos();
        }

        private void CargarProyectos()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Proyectos", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvProyectos.DataSource = dt;
                gvProyectos.DataBind();
            }
        }
    }
}