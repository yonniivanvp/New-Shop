using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.EnterpriseServices.Internal;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using CapaEntidad;
using CapaNegocio;
using ClosedXML.Excel;


//Permite conectar con el forms
namespace CapaPresentacionAdmin.Controllers
{

    [Authorize]
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Usuarios()
        {
            return View();
        }

        [HttpGet]
        public JsonResult ListarAdministrador()
        {
            List<Administrador> oLista = new List<Administrador>();

            oLista = new CN_Administrador().Listar();

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public JsonResult GuardarAdministrador(Administrador objeto)
        {
            object resultado;
            string mensaje = string.Empty;

            if (objeto.IdAdministrador == 0)
            {
                resultado = new CN_Administrador().Registrar(objeto, out mensaje);
            }
            else
            {
                resultado = new CN_Administrador().Editar(objeto, out mensaje);
            }

            return Json(new { resultado = resultado, mensaje = mensaje }, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public JsonResult EliminarAdministrador(int id)
        {
            bool respuesta = false;
            string mensaje = string.Empty;

            respuesta = new CN_Administrador().Eliminar(id, out mensaje);
            return Json(new { resultado = respuesta, mensaje = mensaje }, JsonRequestBehavior.AllowGet);

        }

        [HttpGet]
        public JsonResult ListaReporte(string fechainicio, string fechafin, string idtransaccion)
        {
            List <Reporte> oLista = new List <Reporte>();

            oLista = new CN_Reporte().Alquiler(fechainicio, fechafin, idtransaccion);

            return Json(new { data = oLista }, JsonRequestBehavior.AllowGet);
        }


        [HttpGet]
        public JsonResult VistaDashBoard() 
        {
            DashBoard objeto = new CN_Reporte().VerDashBoard();
            return Json(new { resultado = objeto}, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public FileResult ExportarAlquiler(string fechainicio, string fechafin, string idtransaccion) 
        {
            List<Reporte> oLista = new List<Reporte>();
            oLista = new CN_Reporte().Alquiler(fechainicio, fechafin, idtransaccion);

            DataTable dt = new DataTable();

            dt.Locale = new System.Globalization.CultureInfo("es-CO");
            dt.Columns.Add("Fecha Alquiler", typeof(string));
            dt.Columns.Add("Cliente", typeof(string));
            dt.Columns.Add("Producto", typeof(string));
            dt.Columns.Add("Precio", typeof(decimal));
            dt.Columns.Add("Cantidad", typeof(int));
            dt.Columns.Add("Fecha Inicio", typeof(string));
            dt.Columns.Add("Fecha Fin", typeof(string));
            dt.Columns.Add("Total", typeof(decimal));
            dt.Columns.Add("IdTransaccion", typeof(string));

            foreach (Reporte rp in oLista) 
            {
                dt.Rows.Add(new object[] 
                { 
                    rp.FechaAlquiler,
                    rp.Cliente,
                    rp.Producto,
                    rp.Precio,
                    rp.Cantidad,
                    rp.FechaInicio,
                    rp.FechaFin,
                    rp.Total,
                    rp.IdTransaccion
                });
            }
            dt.TableName = "Datos";

            using (XLWorkbook wb = new XLWorkbook())
            {
                wb.Worksheets.Add(dt);
                using (MemoryStream stream = new MemoryStream())
                {
                    wb.SaveAs(stream);
                    return File(stream.ToArray(), "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "ReporteAlquiler" + DateTime.Now.ToString() + "xlsx");
                }
            }


        }

    }
}