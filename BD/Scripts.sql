USE [master]
GO
/****** Object:  Database [EjemploChat]    Script Date: 06/12/2016 12:45:27 a. m. ******/
CREATE DATABASE [EjemploChat]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'EjemploChat', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\DATA\EjemploChat.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'EjemploChat_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.SQLEXPRESS2012\MSSQL\DATA\EjemploChat_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [EjemploChat] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [EjemploChat].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [EjemploChat] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [EjemploChat] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [EjemploChat] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [EjemploChat] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [EjemploChat] SET ARITHABORT OFF 
GO
ALTER DATABASE [EjemploChat] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [EjemploChat] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [EjemploChat] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [EjemploChat] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [EjemploChat] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [EjemploChat] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [EjemploChat] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [EjemploChat] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [EjemploChat] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [EjemploChat] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [EjemploChat] SET  DISABLE_BROKER 
GO
ALTER DATABASE [EjemploChat] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [EjemploChat] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [EjemploChat] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [EjemploChat] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [EjemploChat] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [EjemploChat] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [EjemploChat] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [EjemploChat] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [EjemploChat] SET  MULTI_USER 
GO
ALTER DATABASE [EjemploChat] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [EjemploChat] SET DB_CHAINING OFF 
GO
ALTER DATABASE [EjemploChat] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [EjemploChat] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [EjemploChat]
GO
/****** Object:  StoredProcedure [dbo].[spConversacion_Actualizar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spConversacion_Actualizar] 
	@Opcion                  SMALLINT = 0,
	@ConversacionId          INT,
	@ConversacionDescripcion NVARCHAR(500),
	@Foto                    IMAGE = NULL,
	@UsuarioModificacionId   INT,
	@FechaModificacion       DATETIME,
	@UsuarioBajaId           INT = NULL,
	@FechaBaja               DATETIME = NULL,
	@Baja                    BIT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	IF @ConversacionId = 0
		SET @ConversacionId = (SELECT ConversacionId FROM dbo.Conversacion AS a WHERE a.ConversacionDescripcion = @ConversacionDescripcion)

	IF ISNULL(@ConversacionId, 0) = 0
	BEGIN
		EXEC dbo.spConversacion_Insertar @Opcion = 1, @ConversacionDescripcion = @ConversacionDescripcion, @Foto = @Foto, @UsuarioCreacionId = @UsuarioModificacionId, @UsuarioModificacionId = @UsuarioModificacionId
	END
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE dbo.Conversacion
		SET
				ConversacionDescripcion = @ConversacionDescripcion,
				Foto                    = @Foto,
				UsuarioModificacionId   = @UsuarioModificacionId,
				FechaModificacion       = @FechaModificacion,
				UsuarioBajaId           = @UsuarioBajaId,
				FechaBaja               = @FechaBaja,
				Baja                    = @Baja
		WHERE 	ConversacionId = @ConversacionId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@ConversacionId ConversacionId
	END
END

IF @Opcion = 2
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE 	dbo.Conversacion
		SET
				UsuarioBajaId = @UsuarioBajaId,
				FechaBaja     = GETDATE(),
				Baja          = 1 
		WHERE 	ConversacionId = @ConversacionId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@ConversacionId ConversacionId
	END
END

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spConversacion_Consultar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConversacion_Consultar] 
	@Opcion					SMALLINT = 0,
	@ConversacionId			int = 0,
	@ConversacionDescripcion	nvarchar(500) = '',
	@Foto					image = NULL,
	@Baja					bit = NULL
AS
SET NOCOUNT ON
BEGIN
	IF @Opcion = 1
	BEGIN
		SELECT	a.ConversacionId, a.ConversacionDescripcion, a.ConversacionDescripcion, a.Foto, a.Baja
		FROM dbo.Conversacion AS a
		WHERE 	a.ConversacionId = @ConversacionId
	END

	IF @Opcion = 2
	BEGIN
		SELECT	a.ConversacionId, a.ConversacionDescripcion, a.ConversacionDescripcion, a.Foto, a.Baja
		FROM dbo.Conversacion AS a
		WHERE	(@ConversacionId	= 0	OR a.ConversacionId = @ConversacionId)
			AND	(@ConversacionDescripcion	=''		OR a.ConversacionDescripcion	LIKE '%' + @ConversacionDescripcion + '%')
			AND	(@ConversacionDescripcion	=NULL		OR a.ConversacionDescripcion	= @ConversacionDescripcion)
			AND	(@Baja					IS NULL	OR a.Baja					= @Baja)
	END

	IF @Opcion = 3
	BEGIN
		SELECT 	a.ConversacionId, a.ConversacionDescripcion
		FROM dbo.Conversacion AS a
		WHERE 	(@ConversacionId				= 0     OR a.ConversacionId = @ConversacionId)
			AND	(@ConversacionDescripcion	=''		OR a.ConversacionDescripcion	LIKE '%' + @ConversacionDescripcion + '%')
			AND	(@ConversacionDescripcion	=NULL		OR a.ConversacionDescripcion	= @ConversacionDescripcion)
			AND	(@Baja					IS NULL	OR a.Baja					= @Baja)
		ORDER BY a.ConversacionDescripcion
	END
END
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spConversacion_Insertar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConversacion_Insertar]
	@Opcion                  SMALLINT = 0,
	@ConversacionDescripcion NVARCHAR(500),
	@Foto                    IMAGE = NULL,
	@UsuarioCreacionId       INT,
	@UsuarioModificacionId   INT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN

	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	DECLARE @Identity INT
	SET @Identity = 0

	IF @ErrorId = 0
	BEGIN
		INSERT INTO dbo.Conversacion(
			ConversacionDescripcion, Foto, UsuarioCreacionId, UsuarioModificacionId)
		VALUES(
			@ConversacionDescripcion, @Foto, @UsuarioCreacionId, @UsuarioModificacionId)

		SELECT @Identity  = SCOPE_IDENTITY()
	END
END

RETURN @Identity


SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spConversacionUsuario_Actualizar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spConversacionUsuario_Actualizar] 
	@Opcion                SMALLINT = 0,
	@ConversacionUsuarioId INT = 0,
	@ConversacionId        INT,
	@UsuarioId             INT,
	@UsuarioModificacionId INT = 0,
	@FechaModificacion     DATETIME = NULL,
	@UsuarioBajaId         INT = NULL,
	@FechaBaja             DATETIME = NULL,
	@Baja                  BIT = 0
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	IF @ConversacionUsuarioId = 0
		SET @ConversacionUsuarioId = (SELECT ConversacionUsuarioId FROM dbo.ConversacionUsuario AS a WHERE a.ConversacionId = @ConversacionId AND a.UsuarioId = @UsuarioId)

	IF ISNULL(@ConversacionUsuarioId, 0) = 0
	BEGIN
		EXEC dbo.spConversacionUsuario_Insertar @Opcion = 1, @ConversacionId = @ConversacionId, @UsuarioId = @UsuarioId, @UsuarioCreacionId = @UsuarioModificacionId, @UsuarioModificacionId = @UsuarioModificacionId
	END
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE dbo.ConversacionUsuario
		SET
				ConversacionId        = @ConversacionId,
				UsuarioId             = @UsuarioId,
				UsuarioModificacionId = @UsuarioModificacionId,
				FechaModificacion     = GETDATE(),
				UsuarioBajaId         = @UsuarioBajaId,
				FechaBaja             = @FechaBaja,
				Baja                  = @Baja
		WHERE 	ConversacionUsuarioId = @ConversacionUsuarioId
	END
END

IF @Opcion = 2
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE 	dbo.ConversacionUsuario
		SET
				UsuarioBajaId = @UsuarioBajaId,
				FechaBaja     = GETDATE(),
				Baja          = 1 
		WHERE 	ConversacionUsuarioId = @ConversacionUsuarioId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@ConversacionUsuarioId ConversacionUsuarioId
	END
END

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spConversacionUsuario_Consultar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConversacionUsuario_Consultar] 
	@Opcion				SMALLINT = 0,
	@ConversacionUsuarioId	int = 0,
	@ConversacionId		int = 0,
	@UsuarioId				int = 0,
	@Baja					bit = NULL
AS
SET NOCOUNT ON
BEGIN
	IF @Opcion = 1
	BEGIN
		SELECT	a.ConversacionUsuarioId, a.ConversacionId, b.ConversacionDescripcion, a.UsuarioId, 
				a.Baja
		FROM dbo.ConversacionUsuario AS a
			INNER JOIN dbo.Conversacion AS b ON a.ConversacionId = b.ConversacionId
			INNER JOIN dbo.Usuario AS c ON a.UsuarioId = c.UsuarioId
		WHERE 	a.ConversacionUsuarioId = @ConversacionUsuarioId
	END

	IF @Opcion = 2
	BEGIN
		SELECT	a.ConversacionUsuarioId, a.ConversacionId, b.ConversacionDescripcion, a.UsuarioId, 
				a.Baja
		FROM dbo.ConversacionUsuario AS a
			INNER JOIN dbo.Conversacion AS b ON a.ConversacionId = b.ConversacionId
			INNER JOIN dbo.Usuario AS c ON a.UsuarioId = c.UsuarioId
		WHERE	(@ConversacionUsuarioId	= 0	OR a.ConversacionUsuarioId = @ConversacionUsuarioId)
			AND	(@ConversacionId		=0		OR a.ConversacionId		= @ConversacionId)
			AND	(@UsuarioId				=0		OR a.UsuarioId				= @UsuarioId)
			AND	(@Baja					IS NULL	OR a.Baja					= @Baja)
	END
END
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spConversacionUsuario_Insertar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConversacionUsuario_Insertar]
	@Opcion                SMALLINT = 0,
	@ConversacionId        INT,
	@UsuarioId             INT,
	@UsuarioCreacionId     INT,
	@UsuarioModificacionId INT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN

	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	DECLARE @Identity INT
	SET @Identity = 0

	IF @ErrorId = 0
	BEGIN
		INSERT INTO dbo.ConversacionUsuario(
			ConversacionId, UsuarioId, UsuarioCreacionId, UsuarioModificacionId)
		VALUES(
			@ConversacionId, @UsuarioId, @UsuarioCreacionId, @UsuarioModificacionId)

		SELECT @Identity  = SCOPE_IDENTITY()
	END
END

SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

SELECT @Identity ConversacionUsuarioId


SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spMensaje_Actualizar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMensaje_Actualizar] 
	@Opcion                SMALLINT = 0,
	@MensajeId             INT,
	@ConversacionId        INT,
	@MensajeDescripcion    NVARCHAR(4000),
	@AdjuntoNombre         NVARCHAR(4000),
	@UsuarioModificacionId INT,
	@FechaModificacion     DATETIME,
	@UsuarioBajaId         INT = NULL,
	@FechaBaja             DATETIME = NULL,
	@Baja                  BIT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	IF @MensajeId = 0
		SET @MensajeId = (SELECT MensajeId FROM dbo.Mensaje AS a WHERE a.ConversacionId = @ConversacionId AND a.MensajeDescripcion = @MensajeDescripcion AND a.AdjuntoNombre = @AdjuntoNombre)

	IF ISNULL(@MensajeId, 0) = 0
	BEGIN
		EXEC dbo.spMensaje_Insertar @Opcion = 1, @ConversacionId = @ConversacionId, @MensajeDescripcion = @MensajeDescripcion, @AdjuntoNombre = @AdjuntoNombre, @UsuarioCreacionId = @UsuarioModificacionId, @UsuarioModificacionId = @UsuarioModificacionId
	END
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE dbo.Mensaje
		SET
				ConversacionId        = @ConversacionId,
				MensajeDescripcion    = @MensajeDescripcion,
				AdjuntoNombre         = @AdjuntoNombre,
				UsuarioModificacionId = @UsuarioModificacionId,
				FechaModificacion     = @FechaModificacion,
				UsuarioBajaId         = @UsuarioBajaId,
				FechaBaja             = @FechaBaja,
				Baja                  = @Baja
		WHERE 	MensajeId = @MensajeId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@MensajeId MensajeId
	END
END

IF @Opcion = 2
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE 	dbo.Mensaje
		SET
				UsuarioBajaId = @UsuarioBajaId,
				FechaBaja     = GETDATE(),
				Baja          = 1 
		WHERE 	MensajeId = @MensajeId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@MensajeId MensajeId
	END
END

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spMensaje_Consultar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMensaje_Consultar] 
	@Opcion				SMALLINT = 0,
	@MensajeId			int = 0,
	@ConversacionId		int = 0,
	@MensajeDescripcion	nvarchar(4000) = '',
	@AdjuntoNombre		nvarchar(4000) = '',
	@Baja				bit = NULL,
	@UsuarioId			INT = 0,
	@UsuarioConversacionId INT = 0
AS
SET NOCOUNT ON
BEGIN
	IF @Opcion = 1
	BEGIN
		SELECT	a.MensajeId, a.ConversacionId, b.ConversacionDescripcion, a.MensajeDescripcion, a.MensajeDescripcion, 
				a.AdjuntoNombre, a.AdjuntoNombre, a.Baja
		FROM dbo.Mensaje AS a
			INNER JOIN dbo.Conversacion AS b ON a.ConversacionId = b.ConversacionId
		WHERE 	a.MensajeId = @MensajeId
	END

	IF @Opcion = 2
	BEGIN
		SELECT	a.MensajeId, a.ConversacionId, b.ConversacionDescripcion, a.MensajeDescripcion, a.MensajeDescripcion, 
				a.AdjuntoNombre, a.AdjuntoNombre, a.Baja
		FROM dbo.Mensaje AS a
			INNER JOIN dbo.Conversacion AS b ON a.ConversacionId = b.ConversacionId
		WHERE	(@MensajeId	= 0	OR a.MensajeId = @MensajeId)
			AND	(@ConversacionId		=0		OR a.ConversacionId		= @ConversacionId)
			AND	(@MensajeDescripcion	=''		OR a.MensajeDescripcion	LIKE '%' + @MensajeDescripcion + '%')
			AND	(@MensajeDescripcion	=NULL		OR a.MensajeDescripcion	= @MensajeDescripcion)
			AND	(@AdjuntoNombre		=''		OR a.AdjuntoNombre		LIKE '%' + @AdjuntoNombre + '%')
			AND	(@AdjuntoNombre		=NULL		OR a.AdjuntoNombre		= @AdjuntoNombre)
			AND	(@Baja				IS NULL	OR a.Baja				= @Baja)
	END

	IF @Opcion = 3
	BEGIN
		SELECT 	a.MensajeId, a.MensajeDescripcion
		FROM dbo.Mensaje AS a
			INNER JOIN dbo.Conversacion AS b ON a.ConversacionId = b.ConversacionId
		WHERE 	(@MensajeId				= 0     OR a.MensajeId = @MensajeId)
			AND	(@ConversacionId		=0		OR a.ConversacionId		= @ConversacionId)
			AND	(@MensajeDescripcion	=''		OR a.MensajeDescripcion	LIKE '%' + @MensajeDescripcion + '%')
			AND	(@MensajeDescripcion	=NULL		OR a.MensajeDescripcion	= @MensajeDescripcion)
			AND	(@AdjuntoNombre		=''		OR a.AdjuntoNombre		LIKE '%' + @AdjuntoNombre + '%')
			AND	(@AdjuntoNombre		=NULL		OR a.AdjuntoNombre		= @AdjuntoNombre)
			AND	(@Baja				IS NULL	OR a.Baja				= @Baja)
		ORDER BY a.MensajeDescripcion
	END

	IF @Opcion = 4
	BEGIN
		IF @ConversacionId = 0
			SET	@ConversacionId =	(
										SELECT	TOP 1 a.ConversacionId
										FROM	dbo.ConversacionUsuario			AS a
											INNER JOIN dbo.ConversacionUsuario	AS b ON a.ConversacionId = b.ConversacionId	
																					AND	a.ConversacionUsuarioId <> b.ConversacionUsuarioId
										WHERE	a.UsuarioId = @UsuarioId
											AND	b.UsuarioId = @UsuarioConversacionId
									)

		IF ISNULL(@ConversacionId, 0) = 0
			EXEC @ConversacionId = dbo.spConversacion_Insertar	@Opcion = 1,
																@ConversacionDescripcion = '',
																@Foto = null,
																@UsuarioCreacionId = @UsuarioId,
																@UsuarioModificacionId = @UsuarioId

		EXEC [dbo].[spConversacionUsuario_Actualizar] @Opcion = 1, @ConversacionId = @ConversacionId, @UsuarioId = @UsuarioId
		EXEC [dbo].[spConversacionUsuario_Actualizar] @Opcion = 1, @ConversacionId = @ConversacionId, @UsuarioId = @UsuarioConversacionId

		SELECT	a.MensajeId, a.ConversacionId, a.MensajeDescripcion, 
				CONVERT(BIT, CASE WHEN a.UsuarioCreacionId = @UsuarioId THEN 1 ELSE 0 END) AS Propio,
				a.AdjuntoNombre, a.UsuarioCreacionId, a.FechaCreacion,
				b.Nombre + ' ' + b.Paterno + ' ' + b.Materno AS UsuarioConversacionDescripcion
		INTO	#tmpMensajes
		FROM	dbo.Mensaje	AS a
			INNER JOIN dbo.Usuario	AS b ON a.UsuarioCreacionId = b.UsuarioId
		WHERE	a.ConversacionId = @ConversacionId

		IF NOT EXISTS (SELECT TOP 1 * FROM #tmpMensajes)
			SELECT	0 AS MensajeId, @ConversacionId AS ConversacionId, 
					'Parece que no has hablado con este usuario, intenta decir ¡Hola!' AS MensajeDescripcion,
					CONVERT(BIT, 0) AS Propio,
					'' AS AdjuntoNombre, 0 AS UsuarioCreacionId, GETDATE() AS FechaCreacion,
					'Sistema' AS UsuarioConversacionDescripcion
		ELSE
			SELECT	*
			FROM	#tmpMensajes
		
		DROP TABLE #tmpMensajes
	END
END
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spMensaje_Insertar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMensaje_Insertar]
	@Opcion                SMALLINT = 0,
	@ConversacionId        INT,
	@MensajeDescripcion    NVARCHAR(4000),
	@AdjuntoNombre         NVARCHAR(4000),
	@UsuarioCreacionId     INT,
	@UsuarioModificacionId INT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN

	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	DECLARE @Identity INT
	SET @Identity = 0

	IF @ErrorId = 0
	BEGIN
		INSERT INTO dbo.Mensaje(
			ConversacionId, MensajeDescripcion, AdjuntoNombre, UsuarioCreacionId, UsuarioModificacionId)
		VALUES(
			@ConversacionId, @MensajeDescripcion, @AdjuntoNombre, @UsuarioCreacionId, @UsuarioModificacionId)

		SELECT @Identity  = SCOPE_IDENTITY()
	END
END

SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

SELECT @Identity MensajeId


SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spMensajeVisto_Actualizar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spMensajeVisto_Actualizar] 
	@Opcion                SMALLINT = 0,
	@MensajeVistoId        INT,
	@MensajeId             INT,
	@UsuarioModificacionId INT,
	@FechaModificacion     DATETIME,
	@UsuarioBajaId         INT = NULL,
	@FechaBaja             DATETIME = NULL,
	@Baja                  BIT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	IF @MensajeVistoId = 0
		SET @MensajeVistoId = (SELECT MensajeVistoId FROM dbo.MensajeVisto AS a WHERE a.MensajeId = @MensajeId)

	IF ISNULL(@MensajeVistoId, 0) = 0
	BEGIN
		EXEC dbo.spMensajeVisto_Insertar @Opcion = 1, @MensajeId = @MensajeId, @UsuarioCreacionId = @UsuarioModificacionId, @UsuarioModificacionId = @UsuarioModificacionId
	END
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE dbo.MensajeVisto
		SET
				MensajeId             = @MensajeId,
				UsuarioModificacionId = @UsuarioModificacionId,
				FechaModificacion     = @FechaModificacion,
				UsuarioBajaId         = @UsuarioBajaId,
				FechaBaja             = @FechaBaja,
				Baja                  = @Baja
		WHERE 	MensajeVistoId = @MensajeVistoId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@MensajeVistoId MensajeVistoId
	END
END

IF @Opcion = 2
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE 	dbo.MensajeVisto
		SET
				UsuarioBajaId = @UsuarioBajaId,
				FechaBaja     = GETDATE(),
				Baja          = 1 
		WHERE 	MensajeVistoId = @MensajeVistoId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@MensajeVistoId MensajeVistoId
	END
END

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spMensajeVisto_Consultar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMensajeVisto_Consultar] 
	@Opcion			SMALLINT = 0,
	@MensajeVistoId	int = 0,
	@MensajeId		int = 0,
	@Baja			bit = NULL
AS
SET NOCOUNT ON
BEGIN
	IF @Opcion = 1
	BEGIN
		SELECT	a.MensajeVistoId, a.MensajeId, b.MensajeDescripcion, a.Baja
		FROM dbo.MensajeVisto AS a
			INNER JOIN dbo.Mensaje AS b ON a.MensajeId = b.MensajeId
		WHERE 	a.MensajeVistoId = @MensajeVistoId
	END

	IF @Opcion = 2
	BEGIN
		SELECT	a.MensajeVistoId, a.MensajeId, b.MensajeDescripcion, a.Baja
		FROM dbo.MensajeVisto AS a
			INNER JOIN dbo.Mensaje AS b ON a.MensajeId = b.MensajeId
		WHERE	(@MensajeVistoId	= 0	OR a.MensajeVistoId = @MensajeVistoId)
			AND	(@MensajeId		=0		OR a.MensajeId		= @MensajeId)
			AND	(@Baja			IS NULL	OR a.Baja			= @Baja)
	END
END
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spMensajeVisto_Insertar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spMensajeVisto_Insertar]
	@Opcion                SMALLINT = 0,
	@MensajeId             INT,
	@UsuarioCreacionId     INT,
	@UsuarioModificacionId INT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN

	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	DECLARE @Identity INT
	SET @Identity = 0

	IF @ErrorId = 0
	BEGIN
		INSERT INTO dbo.MensajeVisto(
			MensajeId, UsuarioCreacionId, UsuarioModificacionId)
		VALUES(
			@MensajeId, @UsuarioCreacionId, @UsuarioModificacionId)

		SELECT @Identity  = SCOPE_IDENTITY()
	END
END

SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

SELECT @Identity MensajeVistoId


SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spUsuario_Actualizar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spUsuario_Actualizar] 
	@Opcion                SMALLINT = 0,
	@UsuarioId             INT,
	@Correo                NVARCHAR(500),
	@Contraseña            NVARCHAR(100),
	@Nombre                NVARCHAR(500),
	@Paterno               NVARCHAR(500),
	@Materno               NVARCHAR(500),
	@Foto                  IMAGE = NULL,
	@UsuarioModificacionId INT,
	@FechaModificacion     DATETIME,
	@UsuarioBajaId         INT = NULL,
	@FechaBaja             DATETIME = NULL,
	@Baja                  BIT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	IF @UsuarioId = 0
		SET @UsuarioId = (SELECT UsuarioId FROM dbo.Usuario AS a WHERE a.Correo = @Correo AND a.Contraseña = @Contraseña AND a.Nombre = @Nombre AND a.Paterno = @Paterno AND a.Materno = @Materno)

	IF ISNULL(@UsuarioId, 0) = 0
	BEGIN
		EXEC dbo.spUsuario_Insertar @Opcion = 1, @Correo = @Correo, @Contraseña = @Contraseña, @Nombre = @Nombre, @Paterno = @Paterno, @Materno = @Materno, @Foto = @Foto, @UsuarioCreacionId = @UsuarioModificacionId, @UsuarioModificacionId = @UsuarioModificacionId
	END
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE dbo.Usuario
		SET
				Correo                = @Correo,
				Contraseña            = @Contraseña,
				Nombre                = @Nombre,
				Paterno               = @Paterno,
				Materno               = @Materno,
				Foto                  = @Foto,
				UsuarioModificacionId = @UsuarioModificacionId,
				FechaModificacion     = @FechaModificacion,
				UsuarioBajaId         = @UsuarioBajaId,
				FechaBaja             = @FechaBaja,
				Baja                  = @Baja
		WHERE 	UsuarioId = @UsuarioId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@UsuarioId UsuarioId
	END
END

IF @Opcion = 2
BEGIN
	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	IF @ErrorId = 0
	BEGIN
		UPDATE 	dbo.Usuario
		SET
				UsuarioBajaId = @UsuarioBajaId,
				FechaBaja     = GETDATE(),
				Baja          = 1 
		WHERE 	UsuarioId = @UsuarioId

		SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

		SELECT 	@UsuarioId UsuarioId
	END
END

SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spUsuario_Consultar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuario_Consultar] 
	@Opcion		SMALLINT = 0,
	@UsuarioId	int = 0,
	@Correo		nvarchar(500) = '',
	@Contraseña	nvarchar(100) = '',
	@Nombre		nvarchar(500) = '',
	@Paterno	nvarchar(500) = '',
	@Materno	nvarchar(500) = '',
	@Foto		image = NULL,
	@Baja		bit = NULL
AS
SET NOCOUNT ON
BEGIN
	IF @Opcion = 1
	BEGIN
		SELECT	a.UsuarioId, a.Correo, a.Contraseña, 
				a.Nombre, a.Paterno, a.Materno, 
				a.Foto, a.Baja
		FROM	dbo.Usuario AS a
		WHERE 	a.UsuarioId = @UsuarioId
	END

	IF @Opcion = 2
	BEGIN
		SELECT	a.UsuarioId, a.Correo, a.Contraseña, 
				a.Nombre, a.Paterno, a.Materno, 
				a.Foto, a.Baja
		FROM	dbo.Usuario AS a
		WHERE	(@UsuarioId	= 0	OR a.UsuarioId = @UsuarioId)
			AND	(@Correo		=''		OR a.Correo		LIKE '%' + @Correo + '%')
			AND	(@Contraseña	=''		OR a.Contraseña	LIKE '%' + @Contraseña + '%')
			AND	(@Nombre		=''		OR a.Nombre		LIKE '%' + @Nombre + '%')
			AND	(@Paterno	=''		OR a.Paterno	LIKE '%' + @Paterno + '%')
			AND	(@Materno	=''		OR a.Materno	LIKE '%' + @Materno + '%')
			AND	(@Baja		IS NULL	OR a.Baja		= @Baja)
	END

	IF @Opcion = 3
	BEGIN
		SELECT 	a.UsuarioId, a.Nombre + ' ' + a.Paterno + ' ' + a.Materno AS UsuarioDescripcion
		FROM dbo.Usuario AS a
		WHERE	(@UsuarioId	= 0	OR a.UsuarioId <> @UsuarioId)
			AND	(@Correo		=''		OR a.Correo		LIKE '%' + @Correo + '%')
			AND	(@Contraseña	=''		OR a.Contraseña	LIKE '%' + @Contraseña + '%')
			AND	(@Nombre		=''		OR a.Nombre		LIKE '%' + @Nombre + '%')
			AND	(@Paterno	=''		OR a.Paterno	LIKE '%' + @Paterno + '%')
			AND	(@Materno	=''		OR a.Materno	LIKE '%' + @Materno + '%')
			AND	(@Baja		IS NULL	OR a.Baja		= @Baja)
	END

	IF @Opcion = 4
	BEGIN
		SELECT	a.UsuarioId, a.Correo, a.Contraseña, 
				a.Nombre, a.Paterno, a.Materno, 
				a.Foto, a.Baja
		FROM	dbo.Usuario AS a
		WHERE	a.Correo		= @Correo
			AND	a.Contraseña	= @Contraseña
			AND	a.Baja = 0
	END
END
SET NOCOUNT OFF

GO
/****** Object:  StoredProcedure [dbo].[spUsuario_Insertar]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spUsuario_Insertar]
	@Opcion                SMALLINT = 0,
	@Correo                NVARCHAR(500),
	@Contraseña            NVARCHAR(100),
	@Nombre                NVARCHAR(500),
	@Paterno               NVARCHAR(500),
	@Materno               NVARCHAR(500),
	@Foto                  IMAGE = NULL,
	@UsuarioCreacionId     INT,
	@UsuarioModificacionId INT
AS
SET NOCOUNT ON

DECLARE @Error BIT, @ErrorId INT, @ErrorMessage VARCHAR(1000)
SET  @Error = 0
SET  @ErrorId = 0
SET  @ErrorMessage = ''

IF @Opcion = 1
BEGIN

	/*BLOQUE DE VALIDACIONES (Inicio)*/
	/*BLOQUE DE VALIDACIONES (Fin)*/

	DECLARE @Identity INT
	SET @Identity = 0

	IF @ErrorId = 0
	BEGIN
		INSERT INTO dbo.Usuario(
			Correo, Contraseña, Nombre, Paterno, Materno, Foto, 
			UsuarioCreacionId, UsuarioModificacionId)
		VALUES(
			@Correo, @Contraseña, @Nombre, @Paterno, @Materno, @Foto, 
			@UsuarioCreacionId, @UsuarioModificacionId)

		SELECT @Identity  = SCOPE_IDENTITY()
	END
