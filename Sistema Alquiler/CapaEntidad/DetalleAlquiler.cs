using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaEntidad
{
    public class DetalleAlquiler
    {
        public int IdDetalleAlquiler { get; set; }
        public int IdAlquiler { get; set; }
        public Producto oProducto { get; set; }
        public int Cantidad { get; set; }
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }
        public decimal Total { get; set; }
        public string IdTransaccion { get; set; }
    }
}
