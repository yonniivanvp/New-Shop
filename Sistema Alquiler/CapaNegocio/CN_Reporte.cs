using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Reporte
    {
        private CD_Reporte objCapaDato = new CD_Reporte();

        public List<Reporte> Alquiler(string fechainicio, string fechafin, string idtransaccion) 
        {
            return objCapaDato.Alquiler(fechainicio, fechafin, idtransaccion);
        }

        public List<Reporte> AlquilerArrendatario(int idusuario, string fechainicio, string fechafin, string idtransaccion)
        {
            return objCapaDato.AlquilerArrendatario(idusuario, fechainicio, fechafin, idtransaccion);
        }

        public DashBoard VerDashBoard()
        {
            return objCapaDato.VerDashBoard();
        }

        public DashBoard VerDashBoardArrendatario( int idusuario)
        {
            return objCapaDato.VerDashBoardArrendatario(idusuario);
        }

    }
}
