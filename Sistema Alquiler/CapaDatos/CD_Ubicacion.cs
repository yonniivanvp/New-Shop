using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaDatos
{
    public class CD_Ubicacion
    {
        public List<Departamento> ObtenerDepartamento()
        {

            List<Departamento> lista = new List<Departamento>();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "select * from DEPARTAMENTO";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                            new Departamento()
                            {
                                IdDepartamento = dr["IdDepartamento"].ToString(),
                                Descripcion = dr["Descripcion"].ToString()
                            }
                            );
                        }
                    }

                }
            }
            catch
            {
                lista = new List<Departamento>();
            }

            return lista;
        }


        public List<Ciudad> ObtenerCiudad(string iddepartamento)
        {

            List<Ciudad> lista = new List<Ciudad>();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "select * from CIUDAD where IdDepartamento = @iddepartamento";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.Parameters.AddWithValue("@iddepartamento", iddepartamento);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                            new Ciudad()
                            {
                                IdCiudad = dr["IdCiudad"].ToString(),
                                Descripcion = dr["Descripcion"].ToString()
                            }
                            );
                        }
                    }

                }
            }
            catch
            {
                lista = new List<Ciudad>();
            }

            return lista;
        }


        public List<Barrio> ObtenerBarrio(string idciudad, string iddepartamento)
        {

            List<Barrio> lista = new List<Barrio>();

            try
            {
                //Cadena de conexicion a SQL
                using (SqlConnection oconexion = new SqlConnection(Conexion.cn))
                {
                    string query = "select * from BARRIO where IdCiudad = @idciudad and IdDepartamento = @iddepartamento";

                    SqlCommand cmd = new SqlCommand(query, oconexion);
                    cmd.Parameters.AddWithValue("@idciudad", idciudad);
                    cmd.Parameters.AddWithValue("@iddepartamento", iddepartamento);
                    cmd.CommandType = CommandType.Text;

                    oconexion.Open();

                    //Lee la ejecucion de la consulta
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(
                            new Barrio()
                            {
                                IdBarrio = dr["IdCiudad"].ToString(),
                                Descripcion = dr["Descripcion"].ToString()
                            }
                            );
                        }
                    }

                }
            }
            catch
            {
                lista = new List<Barrio>();
            }

            return lista;
        }





    }
}
