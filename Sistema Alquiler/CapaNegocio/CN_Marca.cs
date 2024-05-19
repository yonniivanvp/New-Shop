﻿using CapaDatos;
using CapaEntidad;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CapaNegocio
{
    public class CN_Marca
    {

        private CD_Marca objCapaDato = new CD_Marca();

        //Retorna las Marcas llamadas de la capa de datos
        public List<Marca> Listar()
        {
            return objCapaDato.Listar();
        }

        public int Registrar(Marca obj, out string Mensaje)
        {
            Mensaje = string.Empty;
            // Reglas de negocio
            if (string.IsNullOrEmpty(obj.Descripcion) || string.IsNullOrWhiteSpace(obj.Descripcion))
            {
                Mensaje = "La descripcion de la marca no puede ser vacio";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {
                return objCapaDato.Registrar(obj, out Mensaje);
            }

            else
            {
                return 0;
            }


        }


        public bool Editar(Marca obj, out string Mensaje)
        {
            Mensaje = string.Empty;
            // Reglas de negocio
            if (string.IsNullOrEmpty(obj.Descripcion) || string.IsNullOrWhiteSpace(obj.Descripcion))
            {
                Mensaje = "La descripcion de la marca no puede ser vacio";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {
                return objCapaDato.Editar(obj, out Mensaje);
            }
            else
            {
                return false;
            }


        }


        public bool Eliminar(int id, out string Mensaje)
        {
            return objCapaDato.Eliminar(id, out Mensaje);
        }

        public List<Marca> ListarMarcaPorCategoria(int idcategoria)
        {
            return objCapaDato.ListarMarcaPorCategoria(idcategoria);
        }


    }
}
