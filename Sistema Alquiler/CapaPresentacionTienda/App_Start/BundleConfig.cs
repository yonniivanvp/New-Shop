﻿using System.Web;
using System.Web.Optimization;

namespace CapaPresentacionTienda
{
    public class BundleConfig
    {
        // Para obtener más información sobre las uniones, visite https://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new Bundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js",
                        "~/Scripts/jquery-ui-1.13.2.js"));

            bundles.Add(new Bundle("~/bundles/complementos").Include(
            "~/Scripts/fontawesome/all.min.js",
            "~/Scripts/DataTables/jquery.dataTables.js",
            "~/Scripts/DataTables/dataTables.responsive.js",
            "~/Scripts/loadingOverlay/loadingoverlay.min.js",
            "~/Scripts/sweetalert.min.js",
            "~/Scripts/jquery.validate.js",
            "~/Scripts/scripts.js"));

            //bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
            //            "~/Scripts/jquery.validate*"));

            // Utilice la versión de desarrollo de Modernizr para desarrollar y obtener información sobre los formularios.  De esta manera estará
            // para la producción, use la herramienta de compilación disponible en https://modernizr.com para seleccionar solo las pruebas que necesite.
            //bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
            //            "~/Scripts/modernizr-*"));

            bundles.Add(new Bundle("~/bundles/bootstrap").Include(
                      "~/Scripts/bootstrap.bundle.js",
                      "~/Scripts/fontawesome/all.min.js",
                      "~/Scripts/loadingoverlay.min.js",
                      "~/Scripts/sweetalert.min.js"
                      ));

            bundles.Add(new StyleBundle("~/Content/css").Include(
                "~/Content/Site.css",
                "~/Content/DataTables/css/jquery.dataTables.css",
                "~/Content/DataTables/css/responsive.dataTables.css",
                "~/Content/themes/base/jquery-ui.css",
                "~/Content/sweetalert.css"
                ));

        }
    }
}