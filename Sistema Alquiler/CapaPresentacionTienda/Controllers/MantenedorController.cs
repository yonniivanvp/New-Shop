using CapaEntidad;
using CapaNegocio;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CapaPresentacionAdmin.Controllers
{
    public class MantenedorController : Controller
    {
        [Authorize]

        public ActionResult Producto()
        {
            return View();
        }

        [HttpGet]
        public JsonResult ListarCategorias()
        {
            List<Categoria> oLista = new List<Categoria>();

            oLista = new CN_Categoria().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpGet]
        public JsonResult ListarMarca()
        {
            List<Marca> oLista = new List<Marca>();

            oLista = new CN_Marca().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        #region Producto
        // ********************************* PRODUCTOS *********************************

        // GET: Mantenedor
        [HttpGet]
        public JsonResult ListarProducto()
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;
            List<Producto> oLista = new List<Producto>();

            oLista = new CN_Producto().ListarProductoArrendatario(idusuario);

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }



        [HttpPost]
        public JsonResult GuardarProducto(string objeto, HttpPostedFileBase archivoImagen)
        {
            string mensaje = string.Empty;
            bool operacionexitosa = true;
            bool guardarimagen_exito = true;
            
            Producto oProducto = new Producto();
            oProducto = JsonConvert.DeserializeObject<Producto>(objeto);
            oProducto.IdArrendatario = ((Usuario)Session["Usuario"]).IdUsuario;

            decimal precio;
            if (decimal.TryParse(oProducto.PrecioTexto, System.Globalization.NumberStyles.AllowDecimalPoint, new CultureInfo("es-CO"), out precio))
            {
                oProducto.Precio = precio;
            }
            else
            {
                return Json(new { operacionexitosa = false, mensaje = "El formato de precio debe ser ##.##" }, JsonRequestBehavior.AllowGet);
            }



            if (oProducto.IdProducto == 0)
            {
                int idProductoGenerado = new CN_Producto().Registrar(oProducto, out mensaje);

                if (idProductoGenerado != 0)
                {
                    oProducto.IdProducto = idProductoGenerado;
                }
                else
                {
                    operacionexitosa = false;
                }
            }
            else
            {
                operacionexitosa = new CN_Producto().Editar(oProducto, out mensaje);
            }

            if (operacionexitosa)
            {
                if (archivoImagen != null)
                {
                    string ruta_guardar = ConfigurationManager.AppSettings["ServidorFotos"];
                    string extencion = Path.GetExtension(archivoImagen.FileName);
                    string nombre_imagen = string.Concat(oProducto.IdProducto.ToString(), extencion);

                    try
                    {
                        archivoImagen.SaveAs(Path.Combine(ruta_guardar, nombre_imagen));
                    }
                    catch (Exception ex)
                    {
                        string msg = ex.Message;
                        guardarimagen_exito = false;
                    }

                    if (guardarimagen_exito)
                    {
                        oProducto.RutaImagen = ruta_guardar;
                        oProducto.NombreImagen = nombre_imagen;
                        bool rspta = new CN_Producto().GuardarDatosImagen(oProducto, out mensaje);
                    }
                    else
                    {
                        mensaje = "Se guardó el producto pero hubo problemas con la imagen";
                    }

                }
            }


            return Json(new { operacionexitosa = operacionexitosa, idGenerado = oProducto.IdProducto, mensaje = mensaje }, JsonRequestBehavior.AllowGet);

        }


        [HttpPost]
        public JsonResult ImagenProducto(int id) 
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;
            bool conversion;
            Producto oproducto = new CN_Producto().ListarProductoArrendatario(idusuario).Where(p => p.IdProducto == id).FirstOrDefault();

            string textoBase64 = CN_Recursos.ConvertirBase64(Path.Combine(oproducto.RutaImagen, oproducto.NombreImagen), out conversion);


            return Json(new
            {
                conversion = conversion,
                textoBase64 = textoBase64,
                extension = Path.GetExtension(oproducto.NombreImagen)
            },
            JsonRequestBehavior.AllowGet
            );
        }
    

        [HttpPost]
        public JsonResult EliminarProducto(int id)
        {
            int idusuario = ((Usuario)Session["Usuario"]).IdUsuario;
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Producto().Eliminar(id, idusuario, out mensaje);
            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);

        }
        #endregion

    }
}