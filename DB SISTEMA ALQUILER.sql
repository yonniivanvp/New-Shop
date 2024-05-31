CREATE DATABASE SISTEMA_ALQUILER
GO

USE SISTEMA_ALQUILER
GO

--CREAR TABLAS--

create table ADMINISTRADOR (
    IdAdministrador int primary key identity,
    Nombres varchar(100),
    Apellidos varchar(100),
    Correo varchar(100),
    Clave varchar(150),
    Reestablecer bit default 1,
    Activo bit default 1,
    FechaRegistro datetime default getdate()
);

create table USUARIO (
    IdUsuario int primary key identity,
    Nombres varchar(100),
    Apellidos varchar(100),
    Correo varchar(100),
    Clave varchar(150),
    Reestablecer bit default 1,
    FechaRegistro datetime default getdate()
);

create table ARRENDADOR (
    IdArrendador int primary key references USUARIO(IdUsuario)
);

create table ARRENDATARIO (
    IdArrendatario int primary key references USUARIO(IdUsuario)
);

create table CATEGORIA (
    IdCategoria int primary key identity,
    Descripcion varchar(100),
    Activo bit default 1,
    FechaRegistro datetime default getdate()
);

create table MARCA (
    IdMarca int primary key identity,
    Descripcion varchar(100),
    Activo bit default 1,
    FechaRegistro datetime default getdate()
);

create table PRODUCTO (
    IdProducto int primary key identity,
    Nombre varchar(500),
    Descripcion varchar(500),
    IdMarca int references Marca(IdMarca),
    IdCategoria int references Categoria(IdCategoria),
    Precio decimal(10,2) default 0,
    Stock int,
    RutaImagen varchar(100),
    NombreImagen varchar(100),
    Activo bit default 1,
    FechaRegistro datetime default getdate(),
	IdArrendatario int references Arrendatario(IdArrendatario)
);

create table VALORACION(
	IdProducto int references PRODUCTO(IdProducto),
	IdArrendador int references ARRENDADOR(IdArrendador),
	NumEstrellas int,
	DescValoracion varchar(500),
	PRIMARY KEY (IdProducto,IdArrendador) 
);

create table CARRITO (
    IdCarrito int primary key identity,
    IdArrendador int references ARRENDADOR(IdArrendador),
    IdProducto int references PRODUCTO(IdProducto),
    FechaInicio datetime,
    FechaFin datetime,
    Cantidad int
);

create table DEPARTAMENTO (
    IdDepartamento varchar(2) primary key,
    Descripcion varchar(45) NOT NULL
);

create table CIUDAD (
    IdCiudad varchar(4) primary key,
    Descripcion varchar(45) NOT NULL,
    IdDepartamento varchar(2) references DEPARTAMENTO(IdDepartamento)
);

create table BARRIO (
    IdBarrio varchar(6) primary key,
    Descripcion varchar(45) NOT NULL,
    IdCiudad varchar(4) references CIUDAD(IdCiudad),
    IdDepartamento varchar(2) references DEPARTAMENTO(IdDepartamento)
);

create table ALQUILER (
    IdAlquiler int primary key identity,
    IdArrendador int references ARRENDADOR(IdArrendador),
    TotalProducto int,
    MontoTotal decimal(10,2),
    Contacto varchar(50),
    IdBarrio varchar(6) references BARRIO(IdBarrio), 
    Telefono varchar(50),
    Direccion varchar(500),
    IdTransaccion varchar(50),
    FechaAlquiler datetime default getdate()
);

create table DETALLE_ALQUILER (
    IdDetalleAlquiler int primary key identity,
    IdAlquiler int references ALQUILER(IdAlquiler),
    IdProducto int references PRODUCTO(IdProducto),
    FechaInicio datetime,
    FechaFin datetime,
    Cantidad int,
    Total decimal(10,2)
);

--INSERTAR DATOS A LA BASE DE DATOS

