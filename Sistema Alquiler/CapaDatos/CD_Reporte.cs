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
    public class CD_Reporte
    {

        public List<Reporte> Alquiler(string fechainicio, string fechafin, string idtransaccion)
        {

            List<Reporte> lista = new List<Reporte>();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {

                    SqlCommand cmd = new SqlCommand("sp_ReporteAlquiler", oconexion);
                    cmd.Parameters.AddWithValue("fechainicio", fechainicio);
                    cmd.Parameters.AddWithValue("fechafin", fechafin);
                    cmd.Parameters.AddWithValue("idtransaccion", idtransaccion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                            new Reporte()
                            {
                                FechaAlquiler = dr["FechaAlquiler"].ToString(),
                                Cliente = dr["Cliente"].ToString(),
                                Producto = dr["Producto"].ToString(),
                                Precio = Convert.ToDecimal( dr["Precio"], new CultureInfo("es-CO")),
                                Cantidad = Convert.ToInt32( dr["Cantidad"]),
                                FechaInicio = Convert.ToDateTime(dr["FechaInicio"]).ToString("dd/MM/yyyy"),
                                FechaFin = Convert.ToDateTime(dr["FechaFin"]).ToString("dd/MM/yyyy"),
                                Total = Convert.ToDecimal(dr["Total"], new CultureInfo("es-CO")),
                                IdTransaccion = dr["IdTransaccion"].ToString()
                            }
                            );
                        }
                    }

                }
            }
            catch
            {
                lista = new List<Reporte>();
            }

            return lista;
        }


        public DashBoard VerDashBoard()
        {

            DashBoard objeto = new DashBoard();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {


                    SqlCommand cmd = new SqlCommand("sp_ReporteDashdoard", oconexion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            objeto = new DashBoard()
                            {
                                TotalCliente = Convert.ToInt32(dr["TotalUsuario"]),
                                TotalAlquiler = Convert.ToInt32(dr["TotalAlquiler"]),
                                TotalProducto = Convert.ToInt32(dr["TotalProducto"])
                            };
                        }
                    }

                }
            }
            catch
            {
                objeto = new DashBoard();
            }

            return objeto;
        }


        public List<Reporte> AlquilerArrendatario(int idusuario, string fechainicio, string fechafin, string idtransaccion)
        {

            List<Reporte> lista = new List<Reporte>();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {

                    SqlCommand cmd = new SqlCommand("sp_ReporteAlquilerArriendo", oconexion);
                    cmd.Parameters.AddWithValue("IdArrendatario", idusuario);
                    cmd.Parameters.AddWithValue("fechainicio", fechainicio);
                    cmd.Parameters.AddWithValue("fechafin", fechafin);
                    cmd.Parameters.AddWithValue("idtransaccion", idtransaccion);
                    cmd.CommandType = CommandType.StoredProcedure;

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                            new Reporte()
                            {
                                FechaAlquiler = dr["FechaAlquiler"].ToString(),
                                Cliente = dr["Cliente"].ToString(),
                                Producto = dr["Producto"].ToString(),
                                Precio = Convert.ToDecimal(dr["Precio"], new CultureInfo("es-CO")),
                                Cantidad = Convert.ToInt32(dr["Cantidad"]),
                                FechaInicio = Convert.ToDateTime(dr["FechaInicio"]).ToString("dd/MM/yyyy"),
                                FechaFin = Convert.ToDateTime(dr["FechaFin"]).ToString("dd/MM/yyyy"),
                                Total = Convert.ToDecimal(dr["Total"], new CultureInfo("es-CO")),
                                IdTransaccion = dr["IdTransaccion"].ToString()
                            }
                            );
                        }
                    }

                }
            }
            catch
            {
                lista = new List<Reporte>();
            }

            return lista;
        }


        public DashBoard VerDashBoardArrendatario(int idusuario)
        {

            DashBoard objeto = new DashBoard();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {


                    SqlCommand cmd = new SqlCommand("sp_ReporteDashdoardArriendo", oconexion);
                    cmd.Parameters.AddWithValue("IdArrendatario", idusuario);
                    cmd.CommandType = CommandType.StoredProcedure;
                    

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            objeto = new DashBoard()
                            {
                                TotalCliente = Convert.ToInt32(dr["TotalUsuario"]),
                                TotalAlquiler = Convert.ToInt32(dr["TotalAlquiler"]),
                                TotalProducto = Convert.ToInt32(dr["TotalProducto"])
                            };
                        }
                    }

                }
            }
            catch
            {
                objeto = new DashBoard();
            }

            return objeto;
        }


    }
}
