CREATE DATABASE ONG_Donaciones;
GO

USE ONG_Donaciones;
GO

		------------------------------
--			  CREACI�N DE TABLAS
		------------------------------
CREATE TABLE ong.Pais (
    PaisID INT IDENTITY(1,1) PRIMARY KEY,
    NombrePais VARCHAR(100) NOT NULL
);
GO

CREATE TABLE ong.TipoDonacion (
    TipoDonacionID INT IDENTITY(1,1) PRIMARY KEY,
    NombreTipo VARCHAR(100) NOT NULL
);
GO

CREATE TABLE ong.Donante (
    DonanteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    Email VARCHAR(200),
    Telefono VARCHAR(20),
    PaisID INT NOT NULL,
    FechaRegistro DATE DEFAULT GETDATE(),
    CONSTRAINT FK_Donante_Pais FOREIGN KEY (PaisID)
        REFERENCES ong.Pais(PaisID)
);
GO

CREATE TABLE ong.Proyecto (
    ProyectoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreProyecto VARCHAR(200) NOT NULL,
    Descripcion VARCHAR(500),
    PaisID INT NOT NULL,
    FechaInicio DATE,
    FechaFin DATE,
    CONSTRAINT FK_Proyecto_Pais FOREIGN KEY (PaisID)
        REFERENCES ong.Pais(PaisID)
);
GO

CREATE TABLE ong.Beneficiario (
    BeneficiarioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(200) NOT NULL,
    PaisID INT NOT NULL,
    FechaIngreso DATE DEFAULT GETDATE(),
    CONSTRAINT FK_Beneficiario_Pais FOREIGN KEY (PaisID)
        REFERENCES ong.Pais(PaisID)
);
GO

CREATE TABLE ong.Donacion (
    DonacionID INT IDENTITY(1,1) PRIMARY KEY,
    DonanteID INT NOT NULL,
    ProyectoID INT NOT NULL,
    TipoDonacionID INT NOT NULL,
    Monto DECIMAL(12,2) NOT NULL,
    FechaDonacion DATE DEFAULT GETDATE(),

    CONSTRAINT FK_Donacion_Donante FOREIGN KEY (DonanteID)
        REFERENCES ong.Donante(DonanteID),

    CONSTRAINT FK_Donacion_Proyecto FOREIGN KEY (ProyectoID)
        REFERENCES ong.Proyecto(ProyectoID),

    CONSTRAINT FK_Donacion_Tipo FOREIGN KEY (TipoDonacionID)
        REFERENCES ong.TipoDonacion(TipoDonacionID)
);
GO

CREATE TABLE ong.DistribucionBeneficio (
    DistribucionID INT IDENTITY(1,1) PRIMARY KEY,
    DonacionID INT NOT NULL,
    BeneficiarioID INT NOT NULL,
    MontoAsignado DECIMAL(12,2),

    CONSTRAINT FK_Distribucion_Donacion FOREIGN KEY (DonacionID)
        REFERENCES ong.Donacion(DonacionID),

    CONSTRAINT FK_Distribucion_Beneficiario FOREIGN KEY (BeneficiarioID)
        REFERENCES ong.Beneficiario(BeneficiarioID)
);
GO
		------------------------------
--			INSERTS DE PRUEBA
		------------------------------
INSERT INTO ong.Pais (NombrePais)
VALUES ('El Salvador'), ('Guatemala'), ('Honduras'), 
       ('Costa Rica'), ('Nicaragua'), ('Panam�');
GO

INSERT INTO ong.TipoDonacion (NombreTipo)
VALUES ('Monetaria'), ('Alimentos'), ('Ropa'),
       ('Medicinas'), ('�tiles Escolares');
GO

INSERT INTO ong.Donante (Nombre, Email, Telefono, PaisID)
VALUES
('Carlos M�ndez', 'carlosm@example.com', '7000-1111', 1),
('Ana Torres', 'ana.torres@example.com', '7890-2222', 2),
('Fundaci�n Vida', 'contacto@vida.org', '2200-3333', 1),
('Mar�a G�mez', 'maria.g@example.com', '7444-1234', 3),
('Luis Herrera', 'luis.h@example.com', '7011-5555', 4),
('ONG Esperanza', 'info@esperanza.org', '2299-9898', 1);
GO