END

SELECT @Error AS Error, @ErrorId AS ErrorId, @ErrorMessage AS ErrorMessage

SELECT @Identity UsuarioId


SET NOCOUNT OFF

GO
/****** Object:  Table [dbo].[Conversacion]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conversacion](
	[ConversacionId] [int] IDENTITY(1,1) NOT NULL,
	[ConversacionDescripcion] [nvarchar](250) NOT NULL,
	[Foto] [image] NULL,
	[UsuarioCreacionId] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[UsuarioModificacionId] [int] NOT NULL,
	[FechaModificacion] [datetime] NOT NULL,
	[UsuarioBajaId] [int] NULL,
	[FechaBaja] [datetime] NULL,
	[Baja] [bit] NOT NULL,
 CONSTRAINT [PK_Conversacion] PRIMARY KEY CLUSTERED 
(
	[ConversacionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ConversacionUsuario]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConversacionUsuario](
	[ConversacionUsuarioId] [int] IDENTITY(1,1) NOT NULL,
	[ConversacionId] [int] NOT NULL,
	[UsuarioId] [int] NOT NULL,
	[UsuarioCreacionId] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[UsuarioModificacionId] [int] NOT NULL,
	[FechaModificacion] [datetime] NOT NULL,
	[UsuarioBajaId] [int] NULL,
	[FechaBaja] [datetime] NULL,
	[Baja] [bit] NOT NULL,
 CONSTRAINT [PK_ConversacionUsuario] PRIMARY KEY CLUSTERED 
(
	[ConversacionUsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Mensaje]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Mensaje](
	[MensajeId] [int] IDENTITY(1,1) NOT NULL,
	[ConversacionId] [int] NOT NULL,
	[MensajeDescripcion] [nvarchar](4000) NOT NULL,
	[AdjuntoNombre] [nvarchar](4000) NOT NULL,
	[UsuarioCreacionId] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[UsuarioModificacionId] [int] NOT NULL,
	[FechaModificacion] [datetime] NOT NULL,
	[UsuarioBajaId] [int] NULL,
	[FechaBaja] [datetime] NULL,
	[Baja] [bit] NOT NULL,
 CONSTRAINT [PK_Mensaje] PRIMARY KEY CLUSTERED 
(
	[MensajeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[MensajeVisto]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MensajeVisto](
	[MensajeVistoId] [int] IDENTITY(1,1) NOT NULL,
	[MensajeId] [int] NOT NULL,
	[UsuarioCreacionId] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[UsuarioModificacionId] [int] NOT NULL,
	[FechaModificacion] [datetime] NOT NULL,
	[UsuarioBajaId] [int] NULL,
	[FechaBaja] [datetime] NULL,
	[Baja] [bit] NOT NULL,
 CONSTRAINT [PK_MensajeVisto] PRIMARY KEY CLUSTERED 
(
	[MensajeVistoId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Usuario]    Script Date: 06/12/2016 12:45:27 a. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Usuario](
	[UsuarioId] [int] IDENTITY(1,1) NOT NULL,
	[Correo] [nvarchar](250) NOT NULL,
	[Contraseña] [nvarchar](50) NOT NULL,
	[Nombre] [nvarchar](250) NOT NULL,
	[Paterno] [nvarchar](250) NOT NULL,
	[Materno] [nvarchar](250) NOT NULL,
	[Foto] [image] NULL,
	[UsuarioCreacionId] [int] NOT NULL,
	[FechaCreacion] [datetime] NOT NULL,
	[UsuarioModificacionId] [int] NOT NULL,
	[FechaModificacion] [datetime] NOT NULL,
	[UsuarioBajaId] [int] NULL,
	[FechaBaja] [datetime] NULL,
	[Baja] [bit] NOT NULL,
 CONSTRAINT [PK_Usuario] PRIMARY KEY CLUSTERED 
(
	[UsuarioId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[Conversacion] ADD  CONSTRAINT [DF_Conversacion_UsuarioCreacionId]  DEFAULT ((0)) FOR [UsuarioCreacionId]
GO
ALTER TABLE [dbo].[Conversacion] ADD  CONSTRAINT [DF_Conversacion_FechaCreacion]  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Conversacion] ADD  CONSTRAINT [DF_Conversacion_UsuarioModificacionId]  DEFAULT ((0)) FOR [UsuarioModificacionId]
GO
ALTER TABLE [dbo].[Conversacion] ADD  CONSTRAINT [DF_Conversacion_FechaModificacion]  DEFAULT (getdate()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Conversacion] ADD  CONSTRAINT [DF_Conversacion_Baja]  DEFAULT ((0)) FOR [Baja]
GO
ALTER TABLE [dbo].[ConversacionUsuario] ADD  CONSTRAINT [DF_ConversacionUsuario_UsuarioCreacionId]  DEFAULT ((0)) FOR [UsuarioCreacionId]
GO
ALTER TABLE [dbo].[ConversacionUsuario] ADD  CONSTRAINT [DF_ConversacionUsuario_FechaCreacion]  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[ConversacionUsuario] ADD  CONSTRAINT [DF_ConversacionUsuario_UsuarioModificacionId]  DEFAULT ((0)) FOR [UsuarioModificacionId]
GO
ALTER TABLE [dbo].[ConversacionUsuario] ADD  CONSTRAINT [DF_ConversacionUsuario_FechaModificacion]  DEFAULT (getdate()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[ConversacionUsuario] ADD  CONSTRAINT [DF_ConversacionUsuario_Baja]  DEFAULT ((0)) FOR [Baja]
GO
ALTER TABLE [dbo].[Mensaje] ADD  CONSTRAINT [DF_Mensaje_UsuarioCreacionId]  DEFAULT ((0)) FOR [UsuarioCreacionId]
GO
ALTER TABLE [dbo].[Mensaje] ADD  CONSTRAINT [DF_Mensaje_FechaCreacion]  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Mensaje] ADD  CONSTRAINT [DF_Mensaje_UsuarioModificacionId]  DEFAULT ((0)) FOR [UsuarioModificacionId]
GO
ALTER TABLE [dbo].[Mensaje] ADD  CONSTRAINT [DF_Mensaje_FechaModificacion]  DEFAULT (getdate()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Mensaje] ADD  CONSTRAINT [DF_Mensaje_Baja]  DEFAULT ((0)) FOR [Baja]
GO
ALTER TABLE [dbo].[MensajeVisto] ADD  CONSTRAINT [DF_MensajeVisto_UsuarioCreacionId]  DEFAULT ((0)) FOR [UsuarioCreacionId]
GO
ALTER TABLE [dbo].[MensajeVisto] ADD  CONSTRAINT [DF_MensajeVisto_FechaCreacion]  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[MensajeVisto] ADD  CONSTRAINT [DF_MensajeVisto_UsuarioModificacionId]  DEFAULT ((0)) FOR [UsuarioModificacionId]
GO
ALTER TABLE [dbo].[MensajeVisto] ADD  CONSTRAINT [DF_MensajeVisto_FechaModificacion]  DEFAULT (getdate()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[MensajeVisto] ADD  CONSTRAINT [DF_MensajeVisto_Baja]  DEFAULT ((0)) FOR [Baja]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_UsuarioCreacionId]  DEFAULT ((0)) FOR [UsuarioCreacionId]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_FechaCreacion]  DEFAULT (getdate()) FOR [FechaCreacion]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_UsuarioModificacionId]  DEFAULT ((0)) FOR [UsuarioModificacionId]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_FechaModificacion]  DEFAULT (getdate()) FOR [FechaModificacion]
GO
ALTER TABLE [dbo].[Usuario] ADD  CONSTRAINT [DF_Usuario_Baja]  DEFAULT ((0)) FOR [Baja]
GO
USE [master]
GO
ALTER DATABASE [EjemploChat] SET  READ_WRITE 
GO
