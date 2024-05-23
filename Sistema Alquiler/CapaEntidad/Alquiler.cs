using System.Collections.Generic;

namespace CapaEntidad
{
    public class Alquiler
    {
        public int IdAlquiler { get; set; }
        public int IdArrendador { get; set; }
        public int TotalProducto { get; set; }
        public decimal MontoTotal { get; set; }
        public string Contacto { get; set; }
        public string IdBarrio { get; set; }
        public string Telefono { get; set; }
        public string Direccion { get; set; }
        public string FechaAlquiler { get; set; }
        public string IdTransaccion { get; set; }
        public List<DetalleAlquiler> oDetalleAlquiler { get; set; }
    }
}
