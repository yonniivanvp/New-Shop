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
IdProducto int primary key identity,
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
FechaInicio datetime,
FechaFin datetime,
Cantidad int
);

CREATE TABLE ALQUILER(
IdAlquiler int primary key identity,
IdCliente int references CLIENTE(IdCliente),
TotalProducto int,
MontoTotal decimal(10,2),
Contacto varchar (50),
IdBarrio varchar (10),
Telefono varchar (50),
Direccion varchar (500),
IdTransaccion varchar (50),
FechaAlquiler datetime default getdate()
);

CREATE TABLE DETALLE_ALQUILER(
IdDetalleVenta int primary key identity,
IdAlquiler int references ALQUILER(IdAlquiler),
IdProducto int references PRODUCTO(IdProducto),
FechaInicio datetime,
FechaFin datetime,
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
INSERT INTO USUARIO (Nombres, Apellidos, Correo, Clave) VALUES 
					('Mariana', 'Vergara', 'maricanavergara@prueba.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae'),
					('Julian', 'Vanegas', 'julianvanega@prueba.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae')


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




CREATE PROC sp_RegistrarUsuario(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Activo bit,
@Mensaje varchar(500) OUTPUT,
@Resultado int OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo)
    BEGIN
        INSERT INTO USUARIO (Nombres, Apellidos, Correo, Clave, Activo)
        VALUES (@Nombres, @Apellidos, @Correo, @Clave, @Activo);

        SET @Resultado = SCOPE_IDENTITY();
    END
    ELSE
        SET @Mensaje = 'El correo del usuario ya existe';
END;


create proc sp_EditarUsuario(
    @IdUsuario int,
    @Nombres varchar(100),
    @Apellidos varchar(100),
    @Correo varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (SELECT * FROM USUARIO WHERE Correo = @Correo AND IdUsuario != @IdUsuario)
    BEGIN
        UPDATE TOP (1) USUARIO
        SET Nombres = @Nombres,
            Apellidos = @Apellidos,
            Correo = @Correo,
            Activo = @Activo
        WHERE IdUsuario = @IdUsuario

        SET @Resultado = 1
    END
    ELSE
        SET @Mensaje = 'El correo del usuario ya existe'
END


create proc sp_RegistrarCategoria(
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar (500) output,
@Resultado int output
)
as
begin
   SET @Resultado = 0
   IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion)
   begin  
		insert into CATEGORIA (Descripcion, Activo) values
        (@Descripcion, @Activo)

		SET @Resultado = scope_identity()
   end
   else
   set @Mensaje = 'La categoria ya existe'
end


create proc sp_EditarCategoria(
@IdCategoria int,
@Descripcion varchar(100),
@Activo bit,
@Mensaje varchar(500) output,
@Resultado bit output
)
as
begin
	SET @Resultado = 0
	IF NOT EXISTS (SELECT * FROM CATEGORIA WHERE Descripcion = @Descripcion and IdCategoria != @IdCategoria)
    begin

          update top (1) CATEGORIA set
          Descripcion = @Descripcion,
          Activo = @Activo
          where IdCategoria = @IdCategoria
		  SET @Resultado = 1
     end
	 else
	  set @Mensaje = 'La categoria ya existe'
end


CREATE PROC sp_EliminarCategoria (
@IdCategoria INT,
@Mensaje VARCHAR(500) OUTPUT,
@Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    IF NOT EXISTS (
        SELECT * FROM PRODUCTO P
        INNER JOIN CATEGORIA C ON C.IdCategoria = P.IdCategoria
        WHERE P.IdCategoria = @IdCategoria
    )
    BEGIN
        DELETE TOP (1) FROM CATEGORIA WHERE IdCategoria = @IdCategoria;
        SET @Resultado = 1;
    END
    ELSE
        SET @Mensaje = 'La categoría se encuentra relacionada a un producto';
END


Select *FROM CATEGORIA


CREATE PROC sp_RegistrarMarca(
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) OUTPUT,
    @Resultado int OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    IF NOT EXISTS (
        SELECT *
        FROM MARCA
        WHERE Descripcion = @Descripcion
    )
    BEGIN
        INSERT INTO MARCA (Descripcion, Activo)
        VALUES (@Descripcion, @Activo);

        SET @Resultado = SCOPE_IDENTITY()
	END
    ELSE
	SET @Mensaje = 'La marca ya existe';
END


CREATE PROC sp_EditarMarca (
  @IdMarca INT,
  @Descripcion VARCHAR(100),
  @Activo BIT,
  @Mensaje VARCHAR(500) OUTPUT,
  @Resultado BIT OUTPUT
)
AS
BEGIN
  SET @Resultado = 0;
  IF NOT EXISTS (
    SELECT *
    FROM MARCA
    WHERE Descripcion = @Descripcion AND IdMarca != @IdMarca
  )
  BEGIN
    UPDATE TOP (1) MARCA
    SET Descripcion = @Descripcion,
        Activo = @Activo
    WHERE IdMarca = @IdMarca;

    SET @Resultado = 1;
  END
  ELSE
    SET @Mensaje = 'La marca ya existe';
END


CREATE PROC sp_EliminarMarca (
  @IdMarca INT,
  @Mensaje VARCHAR(500) OUTPUT,
  @Resultado BIT OUTPUT
)
AS
BEGIN
  SET @Resultado = 0;

  IF NOT EXISTS (
    SELECT *
    FROM PRODUCTO P
    INNER JOIN MARCA M ON M.IdMarca = P.IdMarca
    WHERE P.IdMarca = @IdMarca
  )
  BEGIN
    DELETE TOP (1) FROM MARCA WHERE IdMarca = @IdMarca;
    SET @Resultado = 1;
  END
  ELSE
    SET @Mensaje = 'La marca se encuentra relacionada a un producto';
END


CREATE PROC sp_RegistrarProducto(
@Nombre varchar(100),
@Descripcion varchar(100),
@IdMarca varchar(100),
@IdCategoria varchar(100),
@Precio decimal(10,2),
@Stock int,
@Activo bit,
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin  
	SET @Resultado = 0
    IF NOT EXISTS (SELECT *FROM PRODUCTO WHERE Nombre = @Nombre)
    begin
         insert into PRODUCTO (Nombre, Descripcion, IdMarca, IdCategoria, Precio, Stock, Activo) values
         (@Nombre, @Descripcion, @IdMarca, @IdCategoria, @Precio, @Stock, @Activo)
		 SET @Resultado = SCOPE_IDENTITY()
    end                                                                                  
    else
        set @Mensaje = 'El producto ya existe'
end

Select *from PRODUCTO


create proc sp_EditarProducto(
  @IdProducto int,
  @Nombre varchar(100),
  @Descripcion varchar(100),
  @IdMarca varchar(100),
  @IdCategoria varchar(100),
  @Precio decimal(10,2),
  @Stock int,
  @Activo bit,
  @Mensaje varchar(500) output,
  @Resultado bit output
)
as
begin
  SET @Resultado = 0;

  IF NOT EXISTS (SELECT *FROM PRODUCTO WHERE Nombre = @Nombre and IdProducto != @IdProducto)
  begin
    update PRODUCTO set
      Nombre = @Nombre,
      Descripcion = @Descripcion,
      IdMarca = @IdMarca,
      IdCategoria = @IdCategoria,
      Precio = @Precio,
      Stock = @Stock,
      Activo = @Activo
    where IdProducto = @IdProducto;

    SET @Resultado = 1;
  end
  else
    set @Mensaje = 'El producto ya existe';
end


CREATE PROCEDURE sp_ActualizarRutaImagen
  @rutaImagen NVARCHAR(MAX),
  @nombreImagen NVARCHAR(MAX),
  @idProducto INT
AS
BEGIN
  UPDATE producto
  SET RutaImagen = @rutaImagen,
      NombreImagen = @nombreImagen
  WHERE IdProducto = @idProducto;
END;


CREATE PROC sp_EliminarProducto (
    @IdProducto INT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 0;

    IF NOT EXISTS (
        SELECT * FROM DETALLE_VENTA dv
        INNER JOIN PRODUCTO p ON p.IdProducto = dv.IdProducto
        WHERE p.IdProducto = @IdProducto
    )
    BEGIN
        DELETE TOP (1) FROM PRODUCTO WHERE IdProducto = @IdProducto;
        SET @Resultado = 1;
    END
    ELSE
        SET @Mensaje = 'El producto se encuentra relacionado a una venta';
END;


CREATE PROC sp_ReporteDashdoard
as
begin
select
	(SELECT COUNT(*) FROM CLIENTE)[TotalCliente],
	(SELECT ISNULL(SUM(CANTIDAD),0)FROM DETALLE_VENTA)[TotalVenta],
	(SELECT COUNT(*)FROM PRODUCTO)[TotalProducto]
end


Create proc sp_ReporteVentas(
@fechainicio varchar(10),
@fechafin varchar(10),
@idtransaccion varchar(50)
)
as
begin
	set dateformat dmy;


SELECT CONVERT(CHAR(10), v.FechaVenta, 103)[FechaVenta] , CONCAT( c.Nombres, ' ' ,c.Apellidos)[Cliente],
p.Nombre[Producto], p.Precio, dv.Cantidad, dv.Total, v.IdTransaccion
FROM DETALLE_VENTA dv
INNER JOIN PRODUCTO p on p.IdProducto = dv.IdProducto
INNER JOIN VENTA v on v.IdVenta = dv.IdVenta
INNER JOIN CLIENTE c on c.IdCliente = v.IdCliente
where CONVERT(date, v.FechaVenta) between @fechainicio and @fechafin
and v.IdTransaccion = iif(@idtransaccion = '', v.IdTransaccion, @idtransaccion)

end


create proc sp_RegistrarCliente(
@Nombres varchar(100),
@Apellidos varchar(100),
@Correo varchar(100),
@Clave varchar(100),
@Mensaje varchar(500) output,
@Resultado int output
)
as
begin
    SET @Resultado = 0
    IF NOT EXISTS (SELECT * FROM CLIENTE WHERE Correo = @Correo)
    begin
        insert into CLIENTE (Nombres, Apellidos, Correo, Clave, Reestablecer) values
        (@Nombres, @Apellidos, @Correo, @Clave, 0)
        SET @Resultado = scope_identity()
    end
    else
        set @Mensaje = 'El correo del usuario ya existe'
end


CREATE PROC sp_ExisteCarrito(
@IdCliente INT,
@IdProducto INT,
@Resultado BIT OUTPUT
)
AS
BEGIN
    IF EXISTS (
        SELECT * FROM carrito WHERE idcliente = @IdCliente AND idproducto = @IdProducto
    )
        SET @Resultado = 1
    ELSE
        SET @Resultado = 0
END



CREATE PROC sp_OperacionCarrito
(
    @IdCliente INT,
    @IdProducto INT,
	@FechaInicio DATETIME,
	@FechaFin DATETIME,
    @Sumar BIT,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 1
    SET @Mensaje = ''
    DECLARE @existecarrito BIT = IIF(EXISTS(SELECT * FROM carrito WHERE idcliente = @IdCliente AND idproducto = @IdProducto), 1, 0)
    DECLARE @stockproducto INT = (SELECT stock FROM PRODUCTO WHERE IdProducto = @IdProducto);

BEGIN TRY
    BEGIN TRANSACTION OPERACION

    if (@Sumar = 1)
    begin
        if (@stockproducto > 0)
        begin
            if (@existecarrito = 1)
                update CARRITO set Cantidad = Cantidad + 1, FechaInicio = @FechaInicio, FechaFin = @FechaFin where idcliente = @IdCliente and idproducto = @IdProducto
            else
                insert into CARRITO (IdCliente, IdProducto, Cantidad, FechaInicio, FechaFin) values (@IdCliente, @IdProducto, 1, @FechaInicio, @FechaFin)
			update PRODUCTO set Stock = Stock - 1 where IdProducto = @IdProducto
	end
    else
    begin
        set @Resultado = 0
        set @Mensaje = 'El producto no cuenta con stock disponible'
    end
	end
	else

	begin                         
		update CARRITO set Cantidad = Cantidad - 1 where idcliente = @IdCliente and idproducto = @IdProducto
		update PRODUCTO set Stock=  Stock + 1 where IdProducto = @IdProducto
	end
	COMMIT TRANSACTION OPERACION
END TRY
BEGIN CATCH
	SET @Resultado = 0
	SET @Mensaje = ERROR_MESSAGE()
	ROLLBACK TRANSACTION OPERACION
END CATCH
END




CREATE FUNCTION fn_obtenerCarritoCliente(
    @idcliente INT
)
RETURNS TABLE
AS
    RETURN (
        SELECT
            p.IdProducto,
            m.Descripcion AS DesMarca,
            p.Nombre,
            p.Precio,
            c.Cantidad,
			CONVERT(CHAR(10), c.FechaInicio, 103)[FechaInicio],
			CONVERT(CHAR(10), c.FechaFin, 103)[FechaFin],
            p.RutaImagen,
            p.NombreImagen
        FROM CARRITO c
        INNER JOIN PRODUCTO p ON p.IdProducto = c.IdProducto
        INNER JOIN MARCA m ON m.IdMarca = p.IdMarca
        WHERE c.IdCliente = @idcliente
)


CREATE PROC sp_EliminarCarrito(
    @IdCliente INT,
    @IdProducto INT,
    @Resultado BIT OUTPUT
)
AS
BEGIN

    SET @Resultado = 1

    DECLARE @cantidadproducto INT = (SELECT Cantidad FROM CARRITO WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto)

    BEGIN TRY

        BEGIN TRANSACTION OPERACION

            UPDATE PRODUCTO SET Stock = Stock + @cantidadproducto WHERE IdProducto = @IdProducto
            DELETE TOP (1) FROM CARRITO WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto

            COMMIT TRANSACTION OPERACION

    END TRY
    BEGIN CATCH
        SET @Resultado = 0
        ROLLBACK TRANSACTION OPERACION
    END CATCH
END

CREATE PROC sp_ActualizarFechaProductoCarrito(
    @IdCliente INT,
    @IdProducto INT,
    @FechaInicio DATE,
    @FechaFin DATE,
    @Mensaje VARCHAR(500) OUTPUT,
    @Resultado BIT OUTPUT
)
AS
BEGIN
    SET @Resultado = 1;
    SET @Mensaje = '';

    -- Validar que la fecha de inicio no sea anterior a hoy
    IF @FechaInicio < CAST(GETDATE() AS DATE)
    BEGIN
        SET @Resultado = 0;
        SET @Mensaje = 'La fecha de inicio no puede ser anterior a hoy.';
        RETURN;
    END

    -- Validar que la fecha de inicio no sea mayor a la fecha final
    IF @FechaInicio > @FechaFin
    BEGIN
        SET @Resultado = 0;
        SET @Mensaje = 'La fecha de inicio no puede ser mayor a la fecha final.';
        RETURN;
    END

    DECLARE @existecarrito BIT = IIF(EXISTS(SELECT * FROM CARRITO WHERE IdCliente = @IdCliente AND IdProducto = @IdProducto), 1, 0);

    BEGIN TRY
        BEGIN TRANSACTION OPERACION;

        IF @existecarrito = 1
        BEGIN
            UPDATE CARRITO
            SET FechaInicio = @FechaInicio,
                FechaFin = @FechaFin
            WHERE IdCliente = @IdCliente
            AND IdProducto = @IdProducto;
        END
        ELSE
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se encontró el producto en el carrito.';
        END;

        COMMIT TRANSACTION OPERACION;
    END TRY
    BEGIN CATCH
        SET @Resultado = 0;
        SET @Mensaje = ERROR_MESSAGE();
        ROLLBACK TRANSACTION OPERACION;
    END CATCH;
END;


CREATE TYPE [dbo].[EDetalle_Alquiler] AS TABLE(
    [IdProducto] int NULL,
    [Cantidad] int NULL,
	[fechaInicio] datetime NULL,
	[fechaFin] datetime NULL,
    [Total] decimal(18,2) NULL
)


CREATE PROCEDURE usp_RegistrarAlquiler(
    @IdCliente int,
    @TotalProducto int,
    @MontoTotal decimal(18,2),
    @Contacto varchar(100),
    @IdBarrio varchar(6),
    @Telefono varchar(18),
    @Direccion varchar(100),
    @IdTransaccion varchar(50),
    @DetalleAlquiler [EDetalle_Alquiler] READONLY,
    @Resultado bit output,
    @Mensaje varchar(500) output
)
AS
BEGIN
    BEGIN TRY
        DECLARE @idalquiler int = 0
        SET @Resultado = 1
        SET @Mensaje = ''

        BEGIN TRANSACTION registro

        INSERT INTO ALQUILER(IdCliente, TotalProducto, MontoTotal, Contacto, IdBarrio, Telefono, Direccion, IdTransaccion)
        VALUES(@IdCliente, @TotalProducto, @MontoTotal, @Contacto, @IdBarrio, @Telefono, @Direccion, @IdTransaccion)

        SET @idalquiler = SCOPE_IDENTITY()

        insert into DETALLE_ALQUILER (IdAlquiler, IdProducto, Cantidad, FechaInicio, FechaFin, Total)
		select @idalquiler, IdProducto, Cantidad, fechaInicio, fechaFin, Total from @DetalleAlquiler

		delete from CARRITO where IdCliente = @IdCliente

		commit transaction registro
  END TRY
    BEGIN CATCH
        set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
    END CATCH
END




Create Function fn_ListarAlquiler(
@idcliente int
)
RETURNS TABLE
AS 
RETURN
(
	SELECT P.RutaImagen, P.NombreImagen, P.Nombre, P.Precio, DA.Cantidad, DA.FechaInicio, DA.FechaFin, DA.Total, A.IdTransaccion FROM DETALLE_ALQUILER DA
	INNER JOIN PRODUCTO P ON P.IdProducto = DA.IdProducto
	INNER JOIN ALQUILER A ON A.IdAlquiler = DA.IdAlquiler
	WHERE A.IdCliente = @idcliente
);