INSERT INTO ong.Proyecto (NombreProyecto, Descripcion, PaisID, FechaInicio, FechaFin)
VALUES
('Agua Limpia', 'Instalaci�n de filtros de agua potable', 1, '2024-01-01', '2024-12-31'),
('Becas Escolares', 'Apoyo a estudiantes de bajos recursos', 1, '2024-02-01', NULL),
('Centro M�dico Rural', 'Ampliaci�n de cl�nica comunitaria', 2, '2023-09-01', '2024-06-30'),
('Alimentos para Todos', 'Distribuci�n de paquetes alimenticios', 3, '2024-03-10', NULL);
GO

INSERT INTO ong.Beneficiario (Nombre, PaisID)
VALUES
('Jos� Mart�nez', 1),
('Luc�a S�nchez', 1),
('Pedro Ar�valo', 1),
('Familia Castillo', 2),
('Ana Ramos', 3),
('Ni�o Mart�nez', 3),
('Abuelo P�rez', 3),
('Escuela La Esperanza', 1);
GO

INSERT INTO ong.Donacion (DonanteID, ProyectoID, TipoDonacionID, Monto)
VALUES
(1, 1, 1, 150.00),
(2, 1, 4, 350.00),
(3, 2, 1, 1200.00),
(4, 3, 1, 500.00),
(5, 4, 2, 0.00),
(6, 4, 1, 900.00),
(3, 2, 5, 250.00);
GO

INSERT INTO ong.DistribucionBeneficio (DonacionID, BeneficiarioID, MontoAsignado)
VALUES
(1, 1, 75.00),
(1, 2, 75.00),

(2, 3, 200.00),
(2, 8, 150.00),

(3, 8, 1200.00),

(4, 4, 500.00),

(6, 5, 450.00),
(6, 6, 450.00),

(7, 1, 100.00),
(7, 2, 150.00);
GO

		------------------------------
--			 CREACI�N DE �NDICES
		------------------------------
CREATE INDEX IX_Donante_PaisID
ON ong.Donante (PaisID);

CREATE INDEX IX_Proyecto_PaisID
ON ong.Proyecto (PaisID);

CREATE INDEX IX_Donacion_DonanteID
ON ong.Donacion (DonanteID);

CREATE INDEX IX_Donacion_ProyectoID
ON ong.Donacion (ProyectoID);

CREATE INDEX IX_Donacion_TipoDonacionID
ON ong.Donacion (TipoDonacionID);

CREATE INDEX IX_Beneficiario_PaisID
ON ong.Beneficiario (PaisID);

CREATE INDEX IX_Distribucion_DonacionID
ON ong.DistribucionBeneficio (DonacionID);

CREATE INDEX IX_Distribucion_BeneficiarioID
ON ong.DistribucionBeneficio (BeneficiarioID);

CREATE INDEX IX_Donacion_Fecha ON ong.Donacion(FechaDonacion);
CREATE INDEX IX_Donacion_Proyecto_Donante ON ong.Donacion(ProyectoID, DonanteID);
CREATE INDEX IX_Distribucion_Beneficiario ON ong.DistribucionBeneficio(BeneficiarioID);


-- �NDICES COMPUESTOS
-- �ndice compuesto para reportes financieros por proyecto
CREATE INDEX IX_Donacion_Proyecto_Tipo
ON ong.Donacion (ProyectoID, TipoDonacionID)
INCLUDE (Monto);

-- �ndice compuesto para distribuciones por beneficiario
CREATE INDEX IX_Distribucion_Beneficiario_Donacion
ON ong.DistribucionBeneficio (BeneficiarioID, DonacionID)
INCLUDE (MontoAsignado);

-- �ndice para an�lisis por pa�s
CREATE INDEX IX_Donante_Pais_Email
ON ong.Donante (PaisID)
INCLUDE (Email, Telefono);

		------------------------------
--			CREACI�N DE USUARIOS
		------------------------------
CREATE LOGIN usuario_admin WITH PASSWORD = 'Admin123*';
CREATE LOGIN usuario_analista WITH PASSWORD = 'Analista123*';
CREATE LOGIN usuario_capturista WITH PASSWORD = 'Captura123*';

