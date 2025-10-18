-- Reportes de clientes y dólares (SQL Server)
-- Consultas optimizadas y parametrizables para periodos de meses.

/*
Uso recomendado: ajustar @MonthsBack según el periodo deseado.
La consulta es SARGable (usa rangos directos) y aprovecha índices filtrados 
si existen (ver migrations/001_schema_improvements.sql).
*/

DECLARE @MonthsBack int = 6;
DECLARE @StartDate date = DATEADD(month, -@MonthsBack, CAST(GETDATE() AS date));
DECLARE @EndDate   date = CAST(GETDATE() AS date);

-- Clientes con dólares ACTIVO que vencieron en los últimos @MonthsBack meses
SELECT 
    c.id_cliente,
    c.nombre_cliente,
    c.apellido_cliente,
    c.email,
    c.telefono,
    d.monto_dolares,
    d.fecha_vencimiento,
    DATEDIFF(day, GETDATE(), d.fecha_vencimiento) AS dias_hasta_vencimiento
FROM dbo.clientes AS c
JOIN dbo.dolares  AS d
  ON d.id_cliente = c.id_cliente
WHERE d.estado = 'ACTIVO'
  AND d.fecha_vencimiento >= @StartDate
  AND d.fecha_vencimiento < DATEADD(day, 1, @EndDate) -- fin de día actual
ORDER BY d.fecha_vencimiento ASC, c.apellido_cliente;

-- Variante: dólares VENCIDO en los últimos @MonthsBack meses
-- Muestra cuánto tiempo llevan vencidos
/*
SELECT 
    c.id_cliente,
    c.nombre_cliente,
    c.apellido_cliente,
    c.email,
    d.monto_dolares,
    d.fecha_vencimiento,
    DATEDIFF(day, d.fecha_vencimiento, GETDATE()) AS dias_vencido
FROM dbo.clientes AS c
JOIN dbo.dolares  AS d
  ON d.id_cliente = c.id_cliente
WHERE d.estado = 'VENCIDO'
  AND d.fecha_vencimiento >= @StartDate
  AND d.fecha_vencimiento < DATEADD(day, 1, @EndDate)
ORDER BY d.fecha_vencimiento DESC, c.apellido_cliente;
*/

-- Sugerencia opcional: materializar como vista para reporting estable
/*
CREATE OR ALTER VIEW dbo.vw_dolares_activos_vencidos_ultimos_meses
AS
    SELECT 
        c.id_cliente,
        c.nombre_cliente,
        c.apellido_cliente,
        c.email,
        c.telefono,
        d.monto_dolares,
        d.fecha_vencimiento,
        d.estado,
        CASE WHEN d.estado = 'ACTIVO' 
             THEN DATEDIFF(day, GETDATE(), d.fecha_vencimiento)
             ELSE DATEDIFF(day, d.fecha_vencimiento, GETDATE())
        END AS dias_relativos
    FROM dbo.clientes AS c
    JOIN dbo.dolares  AS d
      ON d.id_cliente = c.id_cliente;
-- Luego filtrar por rango/estado al consultar la vista.
*/

