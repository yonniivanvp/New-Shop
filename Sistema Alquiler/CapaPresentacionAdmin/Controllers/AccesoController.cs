using CapaEntidad;
using CapaNegocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

using System.Web.Security;

namespace CapaPresentacionAdmin.Controllers
{
    public class AccesoController : Controller
    {
        // GET: Acceso
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult CambiarClave()
        {
            return View();
        }

        public ActionResult Reestablecer()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(string correo, string clave)
        {
            Administrador oAdministrador = new Administrador();
            oAdministrador = new CN_Administrador().Listar().Where(u => u.Correo == correo && u.Clave == CN_Recursos.ConvertirSha256(clave)).FirstOrDefault();
            if (oAdministrador == null) 
            {
                ViewBag.Error = "Correo o contraseña incorrecto";
                return View();
            }else 
            {
                if (oAdministrador.Reestablecer) 
                {
                    TempData["IdAdministrador"] = oAdministrador.IdAdministrador;
                    return RedirectToAction("CambiarClave");
                }

                FormsAuthentication.SetAuthCookie(oAdministrador.Correo, false);
                Session["Administrador"] = oAdministrador;
                ViewBag.Error = null;
                return RedirectToAction("Index", "Home");
            }

        }

        [HttpPost]
        public ActionResult CambiarClave(string idadministrador, string claveactual, string nuevaclave, string confirmarclave)
        {
            Administrador oAdministrador = new Administrador();
            oAdministrador = new CN_Administrador().Listar().Where(u => u.IdAdministrador == int.Parse(idadministrador)).FirstOrDefault();

            if (oAdministrador.Clave != CN_Recursos.ConvertirSha256(claveactual))
            {
                TempData["IdAdministrador"] = idadministrador;
                ViewData["vclave"] = "";
                ViewBag.Error = "La contraseña actual no es correcta";
                return View();
            } else if (nuevaclave != confirmarclave)
            {
                TempData["IdAdministrador"] = idadministrador;
                ViewData["vclave"] = claveactual;
                ViewBag.Error = "Las contraseñas no coinciden";
                return View();
            }
            ViewData["vclave"] = "";

            nuevaclave = CN_Recursos.ConvertirSha256(nuevaclave);

            string mensaje = string.Empty;

            bool respuesta = new CN_Administrador().CambiarClave(int.Parse(idadministrador), nuevaclave, out mensaje);

            if (respuesta)
            {
                return RedirectToAction("Index");
            }
            else 
            {
                TempData["IdAdministrador"] = idadministrador;
                ViewBag.Error = mensaje;
                return View();
            }
        }


        [HttpPost]
        public ActionResult Reestablecer(string correo) 
        {
            Administrador oadministrador = new Administrador();

            oadministrador = new CN_Administrador().Listar().Where(item => item.Correo == correo).FirstOrDefault();

            if (oadministrador == null)
            {
                ViewBag.Error = "No se encontró un usuario relacionado a ese correo";
                return View();
            }

            string mensaje = string.Empty;
            bool respuesta = new CN_Administrador().ReestablecerClave(oadministrador.IdAdministrador, correo, out mensaje);

            if (respuesta)
            {
                ViewBag.Error = null;
                return RedirectToAction("Index", "Acceso");
            }
            else 
            {
                ViewBag.Error = mensaje;
                return View();
            }
        }


        public ActionResult CerrarSesion()
        {
            Session["Administrador"] = null;
            FormsAuthentication.SignOut();
            return RedirectToAction("Index", "Acceso");
        }


    }
}