USE ONG_Donaciones;
GO

CREATE USER usuario_admin FOR LOGIN usuario_admin;
CREATE USER usuario_analista FOR LOGIN usuario_analista;
CREATE USER usuario_capturista FOR LOGIN usuario_capturista;

		------------------------------
--			  CREACI�N DE ROLES
		------------------------------
CREATE ROLE rol_admin;
CREATE ROLE rol_analista;
CREATE ROLE rol_capturista;

ALTER ROLE rol_admin ADD MEMBER usuario_admin;
ALTER ROLE rol_analista ADD MEMBER usuario_analista;
ALTER ROLE rol_capturista ADD MEMBER usuario_capturista;

-- Permisos
GRANT CONTROL ON DATABASE::ONG_Donaciones TO rol_admin;
GRANT SELECT ON SCHEMA::ong TO rol_analista;

GRANT SELECT, INSERT ON ong.Donacion TO rol_capturista;
GRANT SELECT, INSERT, UPDATE ON ong.Donante TO rol_capturista;

GRANT SELECT ON ong.Proyecto TO rol_capturista;
GRANT SELECT ON ong.Beneficiario TO rol_capturista;

		------------------------------
--			 CREACI�N DE CONSULTAS
		------------------------------
---------------------------------------------------------
-- CONSULTA 1: Total donado por cada donante y ranking (CORREGIDA)
---------------------------------------------------------
WITH Totales AS (
    SELECT 
        d.DonanteID,
        d.Nombre AS Donante,
        p.NombrePais,
        d.PaisID,
        SUM(o.Monto) AS TotalDonado
    FROM ong.Donante d
    JOIN ong.Pais p ON d.PaisID = p.PaisID
    JOIN ong.Donacion o ON o.DonanteID = d.DonanteID
    GROUP BY d.DonanteID, d.Nombre, p.NombrePais, d.PaisID
)
SELECT 
    DonanteID,
    Donante,
    NombrePais,
    TotalDonado,
    RANK() OVER(
        PARTITION BY PaisID 
        ORDER BY TotalDonado DESC
    ) AS RankingEnPais
FROM Totales
ORDER BY NombrePais, RankingEnPais;
GO

