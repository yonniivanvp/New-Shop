using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Carrito
    {
        private CD_Carrito objCapaDato = new CD_Carrito();

        public bool ExisteCarrito(int idusuario, int idproducto)
        {
            return objCapaDato.ExisteCarrito(idusuario, idproducto);
        }

        public bool OperacionCarrito(int idusuario, int idproducto, string fechainicio, string fechafin, bool sumar, out string Mensaje)
        {
            return objCapaDato.OperacionCarrito(idusuario, idproducto, fechainicio, fechafin, sumar, out Mensaje);
        }

        public bool ActualizarFechaProductoCarrito(int idUsuario, int idProducto, string fechaInicio, string fechaFin, out string mensaje)
        {
            return objCapaDato.ActualizarFechaProductoCarrito(idUsuario, idProducto, fechaInicio, fechaFin, out mensaje);
        }

        public int CantidadEnCarrito(int idusuario)
        {
            return objCapaDato.CantidadEnCarrito(idusuario);
        }

        public List<Carrito> ListarProducto(int idusuario)
        {
            return objCapaDato.ListarProducto(idusuario);
        }

        public bool EliminarCarrito(int idusuario, int idproducto)
        {
            return objCapaDato.EliminarCarrito(idusuario, idproducto);
        }


    }
}
