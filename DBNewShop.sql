CREATE DATABASE DBCARRITO
GO

USE DBCARRITO
GO

CREATE TABLE CATEGORIA(
IdCategoria int primary key identity,
Descripcion varchar (100),
Activo bit default 1,
FechaRegistro datetime default getdate()
);

CREATE TABLE MARCA(
IdMarca int primary key identity,
Descripcion varchar(100) ,
Activo bit default 1,
FechaRegistro datetime default getdate()
);

CREATE TABLE PRODUCTO(
Idproducto int primary key identity,
Nombre varchar (500),
Descripcion varchar (500),
IdMarca int references Marca(IdMarca),
IdCategoria int references Categoria(IdCategoria),
Precio decimal (10,2) default 0,
Stock int,
RutaImagen varchar (100),
NombreImagen varchar (100),
Activo bit default 1,
FechaRegistro datetime default getdate()
);

CREATE TABLE CLIENTE(
IdCliente int primary key identity,
Nombres varchar (100),
Apellidos varchar (100),
Correo varchar (100),
Clave varchar (150),
Reestablecer bit default 0,
FechaRegistro datetime default getdate()
);

CREATE TABLE CARRITO(
IdCarrito int primary key identity,
IdCliente int references CLIENTE(IdCliente),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int
);

CREATE TABLE VENTA(
IdVenta int primary key identity,
IdCliente int references CLIENTE(IdCliente),
TotalProducto int,
MontoTotal decimal(10,2),
Contacto varchar (50),
IdDistrito varchar (10),
Telefono varchar (50),
Direccion varchar (500),
IdTransaccion varchar (50),
FechaVenta datetime default getdate()
);

CREATE TABLE DETALLE_VENTA(
IdDetalleVenta int primary key identity,
IdVenta int references VENTA(IdVenta),
IdProducto int references PRODUCTO(IdProducto),
Cantidad int,
Total decimal (10,2)
);

CREATE TABLE USUARIO(
IdUsuario int primary key identity,
Nombres varchar (100),
Apellidos varchar (100),
Correo varchar (100),
Clave varchar (150),
Reestablecer bit default 1,
Activo bit default 1,
FechaResigro datetime default getdate()
);

CREATE TABLE DEPARTAMENTO(
IdDepartamento varchar(2) NOT NULL,
Descripcion varchar (45) NOT NULL
);

CREATE TABLE CIUDAD(
IdCiudad varchar(4) NOT NULL,
Descripcion varchar (45) NOT NULL,
IdDepartamento varchar(2) NOT NULL
);

CREATE TABLE BARRIO(
IdBarrio varchar (6) NOT NULL,
Descripcion varchar (45) NOT NULL,
IdCiudad varchar(4) NOT NULL,
IdDepartamento varchar (2) NOT NULL
);

Select *from USUARIO
INSERT INTO USUARIO (Nombres, Apellidos, Correo, Clave) 
			VALUES ('Mariana', 'Vergara', 'maricanavergara@prueba.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')


SELECT *FROM CATEGORIA
INSERT INTO CATEGORIA (Descripcion) VALUES
						('Tecnología'),
						('Hogar'),
						('Jardin'),
						('Herramienta')


SELECT *FROM MARCA
INSERT INTO MARCA(Descripcion) VALUES 
				('SONYTE'),
				('HPTE'),
				('LGTE'),
				('HYUNDAITE'),
				('CANONTE'),
				('ROBERTA ALLENTE')

SELECT *FROM DEPARTAMENTO

INSERT INTO DEPARTAMENTO(IdDepartamento, Descripcion) VALUES 
						('01','Antioquia'),
						('02','Valle del Cauca'),
						('03','Bolivar')

SELECT *FROM CIUDAD
INSERT INTO CIUDAD (IdCiudad, Descripcion, IdDepartamento) VALUES 
					('0101', 'Medellin', '01'),
					('0102', 'Envigado', '01'),

					-- Valle del Cauca Ciudades
					('0201', 'Cali', '02'),
					('0202', 'Buga', '02'),

					-- Bolivar Ciudades
					('0301', 'Cartagena', '03'),
					('0302', 'El carmen de bolivar', '03')

SELECT *FROM BARRIO

INSERT INTO BARRIO(IdBarrio, Descripcion, IdCiudad, IdDepartamento) VALUES
					('010101', 'Belén', '0101', '01'),
					('010102', 'La Palma', '0101', '01'),

					('010201', 'San Marcos', '0102', '01'),
					('010202', 'Jardines', '0102', '01'),

					-- Valle del Cauca BARRIO
					('020101', 'Las Ceibas', '0201', '02'),
					('020102', 'Santa Isabel', '0201', '02'),

					('020201', 'Aures', '0202', '02'),
					('020202', 'El Carmelo', '0202', '02'),

					-- Bolivar BARRIO
					('030101', 'La Matuna', '0301', '03'),
					('030102', 'Bocagrande', '0301', '03'),

					('030201', 'Alto Laran', '0302', '03'),
					('030202', 'Nieva', '0302', '03')



