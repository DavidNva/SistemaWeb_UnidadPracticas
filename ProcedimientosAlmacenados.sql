Use UDP_CONTROL;
--El Orden de ejecucion de scripts es: 
/*
  1. Biblioteca-DDL Y triGGERS 
  2. Vistas
  3. Procedimientos Almacenados
  4. Inserciones  
*/
-- --Para cada procedimiento se debe
-- --Categoria: Procedimiento para generar codigo al insertar
-- --      Procedimiento para actualizar
-- --      Procedimiento para eliminar - (para el que lo requiera)
-- go
go

create procedure sp_RegistrarCategoria(--Hay un indice unico para el nombre completo del Categoria 
    --@IDCategoria int,---El id es Identity
    @Descripcion varchar(100),--Tiene indice compuesto con Apellidos
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output
    --@ID_TipoPersona int --ESTAR� COMO DEFAULT = 1, ES DECIR, COMO LECTOR
    --FechaCreacion date --Esta como default DEFAULT GETDATE()
    )
as
begin
    SET @Resultado = 0 --No permite repetir un mismo correo, ni al insertar ni al actualizar
    IF NOT EXISTS (SELECT * FROM Categoria_Herramienta WHERE Descripcion = @Descripcion)
    begin 
        insert into Categoria_Herramienta(Descripcion, Activo) values 
        (@Descripcion, @Activo)
        --La funci�n SCOPE_IDENTITY() devuelve el �ltimo ID generado para cualquier tabla de la sesi�n activa y en el �mbito actual.
        SET @Resultado = scope_identity()
    end 
    else 
     SET @Mensaje = 'La categoria ya existe'
end
GO
create  proc sp_EditarCategoria(
    @IdCategoria int,
    @Descripcion varchar(100),--Tiene indice compuesto con Apellidos
    @Activo bit,
    @Mensaje varchar(500) output,
    @Resultado int output
)
as
begin 
    SET @Resultado = 0 --false
    IF NOT EXISTS (SELECT * FROM Categoria_Herramienta WHERE Descripcion = @Descripcion and IDCategoria != @IdCategoria)
    begin 
         update top(1) Categoria_Herramienta set 
        Descripcion = @Descripcion,
        Activo = @Activo
        where IDCategoria = @IdCategoria

        set @Resultado = 1 --true
    end 
    else 
       set @Mensaje = 'La categoria ya existe'
end

go
create proc sp_EliminarCategoria( --Trabajo como un booleano
    @IdCategoria int,
    @Mensaje varchar(500) output,
    @Resultado bit output
)
as
begin 
    SET @Resultado = 0 --false
    IF NOT EXISTS (SELECT * FROM Libro p --validacion de que la categoria no este relacionada con un producto
    inner join Categoria_Herramienta c on c.IDCategoria = p.Id_Categoria WHERE p.Id_Categoria= @IdCategoria)
    begin 
        delete top(1) from Categoria_Herramienta where IDCategoria = @IdCategoria
        set @Resultado = 1 --true
    end 
    else 
        set @Mensaje = 'La categoria se encuentra relacionada con un libro'
end


go
use UDP_Control
--inserciones prueba
exec sp_RegistrarCategoria 'CONSULTA',1,'',1
exec sp_RegistrarCategoria 'GENERALIDADES',1,'',1
exec sp_RegistrarCategoria 'LITERATURA',1,'',1
exec sp_RegistrarCategoria 'FILOSOF�A Y PSICOLOG�A',1,'',1
exec sp_RegistrarCategoria 'RELIGIONES',1,'',1
exec sp_RegistrarCategoria 'CIENCIAS SOCIALES',1,'',1
exec sp_RegistrarCategoria 'CIENCIAS PURAS',1,'',1
exec sp_RegistrarCategoria 'CIENCIAS APLICADAS',1,'',1
exec sp_RegistrarCategoria 'BELLAS ARTES',1,'',1
exec sp_RegistrarCategoria 'GEOGRAF�A E HISTORIA',1,'',1
exec sp_RegistrarCategoria 'NOVELAS',1,'',1
exec sp_RegistrarCategoria 'POES�A',1,'',1
exec sp_RegistrarCategoria 'CUENTOS',1,'',1
exec sp_RegistrarCategoria 'BIOGRAF�AS',1,'',1
exec sp_RegistrarCategoria 'M�XICO',1,'',1
exec sp_RegistrarCategoria 'PUEBLA',1,'',1
exec sp_RegistrarCategoria 'LIBROS DONADOS',1,'',1
exec sp_RegistrarCategoria 'LIBROS INFANTILES',1,'',1

select * from Categoria_Herramienta