---------------------------------------------------------
-- CONSULTA 2: Total mensual acumulado de donaciones
---------------------------------------------------------
SELECT 
    DonacionID,
    FechaDonacion,
    Monto,
    SUM(Monto) OVER(
        ORDER BY FechaDonacion
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS TotalAcumulado
FROM ong.Donacion
ORDER BY FechaDonacion;
GO

---------------------------------------------------------
-- CONSULTA 3: Porcentaje que recibe cada beneficiario dentro de una donaci�n
---------------------------------------------------------
SELECT 
    db.DonacionID,
    b.Nombre AS Beneficiario,
    db.MontoAsignado,

    SUM(db.MontoAsignado) OVER(
        PARTITION BY db.DonacionID
    ) AS TotalAsignado,

    CAST(db.MontoAsignado * 100.0 /
         SUM(db.MontoAsignado) OVER(PARTITION BY db.DonacionID)
    AS DECIMAL(5,2)) AS Porcentaje
FROM ong.DistribucionBeneficio db
JOIN ong.Beneficiario b ON b.BeneficiarioID = db.BeneficiarioID
ORDER BY db.DonacionID, Porcentaje DESC;
GO

		------------------------------
--			CREACI�N DE ESQUEMAS
		------------------------------
CREATE SCHEMA ong AUTHORIZATION dbo;
GO

GRANT SELECT ON SCHEMA::ong TO rol_analista;
GRANT SELECT, INSERT ON ong.Donacion TO rol_capturista;
GRANT CONTROL ON DATABASE::ONG_Donaciones TO rol_admin;

		------------------------------
--		  CREACI�N DEL SERVER AUDIT
		------------------------------
USE master;
GO

CREATE SERVER AUDIT Audit_Donaciones
TO FILE (FILEPATH = 'C:\Auditorias\ONG\', MAXSIZE = 100 MB)
WITH (ON_FAILURE = CONTINUE);
GO

ALTER SERVER AUDIT Audit_Donaciones
WITH (STATE = ON);
GO

USE ONG_Donaciones;
GO

CREATE DATABASE AUDIT SPECIFICATION Audit_ONG
FOR SERVER AUDIT Audit_Donaciones
ADD (UPDATE ON SCHEMA::ong BY PUBLIC),
ADD (INSERT ON SCHEMA::ong BY PUBLIC),
ADD (DELETE ON SCHEMA::ong BY PUBLIC),
ADD (SELECT ON SCHEMA::ong BY PUBLIC);
GO

ALTER DATABASE AUDIT SPECIFICATION Audit_ONG
WITH (STATE = ON);
GO

-- Prueba de Auditor�a
INSERT INTO ong.Pais (NombrePais) VALUES ('Belice');
UPDATE ong.Pais SET NombrePais = 'Belice Editado' WHERE NombrePais = 'Belice';
DELETE FROM ong.Pais WHERE NombrePais = 'Belice Editado';

-- Consultas de Log
SELECT * FROM sys.fn_get_audit_file('C:\Auditorias\ONG\*.sqlaudit', DEFAULT, DEFAULT);
GO

		------------------------------------
--		  PLAN DE BACK UP Y RESTAURACI�N
		------------------------------------
USE master;
GO

ALTER DATABASE ONG_Donaciones
SET RECOVERY FULL;
GO

DECLARE @BackupFolder NVARCHAR(400) = N'C:\Backups\ONG\';

-- FULL backup
BACKUP DATABASE ONG_Donaciones
TO DISK = 'C:\Backups\ONG\ONG_FULL.bak'
WITH FORMAT, INIT, NAME = 'ONG_Donaciones-FULL', SKIP, STATS = 10;

-- Verificar
RESTORE DATABASE ONG_Donaciones
FROM DISK = 'C:\Backups\ONG\ONG_FULL.bak'
WITH REPLACE,
     NORECOVERY;

-- DIFF backup	
BACKUP DATABASE ONG_Donaciones
TO DISK = 'C:\Backups\ONG\ONG_DIFF.bak'
WITH DIFFERENTIAL, INIT, NAME = 'ONG_Donaciones-DIFF', STATS = 10;

-- Verificar
RESTORE DATABASE ONG_Donaciones
FROM DISK = 'C:\Backups\ONG\ONG_DIFF.bak'
WITH REPLACE,
     NORECOVERY;

RESTORE DATABASE ONG_Donaciones WITH RECOVERY;

-- LOG backup
BACKUP LOG ONG_Donaciones
TO DISK = 'C:\Backups\ONG\ONG_LOG.trn'
WITH INIT,
     NAME = 'ONG_Donaciones-LOG',
     SKIP, STATS = 10;

-- Verificar
RESTORE LOG ONG_Donaciones
FROM DISK = 'C:\Backups\ONG\ONG_LOG.trn'
WITH REPLACE,
     RECOVERY;

		------------------------------
--			  CREACI�N DE JOBS
		------------------------------
USE msdb;
GO
-- Job FULL
-- Variables:
DECLARE @job_name NVARCHAR(128) = N'ONG_Backup_FULL_Diario';
DECLARE @owner_login NVARCHAR(128) = N'sa';
DECLARE @command NVARCHAR(MAX);
SET @command = N'
DECLARE @BackupFolder NVARCHAR(400) = N''C:\Backups\ONG\'';
DECLARE @dbname NVARCHAR(128) = N''ONG_Donaciones'';
DECLARE @file NVARCHAR(400);
SET @file = @BackupFolder + @dbname + N''_FULL_'' + REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), '':'' ,'') + ''.bak'';
BACKUP DATABASE [ONG_Donaciones] TO DISK = @file WITH INIT, NAME = N''ONG_Donaciones-FULL'', SKIP, STATS = 10;
RESTORE VERIFYONLY FROM DISK = @file;
';

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
  EXEC msdb.dbo.sp_delete_job @job_name = @job_name, @delete_unused_schedule=1;

-- Crear job
EXEC msdb.dbo.sp_add_job @job_name = @job_name, @enabled = 1, @description = 'FULL backup diario ONG_Donaciones', @owner_login_name = @owner_login;

