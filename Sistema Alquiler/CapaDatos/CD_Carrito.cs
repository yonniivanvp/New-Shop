using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;

namespace CapaDatos
{
    public class CD_Carrito
    {

        public bool ExisteCarrito(int idcliente, int idproducto)
        {

            bool resultado = true;
            try
            {
                // Establece la conexión con la base de datos
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_ExisteCarrito", oconexion);
                    cmd.Parameters.AddWithValue("IdCliente", idcliente);
                    cmd.Parameters.AddWithValue("IdProducto", idproducto);

                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                }
            }
            catch (Exception ex)
            {
                resultado = false;
            }

            return resultado;
        }


        public bool OperacionCarrito(int idcliente, int idproducto, string fechainicio, string fechafin, bool sumar, out string Mensaje)
        {

            bool resultado = true;

            Mensaje = string.Empty;

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_OperacionCarrito", oconexion);
                    cmd.Parameters.AddWithValue("IdCliente", idcliente);
                    cmd.Parameters.AddWithValue("IdProducto", idproducto);
                    cmd.Parameters.AddWithValue("FechaInicio", Convert.ToDateTime(fechainicio));
                    cmd.Parameters.AddWithValue("FechaFin", Convert.ToDateTime(fechafin));
                    cmd.Parameters.AddWithValue("Sumar", sumar);

                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    Mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                Mensaje = ex.Message;
            }

            return resultado;
        }


        public bool ActualizarFechaProductoCarrito(int idCliente, int idProducto, string fechaInicio, string fechaFin, out string mensaje)
        {
            bool resultado = true;
            mensaje = string.Empty;

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_ActualizarFechaProductoCarrito", oconexion);
                    cmd.Parameters.AddWithValue("IdCliente", idCliente);
                    cmd.Parameters.AddWithValue("IdProducto", idProducto);
                    cmd.Parameters.AddWithValue("FechaInicio", Convert.ToDateTime(fechaInicio));
                    cmd.Parameters.AddWithValue("FechaFin", Convert.ToDateTime(fechaFin));

                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;
                    cmd.Parameters.Add("Mensaje", SqlDbType.VarChar, 500).Direction = ParameterDirection.Output;

                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();
                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                    mensaje = cmd.Parameters["Mensaje"].Value.ToString();
                }
            }
            catch (Exception ex)
            {
                resultado = false;
                mensaje = ex.Message;
            }

            return resultado;
        }


        public int CantidadEnCarrito(int idcliente)
        {
            int resultado = 0;

            try
            {
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("select count(*) from carrito where idcliente = @idcliente", oconexion);
                    cmd.Parameters.AddWithValue("@idcliente", idcliente);
                    cmd.CommandType = CommandType.Text;
                    oconexion.Open();

                    resultado = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }
            catch (Exception ex)
            {
                resultado = 0;
            }

            return resultado;
        }


        public List<Carrito> ListarProducto(int idcliente)
        {

            List<Carrito> lista = new List<Carrito>();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "select *from fn_obtenerCarritoCliente(@idcliente)";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.Parameters.AddWithValue("@idcliente", idcliente);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new Carrito()
                            {
                                oProducto = new Producto()
                                {
                                    IdProducto = Convert.ToInt32(dr["IdProducto"]),
                                    Nombre = dr["Nombre"].ToString(),
                                    Precio = Convert.ToDecimal(dr["Precio"], new CultureInfo("es-CO")),
                                    RutaImagen = dr["RutaImagen"].ToString(),
                                    NombreImagen = dr["NombreImagen"].ToString(),
                                    oMarca = new Marca() { Descripcion = dr["DesMarca"].ToString() }
                                },
                                Cantidad = Convert.ToInt32(dr["Cantidad"]),
                                FechaInicio = dr["FechaInicio"].ToString(),
                                FechaFin = dr["FechaFin"].ToString()

                            });

                        }
                    }

                }
            }
            catch
            {
                lista = new List<Carrito>();
            }

            return lista;
        }


        public bool EliminarCarrito(int idcliente, int idproducto)
        {

            bool resultado = true;
            try
            {
                // Establece la conexión con la base de datos
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    SqlCommand cmd = new SqlCommand("sp_EliminarCarrito", oconexion);
                    cmd.Parameters.AddWithValue("IdCliente", idcliente);
                    cmd.Parameters.AddWithValue("IdProducto", idproducto);

                    cmd.Parameters.Add("Resultado", SqlDbType.Bit).Direction = ParameterDirection.Output;

                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    cmd.ExecuteNonQuery();

                    resultado = Convert.ToBoolean(cmd.Parameters["Resultado"].Value);
                }
            }
            catch (Exception ex)
            {
                resultado = false;
            }

            return resultado;
        }


    }
}
