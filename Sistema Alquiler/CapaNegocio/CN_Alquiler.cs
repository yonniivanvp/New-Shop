using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Alquiler
    {
        private CD_Alquiler objCapaDato = new CD_Alquiler();
        public bool Registrar(Alquiler obj, DataTable DetalleAlquiler, out string Mensaje)
        {
            return objCapaDato.Registrar(obj, DetalleAlquiler, out Mensaje);
        }

        public List<DetalleAlquiler> ListarAlquiler(int idusuario)
        {
            return objCapaDato.ListarAlquiler(idusuario);
        }

    }
}
