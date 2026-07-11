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
    public partial class Usuarios : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["MiConexion"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) 
            { 
                CargarEmpleados(); 
            }
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            // Validar que todos los campos estén llenos
            if (!Page.IsValid)
            {
                return;
            }

            try
            {
                using (SqlConnection con = new SqlConnection(connStr))
                {
                    // Query completo con todos los campos de la tabla Empleados
                    string query = @"INSERT INTO Empleados 
                        (Nombre, ApellidoPaterno, ApellidoMaterno, CURP, RFC, Email, 
                         Telefono1, Telefono2, FechaContratacion, AreaContratacion, NSS, 
                         FechaAltaSalud, Direccion, Colonia, CodigoPostal, Ciudad, Estado, 
                         Estatus, SalarioBase) 
                        VALUES 
                        (@Nombre, @ApellidoPaterno, @ApellidoMaterno, @CURP, @RFC, @Email, 
                         @Telefono1, @Telefono2, @FechaContratacion, @AreaContratacion, @NSS, 
                         @FechaAltaSalud, @Direccion, @Colonia, @CodigoPostal, @Ciudad, @Estado, 
                         @Estatus, @SalarioBase)";

                    SqlCommand cmd = new SqlCommand(query, con);

                    // Datos personales
                    cmd.Parameters.AddWithValue("@Nombre", txtNombre.Text.Trim());
                    cmd.Parameters.AddWithValue("@ApellidoPaterno", txtApellidoPaterno.Text.Trim());
                    cmd.Parameters.AddWithValue("@ApellidoMaterno", txtApellidoMaterno.Text.Trim());
                    cmd.Parameters.AddWithValue("@CURP", txtCURP.Text.ToUpper().Trim());
                    cmd.Parameters.AddWithValue("@RFC", txtRFC.Text.ToUpper().Trim());

                    // Contacto
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                    cmd.Parameters.AddWithValue("@Telefono1", txtTelefono1.Text.Trim());

                    // Teléfono 2 es opcional
                    if (string.IsNullOrWhiteSpace(txtTelefono2.Text))
                    {
                        cmd.Parameters.AddWithValue("@Telefono2", DBNull.Value);
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@Telefono2", txtTelefono2.Text.Trim());
                    }

                    // Dirección
                    cmd.Parameters.AddWithValue("@Direccion", txtDireccion.Text.Trim());
                    cmd.Parameters.AddWithValue("@Colonia", txtColonia.Text.Trim());
                    cmd.Parameters.AddWithValue("@CodigoPostal", txtCodigoPostal.Text.Trim());
                    cmd.Parameters.AddWithValue("@Ciudad", txtCiudad.Text.Trim());
                    cmd.Parameters.AddWithValue("@Estado", ddlEstado.SelectedValue);

                    // Información laboral
                    cmd.Parameters.AddWithValue("@FechaContratacion", Convert.ToDateTime(txtFechaContratacion.Text));
                    cmd.Parameters.AddWithValue("@AreaContratacion", txtAreaContratacion.Text.Trim());
                    cmd.Parameters.AddWithValue("@NSS", txtNSS.Text.Trim());
                    cmd.Parameters.AddWithValue("@FechaAltaSalud", Convert.ToDateTime(txtFechaAltaSalud.Text));
                    cmd.Parameters.AddWithValue("@SalarioBase", Convert.ToDecimal(txtSalario.Text));
                    cmd.Parameters.AddWithValue("@Estatus", ddlEstatus.SelectedValue);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                // Limpiar formulario y recargar datos
                LimpiarFormulario();
                CargarEmpleados();

                // Mostrar mensaje de éxito (opcional)
                // ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Empleado registrado exitosamente');", true);
            }
            catch (SqlException ex)
            {
                // Manejar errores de base de datos
                if (ex.Message.Contains("UNIQUE"))
                {
                    // Error de clave duplicada (CURP, RFC, Email o NSS ya existe)
                    string mensaje = "Error: Ya existe un empleado con el mismo ";
                    if (ex.Message.Contains("CURP"))
                        mensaje += "CURP";
                    else if (ex.Message.Contains("RFC"))
                        mensaje += "RFC";
                    else if (ex.Message.Contains("Email"))
                        mensaje += "Email";
                    else if (ex.Message.Contains("NSS"))
                        mensaje += "NSS";

                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                        $"alert('{mensaje}. Por favor verifique los datos.');", true);
                }
                else
                {
                    // Otro error de SQL
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                        $"alert('Error al guardar: {ex.Message}');", true);
                }
            }
            catch (Exception ex)
            {
                // Otros errores generales
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", 
                    $"alert('Error inesperado: {ex.Message}');", true);
            }
        }

        private void CargarEmpleados()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                // Query que carga todos los empleados ordenados por fecha de contratación
                string query = @"SELECT 
                    EmpleadoID, 
                    Nombre, 
                    ApellidoPaterno, 
                    ApellidoMaterno, 
                    CURP, 
                    RFC, 
                    Email, 
                    Telefono1, 
                    AreaContratacion, 
                    SalarioBase, 
                    Estatus,
                    FechaContratacion
                FROM Empleados 
                ORDER BY FechaContratacion DESC";

                SqlDataAdapter da = new SqlDataAdapter(query, con);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvEmpleados.DataSource = dt;
                gvEmpleados.DataBind();
            }
        }

        /// <summary>
        /// Limpia todos los campos del formulario después de guardar
        /// </summary>
        private void LimpiarFormulario()
        {
            // Datos personales
            txtNombre.Text = string.Empty;
            txtApellidoPaterno.Text = string.Empty;
            txtApellidoMaterno.Text = string.Empty;
            txtCURP.Text = string.Empty;
            txtRFC.Text = string.Empty;

            // Contacto
            txtEmail.Text = string.Empty;
            txtTelefono1.Text = string.Empty;
            txtTelefono2.Text = string.Empty;

            // Dirección
            txtDireccion.Text = string.Empty;
            txtColonia.Text = string.Empty;
            txtCodigoPostal.Text = string.Empty;
            txtCiudad.Text = string.Empty;
            ddlEstado.SelectedIndex = 0;

            // Información laboral
            txtFechaContratacion.Text = string.Empty;
            txtAreaContratacion.Text = string.Empty;
            txtNSS.Text = string.Empty;
            txtFechaAltaSalud.Text = string.Empty;
            txtSalario.Text = string.Empty;
            ddlEstatus.SelectedIndex = 0;
        }
    }
}