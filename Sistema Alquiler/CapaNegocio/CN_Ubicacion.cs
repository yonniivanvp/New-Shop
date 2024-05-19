using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Ubicacion
    {
        private CD_Ubicacion objCapaDato = new CD_Ubicacion();

        public List<Departamento> ObtenerDepartamento()
        { 
            return objCapaDato.ObtenerDepartamento();
        }

        public List<Ciudad> ObtenerCiudad(string iddepartamento)
        {
            return objCapaDato.ObtenerCiudad(iddepartamento);
        }

        public List<Barrio> ObtenerBarrio(string idciudad, string iddepartamento)
        {
            return objCapaDato.ObtenerBarrio(idciudad, iddepartamento);
        }



    }
}
