
namespace CapaEntidad
{

    public class Carrito
    {
        public int IdCarrito { get; set; }
        public Usuario oUsuario { get; set; }
        public Producto oProducto { get; set; }
        public int Cantidad { get; set; }
        public string FechaInicio { get; set; }
        public string FechaFin { get; set; }

    }
}