select * from ADMINISTRADOR;
insert into ADMINISTRADOR (Nombres, Apellidos, Correo, Clave, Reestablecer) values 
    ('Mariana', 'Vergara', 'maricanavergara@prueba.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', 0),
    ('Julian', 'Vanegas', 'julianvanega@prueba.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', 1),
	('Andres', 'Rodriguez', 'andresrodriguez@prueba.com', 'ecd71870d1963316a97e3ac3408c9835ad8cf0f3c1bc703527c30265534f75ae', 0);

select * from CATEGORIA;
insert into CATEGORIA (Descripcion) values
    ('Tecnolog�a'),
    ('Hogar'),
    ('Jardin'),
    ('Herramienta');

select * from MARCA;
insert into MARCA(Descripcion) values 
    ('SONYTE'),
    ('HPTE'),
    ('LGTE'),
    ('HYUNDAITE'),
    ('CANONTE'),
    ('ROBERTA ALLENTE');

select * from DEPARTAMENTO;
insert into DEPARTAMENTO(IdDepartamento, Descripcion) values 
    ('01','Antioquia'),
    ('02','Valle del Cauca'),
    ('03','Bolivar');

select * from CIUDAD;
insert into CIUDAD (IdCiudad, Descripcion, IdDepartamento) values 
    ('0101', 'Medellin', '01'),
    ('0102', 'Envigado', '01'),

    -- Valle del Cauca Ciudades
    ('0201', 'Cali', '02'),
    ('0202', 'Buga', '02'),

    -- Bolivar Ciudades
    ('0301', 'Cartagena', '03'),
    ('0302', 'El carmen de bolivar', '03');

select * from BARRIO;
insert into BARRIO(IdBarrio, Descripcion, IdCiudad, IdDepartamento) values
    ('010101', 'Bel�n', '0101', '01'),
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
    ('030202', 'Nieva', '0302', '03');


