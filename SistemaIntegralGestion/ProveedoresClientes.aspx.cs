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
    public partial class ProveedoresClientes : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { CargarEntidades(); }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "INSERT INTO Entidades (RazonSocial, RFC, Tipo) VALUES (@Razon, @RFC, @Tipo)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Razon", txtRazonSocial.Text);
                cmd.Parameters.AddWithValue("@RFC", txtRFC.Text.ToUpper());
                cmd.Parameters.AddWithValue("@Tipo", ddlTipo.SelectedValue);
                con.Open();
                cmd.ExecuteNonQuery();
            }
            CargarEntidades();
        }

        private void CargarEntidades()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT * FROM Entidades", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvEntidades.DataSource = dt;
                gvEntidades.DataBind();
            }
        }
    }
}