EXEC msdb.dbo.sp_add_jobstep
  @job_name = @job_name,
  @step_name = N'Run Full Backup',
  @subsystem = N'TSQL',
  @command = @command,
  @retry_attempts = 2,
  @retry_interval = 5;

-- Crear horario (diario a las 02:00)
EXEC msdb.dbo.sp_add_schedule @schedule_name = N'ONG_FULL_Diario_Schedule', @freq_type = 4, @freq_interval = 1, @active_start_time = 20000; -- 02:00
-- Attach schedule to job
EXEC msdb.dbo.sp_attach_schedule @job_name = @job_name, @schedule_name = N'ONG_FULL_Diario_Schedule';

-- A�adir Job al servidor
EXEC msdb.dbo.sp_add_jobserver @job_name = @job_name;
GO

-- Job DIFF
USE msdb;
GO
DECLARE @job_name NVARCHAR(128) = N'ONG_Backup_DIFF_6H';
DECLARE @owner_login NVARCHAR(128) = N'sa';
DECLARE @command NVARCHAR(MAX) = N'
DECLARE @BackupFolder NVARCHAR(400) = N''C:\Backups\ONG\'';
DECLARE @dbname NVARCHAR(128) = N''ONG_Donaciones'';
DECLARE @file NVARCHAR(400);
SET @file = @BackupFolder + @dbname + N''_DIFF_'' + REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), '':'' ,'') + ''.bak'';
BACKUP DATABASE [ONG_Donaciones] TO DISK = @file WITH DIFFERENTIAL, INIT, NAME = N''ONG_Donaciones-DIFF'', SKIP, STATS = 10;
RESTORE VERIFYONLY FROM DISK = @file;
';

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
  EXEC msdb.dbo.sp_delete_job @job_name = @job_name, @delete_unused_schedule=1;

EXEC msdb.dbo.sp_add_job @job_name = @job_name, @enabled = 1, @description = 'DIFF backup cada 6 horas ONG_Donaciones', @owner_login_name = @owner_login;

EXEC msdb.dbo.sp_add_jobstep
  @job_name = @job_name,
  @step_name = N'Run Diff Backup',
  @subsystem = N'TSQL',
  @command = @command,
  @retry_attempts = 2,
  @retry_interval = 5;

-- Frecuencia de horario: freq_type=4 (diario); freq_intervalo ignorado cuando freq_subday_type es usado
-- Use freq_subday_type=8 (cada n horas), freq_subday_interval=6
EXEC msdb.dbo.sp_add_schedule @schedule_name = N'ONG_DIFF_6H_Schedule',
    @freq_type = 4,
    @freq_interval = 1,
    @freq_subday_type = 8,
    @freq_subday_interval = 6,
    @active_start_time = 0;
EXEC msdb.dbo.sp_attach_schedule @job_name = @job_name, @schedule_name = N'ONG_DIFF_6H_Schedule';
EXEC msdb.dbo.sp_add_jobserver @job_name = @job_name;
GO

-- Job LOG
USE msdb;
GO
DECLARE @job_name NVARCHAR(128) = N'ONG_Backup_LOG_30min';
DECLARE @owner_login NVARCHAR(128) = N'sa';
DECLARE @command NVARCHAR(MAX) = N'
DECLARE @BackupFolder NVARCHAR(400) = N''C:\Backups\ONG\'';
DECLARE @dbname NVARCHAR(128) = N''ONG_Donaciones'';
DECLARE @file NVARCHAR(400);
SET @file = @BackupFolder + @dbname + N''_LOG_'' + REPLACE(CONVERT(VARCHAR(19), GETDATE(), 120), '':'' ,'') + ''.trn'';
BACKUP LOG [ONG_Donaciones] TO DISK = @file WITH INIT, NAME = N''ONG_Donaciones-LOG'', STATS = 5;
RESTORE VERIFYONLY FROM DISK = @file;
';

IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
  EXEC msdb.dbo.sp_delete_job @job_name = @job_name, @delete_unused_schedule=1;

EXEC msdb.dbo.sp_add_job @job_name = @job_name, @enabled = 1, @description = 'LOG backup cada 30 min ONG_Donaciones', @owner_login_name = @owner_login;

