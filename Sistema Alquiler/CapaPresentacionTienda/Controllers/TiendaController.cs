using CapaEntidad;
using CapaNegocio;
using CapaNegocio.Paypal;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Description;
using System.Xml.Linq;

namespace CapaPresentacionTienda.Controllers
{
    public class TiendaController : Controller
    {
        // GET: Tienda
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult DetalleProducto(int idproducto = 0)
        {
            Producto oProducto = new Producto();
            bool conversion;

            oProducto = new CN_Producto().Listar().Where(p => p.IdProducto == idproducto).FirstOrDefault();

            if (oProducto != null)
            {
                oProducto.Base64 = CN_Recursos.ConvertirBase64(Path.Combine(oProducto.RutaImagen, oProducto.NombreImagen), out conversion);
                oProducto.Extension = Path.GetExtension(oProducto.NombreImagen);
            }
            return View(oProducto);
        }


        [HttpGet]
        public JsonResult ListaCategorias()
        {
            List<Categoria> lista = new List<Categoria>();

            lista = new CN_Categoria().Listar();

            return Json(new { data = lista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult ListarMarcaPorCategoria(int idcategoria)
        {
            List<Marca> lista = new List<Marca>();

            lista = new CN_Marca().ListarMarcaPorCategoria(idcategoria);

            return Json(new { data = lista }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult ListarProducto(int idcategoria, int idmarca)
        {
            List<Producto> lista = new List<Producto>();

            bool conversion;

            lista = new CN_Producto().Listar().Select(p => new Producto()
            {
                IdProducto = p.IdProducto,
                Nombre = p.Nombre,
                Descripcion = p.Descripcion,
                oMarca = p.oMarca,
                oCategoria = p.oCategoria,
                Precio = p.Precio,
                Stock = p.Stock,
                RutaImagen = p.RutaImagen,
                Base64 = CN_Recursos.ConvertirBase64(Path.Combine(p.RutaImagen, p.NombreImagen), out conversion),
                Extension = Path.GetExtension(p.NombreImagen),
                Activo = p.Activo
            }).Where(p =>
                p.oCategoria.IdCategoria == (idcategoria == 0 ? p.oCategoria.IdCategoria : idcategoria) &&
                p.oMarca.IdMarca == (idmarca == 0 ? p.oMarca.IdMarca : idmarca) &&
                p.Stock > 0 && p.Activo == true
            ).ToList();

            var jsonresult = Json(new { data = lista }, JsonRequestBehavior.AllowGet);
            jsonresult.MaxJsonLength = int.MaxValue;

            return jsonresult;


        }

        [HttpPost]
        public JsonResult AgregarCarrito(int idproducto)
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;
            bool existe = new CN_Carrito().ExisteCarrito(idusuario, idproducto);
            bool respuesta = false;

            string mensaje = string.Empty;
            if (existe)
            {
                mensaje = "El producto ya existe en el carrito";
            }
            else
            {
                string fechainicio = DateTime.Now.ToString();
                string fechafin = DateTime.Now.ToString();
                respuesta = new CN_Carrito().OperacionCarrito(idusuario, idproducto, fechainicio, fechafin, true, out mensaje);
            }

            return Json(new { respuesta = respuesta, mensaje }, JsonRequestBehavior.AllowGet);

        }

        [HttpGet]
        public JsonResult CantidadEnCarrito()
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;
            int cantidad = new CN_Carrito().CantidadEnCarrito(idusuario);
            return Json(new { cantidad = cantidad }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult ListarProductosCarrito()
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;

            List<Carrito> oLista = new List<Carrito>();

            bool conversion;

            oLista = new CN_Carrito().ListarProducto(idusuario).Select(oc => new Carrito() {
                oProducto = new Producto() {
                    IdProducto = oc.oProducto.IdProducto,
                    Nombre = oc.oProducto.Nombre,
                    oMarca = oc.oProducto.oMarca,
                    Precio = oc.oProducto.Precio,
                    RutaImagen = oc.oProducto.RutaImagen,
                    Base64 = CN_Recursos.ConvertirBase64(Path.Combine(oc.oProducto.RutaImagen, oc.oProducto.NombreImagen), out conversion),
                    Extension = Path.GetExtension(oc.oProducto.NombreImagen)

                },
                Cantidad = oc.Cantidad,
                FechaInicio = oc.FechaInicio,
                FechaFin = oc.FechaFin

            }).ToList();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult OperacionCarrito(int idproducto, bool sumar, string fechainicio, string fechafin)
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Carrito().OperacionCarrito(idusuario, idproducto, fechainicio, fechafin, sumar, out mensaje);

            return Json(new { respuesta = respuesta, mensaje }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult ActualizarFechaProductoCarrito(int idproducto, string fechainicio, string fechafin)
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Carrito().ActualizarFechaProductoCarrito(idusuario, idproducto, fechainicio, fechafin, out mensaje);

            return Json(new { respuesta = respuesta, mensaje }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult EliminarCarrito(int idproducto)
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;

            bool respuesta = false;

            string mensaje = string.Empty;

            respuesta = new CN_Carrito().EliminarCarrito(idusuario, idproducto);

            return Json(new { respuesta = respuesta, mensaje }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult ObtenerDepartamento()
        {
            List<Departamento> oLista = new List<Departamento>();

            oLista = new CN_Ubicacion().ObtenerDepartamento();

            return Json(new { lista = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult ObtenerCiudad(string IdDepartamento)
        {
            List<Ciudad> oLista = new List<Ciudad>();

            oLista = new CN_Ubicacion().ObtenerCiudad(IdDepartamento);

            return Json(new { lista = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult ObtenerBarrio(string IdCiudad, string IdDepartamento)
        {
            List<Barrio> oLista = new List<Barrio>();

            oLista = new CN_Ubicacion().ObtenerBarrio(IdCiudad, IdDepartamento);

            return Json(new { lista = oLista }, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Carrito()
        {
            return View();
        }

        [HttpPost]
        public async Task<JsonResult> ProcesarPago(List<Carrito> oListaCarrito, Alquiler oAlquiler )
        {
            decimal total = 0;

            DataTable detalle_alquiler = new DataTable();
            detalle_alquiler.Locale = new CultureInfo("es-CO");
            detalle_alquiler.Columns.Add("IdProducto", typeof(string));
            detalle_alquiler.Columns.Add("Cantidad", typeof(int));
            detalle_alquiler.Columns.Add("fechaInicio", typeof(string));
            detalle_alquiler.Columns.Add("fechaFin", typeof(string));
            detalle_alquiler.Columns.Add("Total", typeof(decimal));

            //Procesar pagos
            List<Item> oListaItem = new List<Item>();



            foreach( Carrito oCarrito in oListaCarrito)
            {
                DateTime fechaInicio = DateTime.Parse(oCarrito.FechaInicio);
                DateTime fechaFin = DateTime.Parse(oCarrito.FechaFin);

                // Calcular la diferencia de días
                int diferenciaDias = (fechaFin - fechaInicio).Days;

                // Asegurarse de que la diferencia de días sea al menos 1
                if (diferenciaDias < 1)
                {
                    diferenciaDias = 1;
                }

                decimal subtotal = oCarrito.Cantidad * oCarrito.oProducto.Precio * diferenciaDias;

                total += subtotal;

                oListaItem.Add(new Item()
                {
                    name = oCarrito.oProducto.Nombre,
                    quantity = oCarrito.Cantidad.ToString(),
                    startdate = oCarrito.FechaInicio.ToString(),
                    enddate = oCarrito.FechaFin.ToString(),
                    unit_amount = new UnitAmount
                    {
                        currency_code = "USD",
                        value = oCarrito.oProducto.Precio.ToString("G", new CultureInfo("es-CO"))
                    }
                });

                detalle_alquiler.Rows.Add(new object[]
                {
                    oCarrito.oProducto.IdProducto,
                    oCarrito.Cantidad,
                    oCarrito.FechaInicio,
                    oCarrito.FechaFin,
                    subtotal
                });
            }

            PurchaseUnit purchaseUnit = new PurchaseUnit()
            {
                amount = new Amount()
                {
                    currency_code = "USD",
                    value = total.ToString("G", new CultureInfo("es-CO")),
                    breakdown = new Breakdown() 
                    { 
                        item_total = new ItemTotal()
                        {
                            currency_code = "USD",
                            value = total.ToString("G", new CultureInfo("es-CO")),
                        }
                    }
                },
                description = "Alquiler de articulos mi alquiler",
                items = oListaItem
            };

            Checkout_Order oCheckoutOrder = new Checkout_Order()
            {
                intent = "CAPTURE",
                purchase_units = new List<PurchaseUnit>() { purchaseUnit },
                application_context = new ApplicationContext()
                {
                    brand_name = "http://www.MiAlquiler.somee.com",
                    landing_page = "NO_PREFERENCE",
                    user_action = "PAY_NOW",
                    return_url = "https://localhost:44333/Tienda/PagoEfectuado",
                    cancel_url = "https://localhost:44333/Tienda/Carrito"
                }
            };

            oAlquiler.MontoTotal = total;
            oAlquiler.IdArrendador = ((Usuario)Session["Usuario"]).IdUsuario;

            TempData["Alquiler"] = oAlquiler;
            TempData["DetalleAlquiler"] = detalle_alquiler;


            CN_Paypal opaypal = new CN_Paypal();
            Response_Paypal<Response_Checkout> response_paypal = new Response_Paypal<Response_Checkout>();
            response_paypal = await opaypal.CrearSolicitud(oCheckoutOrder);

            return Json(response_paypal , JsonRequestBehavior.AllowGet);
        }


        public async Task<ActionResult> PagoEfectuado()
        {
            string token = Request.QueryString["token"];

            CN_Paypal opaypal = new CN_Paypal();
            Response_Paypal<Response_Capture> response_paypal = new Response_Paypal<Response_Capture>();
            response_paypal = await opaypal.AprobarPago(token);

            ViewData["Status"] = response_paypal.Status;

            if(response_paypal.Status)
            {
                Alquiler oAlquiler = (Alquiler)TempData["Alquiler"];

                DataTable detalle_alquiler = (DataTable)TempData["DetalleAlquiler"];

                oAlquiler.IdTransaccion = response_paypal.Response.purchase_units[0].payments.captures[0].id;

                string mensaje = string.Empty;

                bool respuesta = new CN_Alquiler().Registrar(oAlquiler, detalle_alquiler, out mensaje);

                ViewData["IdTransaccion"] = oAlquiler.IdTransaccion;
            }

            return View();

        }


        public ActionResult MiAlquiler()
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;

            List<DetalleAlquiler> oLista = new List<DetalleAlquiler>();

            bool conversion;

            oLista = new CN_Alquiler().ListarAlquiler(idusuario).Select(oc => new DetalleAlquiler()
            {
                oProducto = new Producto()
                {
                    Nombre = oc.oProducto.Nombre,
                    Precio = oc.oProducto.Precio,
                    Base64 = CN_Recursos.ConvertirBase64(Path.Combine(oc.oProducto.RutaImagen, oc.oProducto.NombreImagen), out conversion),
                    Extension = Path.GetExtension(oc.oProducto.NombreImagen)

                },
                Cantidad = oc.Cantidad,
                FechaInicio = Convert.ToDateTime(oc.FechaInicio).ToString("dd/MM/yyyy"),
                FechaFin = Convert.ToDateTime(oc.FechaFin).ToString("dd/MM/yyyy"),
                Total = oc.Total,
                IdTransaccion = oc.IdTransaccion

            }).ToList();

            return View(oLista);
        }



    }
}