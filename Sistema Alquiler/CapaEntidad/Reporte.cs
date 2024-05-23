
namespace CapaEntidad
{
    public class Reporte
    {
        public string FechaAlquiler { get; set; }

        public string Cliente { get; set; }

        public string Producto { get; set; }

        public decimal Precio { get; set; }

        public int Cantidad { get; set; }
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }
        public decimal Total { get; set; }

        public string IdTransaccion { get; set; }

    }
}