EXEC msdb.dbo.sp_add_jobstep
  @job_name = @job_name,
  @step_name = N'Run Log Backup',
  @subsystem = N'TSQL',
  @command = @command,
  @retry_attempts = 2,
  @retry_interval = 5;

-- Horario cada 30 minutos -> freq_subday_type = 4 (minutos), freq_subday_interval = 30
EXEC msdb.dbo.sp_add_schedule @schedule_name = N'ONG_LOG_30min_Schedule',
    @freq_type = 4,
    @freq_interval = 1,
    @freq_subday_type = 4,
    @freq_subday_interval = 30,
    @active_start_time = 0;
EXEC msdb.dbo.sp_attach_schedule @job_name = @job_name, @schedule_name = N'ONG_LOG_30min_Schedule';
EXEC msdb.dbo.sp_add_jobserver @job_name = @job_name;
GO

-- Job CLEANUP
USE msdb;
GO
DECLARE @job_name NVARCHAR(128) = N'ONG_Backup_Cleanup';
IF EXISTS (SELECT 1 FROM msdb.dbo.sysjobs WHERE name = @job_name)
  EXEC msdb.dbo.sp_delete_job @job_name = @job_name, @delete_unused_schedule=1;

EXEC msdb.dbo.sp_add_job @job_name = @job_name, @enabled = 1, @description = 'Eliminar backups > 14 dias', @owner_login_name = N'sa';

-- Comando de PowerShell limpia archivos viejos que hayan pasado los 14 d�as
DECLARE @ps NVARCHAR(MAX) = N'PowerShell -NoProfile -ExecutionPolicy Bypass -Command "Get-ChildItem -Path ''C:\Backups\ONG\'' -Include ''*.bak'',''*.trn'' -Recurse | Where-Object { $_.LastWriteTime -lt (Get-Date).AddDays(-14) } | Remove-Item -Force"';

EXEC msdb.dbo.sp_add_jobstep
  @job_name = @job_name,
  @step_name = N'Cleanup Old Backups',
  @subsystem = N'PowerShell',
  @command = @ps,
  @retry_attempts = 1,
  @retry_interval = 5;

-- Horario diario a las 03:30
EXEC msdb.dbo.sp_add_schedule @schedule_name = N'ONG_Cleanup_Diario', @freq_type = 4, @freq_interval = 1, @active_start_time = 33000;
EXEC msdb.dbo.sp_attach_schedule @job_name = @job_name, @schedule_name = N'ONG_Cleanup_Diario';
EXEC msdb.dbo.sp_add_jobserver @job_name = @job_name;
GO

-- "Comprobaci�n"
RESTORE VERIFYONLY FROM DISK = 'C:\Backups\ONG\ONG_Donaciones_FULL_20250725...bak';
RESTORE HEADERONLY FROM DISK = 'C:\Backups\ONG\ONG_Donaciones_FULL_20250725...bak';



-- VISTA OPTIMIZADA PARA POWER BI
CREATE VIEW ong.vw_ReporteGeneral AS
SELECT 
    d.DonacionID,
    do.Nombre AS Donante,
    p.NombreProyecto,
    b.Nombre AS Beneficiario,
    t.NombreTipo AS TipoDonacion,
    d.Monto,
    x.MontoAsignado,
    d.FechaDonacion
FROM ong.Donacion d
LEFT JOIN ong.DistribucionBeneficio x ON d.DonacionID = x.DonacionID
INNER JOIN ong.Donante do ON d.DonanteID = do.DonanteID
INNER JOIN ong.Proyecto p ON d.ProyectoID = p.ProyectoID
INNER JOIN ong.TipoDonacion t ON d.TipoDonacionID = t.TipoDonacionID
LEFT JOIN ong.Beneficiario b ON x.BeneficiarioID = b.BeneficiarioID;


SELECT 
    servicename, 
    service_account
FROM sys.dm_server_services;

BACKUP DATABASE ONG_Donaciones
TO DISK = 'C:\Backups\ONG\test_permiso.bak'
WITH INIT;

SELECT servicename, service_account
FROM sys.dm_server_services;
