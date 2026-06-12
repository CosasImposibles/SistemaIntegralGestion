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
    public partial class Insumos : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) { LlenarProveedores(); CargarCotizaciones(); }
        }

        private void LlenarProveedores()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT EntidadID, RazonSocial FROM Entidades WHERE Tipo='Proveedor'", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                ddlProveedores.DataTextField = "RazonSocial";
                ddlProveedores.DataValueField = "EntidadID";
                ddlProveedores.DataSource = dt;
                ddlProveedores.DataBind();
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = "INSERT INTO InsumosCotizaciones (ProveedorID, Insumo, Precio) VALUES (@ProvID, @Insumo, @Precio)";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@ProvID", ddlProveedores.SelectedValue);
                cmd.Parameters.AddWithValue("@Insumo", txtInsumo.Text);
                cmd.Parameters.AddWithValue("@Precio", Convert.ToDecimal(txtPrecio.Text));
                con.Open();
                cmd.ExecuteNonQuery();
            }
            CargarCotizaciones();
        }

        private void CargarCotizaciones()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                SqlDataAdapter da = new SqlDataAdapter("SELECT c.CotizacionID, e.RazonSocial as Proveedor, c.Insumo, c.Precio FROM InsumosCotizaciones c INNER JOIN Entidades e ON c.ProveedorID = e.EntidadID", con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCotizaciones.DataSource = dt;
                gvCotizaciones.DataBind();
            }
        }
    }
}