------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE ADMINISTRADOR -----------------------------------------------
create procedure sp_RegistrarAdmin(
    @Nombres varchar(100),
    @Apellidos varchar(100),
    @Correo varchar(100),
    @Clave varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si el correo del usuario ya existe en la tabla USUARIO
    if not exists (select * from ADMINISTRADOR where Correo = @Correo)
    begin
        -- Insertar un nuevo usuario en la tabla USUARIO
        insert into ADMINISTRADOR(Nombres, Apellidos, Correo, Clave, Activo)
        values (@Nombres, @Apellidos, @Correo, @Clave, @Activo);

        -- Obtener el identificador generado para el nuevo usuario
        set @Resultado = SCOPE_IDENTITY();
    end
    else
        -- Establecer un mensaje indicando que el correo del usuario ya existe
        set @Mensaje = 'El correo del usuario ya existe';
end;


create procedure sp_EditarAdmin(
    @IdAdministrador int,
    @Nombres varchar(100),
    @Apellidos varchar(100),
    @Correo varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si el correo del usuario ya existe en la tabla USUARIO, excluyendo el usuario actual
    if not exists (select * from USUARIO where Correo = @Correo and IdUsuario != @IdAdministrador)
    begin
        -- Actualizar los datos del usuario
        update top (1) ADMINISTRADOR
        set Nombres = @Nombres,
            Apellidos = @Apellidos,
            Correo = @Correo,
            Activo = @Activo
        where IdAdministrador = @IdAdministrador;

        -- Establecer el resultado como 1 para indicar que la actualizaci�n fue exitosa
        set @Resultado = 1;
    end
    else
        -- Establecer un mensaje indicando que el correo del usuario no existe
        set @Mensaje = 'El correo del usuario no existe';
end;


--------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE CATEGORIA -----------------------------------------------
create procedure sp_RegistrarCategoria(
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si la categor�a ya existe en la tabla CATEGORIA
    if not exists (select * from CATEGORIA where Descripcion = @Descripcion)
    begin  
        -- Insertar la nueva categor�a en la tabla CATEGORIA
        insert into CATEGORIA (Descripcion, Activo) values
        (@Descripcion, @Activo);

        -- Obtener el identificador generado para la nueva categor�a
        set @Resultado = scope_identity();
    end
    else
        -- Establecer un mensaje indicando que la categor�a ya existe
        set @Mensaje = 'La categor�a ya existe';
end;


create procedure sp_EditarCategoria(
    @IdCategoria int,
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si la descripci�n de la categor�a ya existe en la tabla CATEGORIA, excluyendo la categor�a actual
    if not exists (select * from CATEGORIA where Descripcion = @Descripcion and IdCategoria != @IdCategoria)
    begin
        -- Actualizar los datos de la categor�a
        update top (1) CATEGORIA set
            Descripcion = @Descripcion,
            Activo = @Activo
        where IdCategoria = @IdCategoria;

        -- Establecer el resultado como 1 para indicar que la actualizaci�n fue exitosa
        set @Resultado = 1;
    end
    else
        -- Establecer un mensaje indicando que la categor�a ya existe
        set @Mensaje = 'La categor�a ya existe';
end;


create procedure sp_EliminarCategoria (
    @IdCategoria int,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si la categor�a est� relacionada a alg�n producto en la tabla PRODUCTO
    if not exists (
        select * from PRODUCTO P
        inner join CATEGORIA C on C.IdCategoria = P.IdCategoria
        where P.IdCategoria = @IdCategoria
    )
    begin
        -- Eliminar la categor�a de la tabla CATEGORIA si no est� relacionada a ning�n producto
        delete top (1) from CATEGORIA where IdCategoria = @IdCategoria;
        -- Establecer el resultado como 1 para indicar que la eliminaci�n fue exitosa
        set @Resultado = 1;
    end
    else
        -- Establecer un mensaje indicando que la categor�a est� relacionada a un producto
        set @Mensaje = 'La categor�a se encuentra relacionada a un producto';
end;


----------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE MARCA -----------------------------------------------
create procedure sp_RegistrarMarca (
    @Descripcion varchar(100),
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si la marca ya existe en la tabla MARCA
    if not exists (
        select * from MARCA where Descripcion = @Descripcion
    )
    begin
        -- Insertar la nueva marca en la tabla MARCA
        insert into MARCA (Descripcion, Activo)
        values (@Descripcion, @Activo);

        -- Obtener el ID de la marca reci�n insertada
        set @Resultado = SCOPE_IDENTITY()
    end
    else
        -- Establecer un mensaje indicando que la marca ya existe
        set @Mensaje = 'La marca ya existe';
end;


create procedure sp_EditarMarca (
  @IdMarca int,
  @Descripcion varchar(100),
  @Activo bit,
  @Mensaje varchar(500) output,
  @Resultado bit output
)
as
begin
  -- Inicializar el resultado en 0
  set @Resultado = 0;

  -- Verificar si la descripci�n de la marca ya existe en la tabla MARCA, excluyendo la marca actual
  if not exists (
    select * from MARCA
    where Descripcion = @Descripcion and IdMarca != @IdMarca
  )
  begin
    -- Actualizar los datos de la marca
    update top (1) MARCA
    set Descripcion = @Descripcion,
        Activo = @Activo
    where IdMarca = @IdMarca;

    -- Establecer el resultado como 1 para indicar que la actualizaci�n fue exitosa
    set @Resultado = 1;
  end
  else
    -- Establecer un mensaje indicando que la marca ya existe
    set @Mensaje = 'La marca ya existe';
end;


create procedure sp_EliminarMarca (
  @IdMarca int,
  @Mensaje varchar(500) output,
  @Resultado bit output
)
as
begin
  -- Inicializar el resultado en 0
  set @Resultado = 0;

  -- Verificar si la marca est� relacionada a alg�n producto en la tabla PRODUCTO
  if not exists (
    select * from PRODUCTO P
    inner join MARCA M on M.IdMarca = P.IdMarca
    where P.IdMarca = @IdMarca
  )
  begin
    -- Eliminar la marca de la tabla MARCA si no est� relacionada a ning�n producto
    delete top (1) from MARCA where IdMarca = @IdMarca;
    -- Establecer el resultado como 1 para indicar que la eliminaci�n fue exitosa
    set @Resultado = 1;
  end
  else
    -- Establecer un mensaje indicando que la marca est� relacionada a un producto
    set @Mensaje = 'La marca se encuentra relacionada a un producto';
end;


-------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE PRODUCTO -----------------------------------------------
create procedure sp_RegistrarProducto (
    @Nombre varchar(100),
    @Descripcion varchar(100),
    @IdMarca int,
    @IdCategoria int,
    @Precio decimal(10,2),
    @Stock int,
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output,
	@IdArrendatario int
)
as
begin  
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si el producto ya existe en la tabla PRODUCTO
    if not exists (select * from PRODUCTO where Nombre = @Nombre)
    begin
        -- Insertar el nuevo producto en la tabla PRODUCTO
        insert into PRODUCTO (Nombre, Descripcion, IdMarca, IdCategoria, Precio, Stock, Activo, IdArrendatario)
        values (@Nombre, @Descripcion, @IdMarca, @IdCategoria, @Precio, @Stock, @Activo, @IdArrendatario);

        -- Obtener el ID del producto reci�n insertado
        set @Resultado = SCOPE_IDENTITY();
    end                                                                                  
    else
        -- Establecer un mensaje indicando que el producto ya existe
        set @Mensaje = 'El producto ya existe';
end;


create procedure sp_EditarProducto (
  @IdProducto int,
  @Nombre varchar(100),
  @Descripcion varchar(100),
  @IdMarca int,
  @IdCategoria int,
  @Precio decimal(10,2),
  @Stock int,
  @Activo bit,
  @Mensaje varchar(500) output,
  @Resultado bit output,
  @IdArrendatario int
)
as
begin
  -- Inicializar el resultado en 0
  set @Resultado = 0;

  -- Verificar si el nombre del producto ya existe en la tabla PRODUCTO, excluyendo el producto actual
  if not exists (
    select * from PRODUCTO 
    where Nombre = @Nombre and IdProducto != @IdProducto
  )
  begin
    -- Actualizar los datos del producto
    update PRODUCTO set
      Nombre = @Nombre,
      Descripcion = @Descripcion,
      IdMarca = @IdMarca,
      IdCategoria = @IdCategoria,
      Precio = @Precio,
      Stock = @Stock,
      Activo = @Activo,
	  IdArrendatario = @IdArrendatario
    where IdProducto = @IdProducto;

    -- Establecer el resultado como 1 para indicar que la actualizaci�n fue exitosa
    set @Resultado = 1;
  end
  else
    -- Establecer un mensaje indicando que el producto ya existe
    set @Mensaje = 'El producto ya existe';
end;


create procedure sp_ActualizarRutaImagen (
  @rutaImagen nvarchar(max),
  @nombreImagen nvarchar(max),
  @idProducto int
)
as
begin
  update PRODUCTO
  set RutaImagen = @rutaImagen,
      NombreImagen = @nombreImagen
  where IdProducto = @idProducto;
end;


create proc sp_EliminarProducto (
    @IdProducto int,                 -- Identificador del producto a eliminar
    @Mensaje varchar(500) output,    -- Mensaje de salida en caso de error
    @Resultado bit output            -- Resultado de la operaci�n (0 = fallo, 1 = �xito)
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si el producto no est� relacionado con ninguna venta en DETALLE_VENTA
    if not exists (
        select * from DETALLE_ALQUILER da
        inner join PRODUCTO p on p.IdProducto = da.IdProducto
        where p.IdProducto = @IdProducto
    )
    begin
        -- Eliminar el producto de la tabla PRODUCTO
        delete top (1) from PRODUCTO where IdProducto = @IdProducto;
        -- Establecer el resultado como 1 para indicar que la eliminaci�n fue exitosa
        set @Resultado = 1;
    end
    else
        -- Establecer un mensaje indicando que el producto est� relacionado a una venta
        set @Mensaje = 'El producto se encuentra relacionado a un alquiler';
end;


----------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA GENERACION DE REPORTES -----------------------------------------------
create proc sp_ReporteDashdoard
as
begin
      select
        -- Contar el n�mero total de clientes en la tabla CLIENTE
        (select count(*) from USUARIO) [TotalUsuario],

        -- Sumar la cantidad total de alquileres en la tabla DETALLE_ALQUILER
        (select isnull(sum(CANTIDAD), 0) from DETALLE_ALQUILER) [TotalAlquiler],

        -- Contar el n�mero total de productos en la tabla PRODUCTO
        (select count(*) from PRODUCTO) [TotalProducto]
end;


create proc sp_ReporteAlquiler(
    @fechainicio varchar(10),
    @fechafin varchar(10),
    @idtransaccion varchar(50)
)
as
begin
    -- Establecer el formato de fecha como d�a/mes/a�o
    set dateformat dmy;

    -- Seleccionar y devolver el informe de ventas
    select 
        convert(char(10), a.FechaAlquiler, 103) [FechaAlquiler],
        
        concat(c.Nombres, ' ', c.Apellidos) [Cliente], p.Nombre [Producto], p.Precio, dv.Cantidad, dv.FechaInicio, dv.FechaFin, dv.Total, a.IdTransaccion
    from DETALLE_ALQUILER dv
    inner join PRODUCTO p on p.IdProducto = dv.IdProducto
    inner join ALQUILER a on a.IdAlquiler = dv.IdAlquiler
    inner join USUARIO c on c.IdUsuario = a.IdArrendador
    where 
        -- Filtrar las fechas de alquiler entre la fecha de inicio y la fecha de fin proporcionadas
        convert(date, a.FechaAlquiler) between @fechainicio and @fechafin
        
        -- Filtrar por el ID de la transacci�n, si se proporciona
        and a.IdTransaccion = iif(@idtransaccion = '', a.IdTransaccion, @idtransaccion)
end;


-------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE USUARIOS -----------------------------------------------
create proc sp_RegistrarUsuario(
    @Nombres varchar(100),
    @Apellidos varchar(100),
    @Correo varchar(100),
    @Clave varchar(100),
    @Mensaje varchar(500) output,
    @Resultado int output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si el correo ya existe en la tabla USUARIO
    if not exists (select * from USUARIO where Correo = @Correo)
    begin
        begin try
            -- Iniciar transacci�n
            begin transaction;

            -- Insertar un nuevo usuario en la tabla USUARIO
            insert into USUARIO(Nombres, Apellidos, Correo, Clave, Reestablecer) 
            values (@Nombres, @Apellidos, @Correo, @Clave, 0);

            -- Capturar el ID del usuario reci�n insertado
            set @Resultado = scope_identity();

            -- Insertar un nuevo registro en la tabla ARRENDADOR
            insert into ARRENDADOR (IdArrendador) values (@Resultado);

            -- Insertar un nuevo registro en la tabla ARRENDATARIO
            insert into ARRENDATARIO (IdArrendatario) values (@Resultado);

            -- Confirmar la transacci�n
            commit transaction;
        end try
        begin catch
            -- Revertir la transacci�n en caso de error
            rollback transaction;
            -- Establecer un mensaje de error
            set @Mensaje = error_message();
            -- Restablecer el resultado a 0 para indicar fallo
            set @Resultado = 0;
        end catch
    end
    else
        -- Establecer un mensaje indicando que el correo del usuario ya existe
        set @Mensaje = 'El correo del usuario ya existe';
end;


------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE CARRITO -----------------------------------------------
create proc sp_ExisteCarrito(
    @IdArrendador int,
    @IdProducto int,
    @Resultado bit output
)
as
begin
    -- Verificar si existe un carrito con el IdCliente e IdProducto especificados
    if exists (
        select * from CARRITO where IdArrendador = @IdArrendador and IdProducto = @IdProducto
    )
        -- Si existe, establecer el resultado en 1 (true)
        set @Resultado = 1
    else
        -- Si no existe, establecer el resultado en 0 (false)
        set @Resultado = 0
end;



create proc sp_OperacionCarrito
(
    @IdArrendador int,
    @IdProducto int,
    @FechaInicio datetime,
    @FechaFin datetime,
    @Sumar bit,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    -- Inicializar variables de resultado y mensaje
    set @Resultado = 1;
    set @Mensaje = '';

    -- Declarar una variable para verificar si el carrito ya existe
    declare @existecarrito bit = iif(exists(select * from CARRITO where IdArrendador = @IdArrendador and IdProducto = @IdProducto), 1, 0);

    -- Obtener el stock del producto
    declare @stockproducto int = (select Stock from PRODUCTO where IdProducto = @IdProducto);

    begin try
        -- Iniciar la transacci�n
        begin transaction OPERACION

        -- Si se va a sumar al carrito
        if (@Sumar = 1)
        begin
            -- Verificar si hay stock disponible
            if (@stockproducto > 0)
            begin
                -- Si el carrito ya existe, actualizar la cantidad y las fechas
                if (@existecarrito = 1)
                    update CARRITO set Cantidad = Cantidad + 1, FechaInicio = @FechaInicio, FechaFin = @FechaFin where IdArrendador = @IdArrendador and IdProducto = @IdProducto;
                -- Si el carrito no existe, insertar un nuevo registro
                else
                    insert into CARRITO (IdArrendador, IdProducto, Cantidad, FechaInicio, FechaFin) values (@IdArrendador, @IdProducto, 1, @FechaInicio, @FechaFin);
                
                -- Actualizar el stock del producto
                update PRODUCTO set Stock = Stock - 1 where IdProducto = @IdProducto;
            end
            else
            begin
                -- Si no hay stock, establecer resultado y mensaje de error
                set @Resultado = 0;
                set @Mensaje = 'El producto no cuenta con stock disponible';
            end
        end
        else
        begin
            -- Si se va a restar del carrito
            update CARRITO set Cantidad = Cantidad - 1 where IdArrendador = @IdArrendador and IdProducto = @IdProducto;
            update PRODUCTO set Stock = Stock + 1 where IdProducto = @IdProducto;
        end

        -- Confirmar la transacci�n
        commit transaction OPERACION
    end try
    begin catch
        -- En caso de error, establecer resultado y mensaje de error, y revertir la transacci�n
        set @Resultado = 0;
        set @Mensaje = error_message();
        rollback transaction OPERACION
    end catch
end;


create function fn_obtenerCarritoCliente(
    @IdArrendador int
)
returns table
as
    return (
        -- Seleccionar los detalles del carrito para el cliente especificado
        select
            p.IdProducto,                                   
            m.Descripcion as DesMarca,
            p.Nombre,
            p.Precio,
            c.Cantidad,
            convert(char(10), c.FechaInicio, 103) as FechaInicio,
            convert(char(10), c.FechaFin, 103) as FechaFin,
            p.RutaImagen,
            p.NombreImagen
        from CARRITO c
        inner join PRODUCTO p on p.IdProducto = c.IdProducto
        inner join MARCA m on m.IdMarca = p.IdMarca
        where c.IdArrendador = @IdArrendador                        -- Filtrar por el ID del cliente
);


CREATE PROC sp_ActualizarFechaProductoCarrito(
    @IdArrendador INT,
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

    DECLARE @existecarrito BIT = IIF(EXISTS(SELECT * FROM CARRITO WHERE IdArrendador = @IdArrendador AND IdProducto = @IdProducto), 1, 0);

    BEGIN TRY
        BEGIN TRANSACTION OPERACION;

        IF @existecarrito = 1
        BEGIN
            UPDATE CARRITO
            SET FechaInicio = @FechaInicio,
                FechaFin = @FechaFin
            WHERE IdArrendador = @IdArrendador
            AND IdProducto = @IdProducto;
        END
        ELSE
        BEGIN
            SET @Resultado = 0;
            SET @Mensaje = 'No se encontr� el producto en el carrito.';
        END;

        COMMIT TRANSACTION OPERACION;
    END TRY
    BEGIN CATCH
        SET @Resultado = 0;
        SET @Mensaje = ERROR_MESSAGE();
        ROLLBACK TRANSACTION OPERACION;
    END CATCH;
END;


CREATE PROC sp_EliminarCarrito(
    @IdArrendador INT,
    @IdProducto INT,
    @Resultado BIT OUTPUT
)
AS
BEGIN

    SET @Resultado = 1

    DECLARE @cantidadproducto INT = (SELECT Cantidad FROM CARRITO WHERE IdArrendador = @IdArrendador AND IdProducto = @IdProducto)

    BEGIN TRY

        BEGIN TRANSACTION OPERACION

            UPDATE PRODUCTO SET Stock = Stock + @cantidadproducto WHERE IdProducto = @IdProducto
            DELETE TOP (1) FROM CARRITO WHERE IdArrendador = @IdArrendador AND IdProducto = @IdProducto

            COMMIT TRANSACTION OPERACION

    END TRY
    BEGIN CATCH
        SET @Resultado = 0
        ROLLBACK TRANSACTION OPERACION
    END CATCH
END;


---------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE DETALLE ALQUILER -----------------------------------------------
CREATE TYPE [dbo].[EDetalle_Alquiler] AS TABLE(
    [IdProducto] int NULL,
    [Cantidad] int NULL,
	[fechaInicio] datetime NULL,
	[fechaFin] datetime NULL,
    [Total] decimal(18,2) NULL
)


CREATE PROCEDURE usp_RegistrarAlquiler(
    @IdArrendador int,
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

        INSERT INTO ALQUILER(IdArrendador, TotalProducto, MontoTotal, Contacto, IdBarrio, Telefono, Direccion, IdTransaccion)
        VALUES(@IdArrendador, @TotalProducto, @MontoTotal, @Contacto, @IdBarrio, @Telefono, @Direccion, @IdTransaccion)

        SET @idalquiler = SCOPE_IDENTITY()

        insert into DETALLE_ALQUILER (IdAlquiler, IdProducto, Cantidad, FechaInicio, FechaFin, Total)
		select @idalquiler, IdProducto, Cantidad, fechaInicio, fechaFin, Total from @DetalleAlquiler

		delete from CARRITO where IdArrendador = @IdArrendador

		commit transaction registro
  END TRY
    BEGIN CATCH
        set @Resultado = 0
		set @Mensaje = ERROR_MESSAGE()
		rollback transaction registro
    END CATCH
END

Create Function fn_ListarAlquiler(
@IdArrendador int
)
RETURNS TABLE
AS 
RETURN
(
	SELECT P.RutaImagen, P.NombreImagen, P.Nombre, P.Precio, DA.Cantidad, DA.FechaInicio, DA.FechaFin, DA.Total, A.IdTransaccion FROM DETALLE_ALQUILER DA
	INNER JOIN PRODUCTO P ON P.IdProducto = DA.IdProducto
	INNER JOIN ALQUILER A ON A.IdAlquiler = DA.IdAlquiler
	WHERE A.IdArrendador = @IdArrendador
);


------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA GENERACION DE REPORTES ALQUILER-----------------------------------------------
create proc sp_ReporteDashdoardArriendo
@IdArrendatario int
as
begin
      select
        -- Contar el n�mero total de clientes
        (select count(*) from ARRENDADOR ARR
		inner join ALQUILER A ON A.IdArrendador = ARR.IdArrendador
		inner join DETALLE_ALQUILER DA ON DA.IdAlquiler = A.IdAlquiler
		inner join PRODUCTO P ON P.IdProducto = DA.IdProducto
		inner join ARRENDATARIO ART ON ART.IdArrendatario = P.IdArrendatario
		WHERE ART.IdArrendatario = @IdArrendatario) AS TotalUsuario,

        -- Sumar la cantidad total de alquileres en la tabla DETALLE_ALQUILER
        (select isnull(sum(CANTIDAD), 0) from DETALLE_ALQUILER DA
		inner join PRODUCTO P ON P.IdProducto = DA.IdProducto
		inner join ARRENDATARIO ART ON ART.IdArrendatario = P.IdArrendatario
		WHERE ART.IdArrendatario = @IdArrendatario
		) AS TotalAlquiler,

        -- Contar el n�mero total de productos en la tabla PRODUCTO
        (select count(*) from PRODUCTO P
		inner join ARRENDATARIO ART ON ART.IdArrendatario = P.IdArrendatario
		WHERE ART.IdArrendatario = @IdArrendatario
		) [TotalProducto]
end;


create proc sp_ReporteAlquilerArriendo(
	@IdArrendatario int,
    @fechainicio varchar(10),
    @fechafin varchar(10),
    @idtransaccion varchar(50)
)
as
begin
    -- Establecer el formato de fecha como d�a/mes/a�o
    set dateformat dmy;

    -- Seleccionar y devolver el informe de ventas
    select 
        convert(char(10), a.FechaAlquiler, 103) [FechaAlquiler],
        
        concat(c.Nombres, ' ', c.Apellidos) [Cliente], p.Nombre [Producto], p.Precio, dv.Cantidad, dv.FechaInicio, dv.FechaFin, dv.Total, a.IdTransaccion
    from DETALLE_ALQUILER dv
    inner join PRODUCTO p on p.IdProducto = dv.IdProducto
    inner join ALQUILER a on a.IdAlquiler = dv.IdAlquiler
    inner join USUARIO c on c.IdUsuario = a.IdArrendador
	inner join ARRENDATARIO ART on ART.IdArrendatario = p.IdArrendatario
    where 
        -- Filtrar las fechas de alquiler entre la fecha de inicio y la fecha de fin proporcionadas
        convert(date, a.FechaAlquiler) between @fechainicio and @fechafin
        
        -- Filtrar por el ID de la transacci�n, si se proporciona
        and a.IdTransaccion = iif(@idtransaccion = '', a.IdTransaccion, @idtransaccion) and ART.IdArrendatario = @IdArrendatario
end;


-------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------- PROCEDIMIENTO ALMACENADO PARA EL CRUD DE PRODUCTO -----------------------------------------------
create proc sp_ListarProductoArrendatario(
	@IdArrendatario int
)
as
begin
	SELECT p.IdProducto, p.Nombre, p.Descripcion, m.IdMarca, m.Descripcion AS DesMarca, c.IdCategoria, c.Descripcion AS DesCategoria,
			p.Precio, p.Stock, p.RutaImagen, p.NombreImagen, p.Activo, p.IdArrendatario
	FROM PRODUCTO P
	INNER JOIN MARCA m ON m.IdMarca = p.IdMarca
	INNER JOIN CATEGORIA c ON c.IdCategoria = p.IdCategoria
	INNER JOIN ARRENDATARIO ART ON ART.IdArrendatario = P.IdArrendatario
	WHERE ART.IdArrendatario = @IdArrendatario
end;

create proc sp_EliminarProductoArrendatario (
    @IdProducto int,
	@IdArrendatario int,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin
    -- Inicializar el resultado en 0
    set @Resultado = 0;

    -- Verificar si el producto no est� relacionado con ninguna venta en DETALLE_VENTA
    if not exists (
        select * from DETALLE_ALQUILER da
        inner join PRODUCTO p on p.IdProducto = da.IdProducto
        where p.IdProducto = @IdProducto and p.IdArrendatario = @IdArrendatario
    )
    begin
        -- Eliminar el producto de la tabla PRODUCTO
        delete top (1) from PRODUCTO where IdProducto = @IdProducto;
        -- Establecer el resultado como 1 para indicar que la eliminaci�n fue exitosa
        set @Resultado = 1;
    end
    else
        -- Establecer un mensaje indicando que el producto est� relacionado a una venta
        set @Mensaje = 'El producto se encuentra relacionado a un alquiler';
end;



select *from USUARIO
