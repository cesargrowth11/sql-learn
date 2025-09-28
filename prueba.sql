-- Consulta para buscar clientes con dólares que vencen en los últimos 6 meses
SELECT 
    c.id_cliente,
    c.nombre_cliente,
    c.apellido_cliente,
    c.email,
    c.telefono,
    d.monto_dolares,
    d.fecha_vencimiento,
    DATEDIFF(day, GETDATE(), d.fecha_vencimiento) AS dias_hasta_vencimiento
FROM clientes c
INNER JOIN dolares d ON c.id_cliente = d.id_cliente
WHERE d.fecha_vencimiento BETWEEN DATEADD(month, -6, GETDATE()) AND GETDATE()
    AND d.estado = 'ACTIVO'  -- Solo considerar dólares activos
ORDER BY d.fecha_vencimiento ASC, c.apellido_cliente;

-- Variante adicional: Clientes con dólares vencidos en los últimos 6 meses
-- SELECT 
--     c.id_cliente,
--     c.nombre_cliente,
--     c.apellido_cliente,
--     c.email,
--     d.monto_dolares,
--     d.fecha_vencimiento,
--     DATEDIFF(day, d.fecha_vencimiento, GETDATE()) AS dias_vencido
-- FROM clientes c
-- INNER JOIN dolares d ON c.id_cliente = d.id_cliente
-- WHERE d.fecha_vencimiento BETWEEN DATEADD(month, -6, GETDATE()) AND GETDATE()
--     AND d.fecha_vencimiento < GETDATE()
--     AND d.estado = 'VENCIDO'
-- ORDER BY d.fecha_vencimiento DESC, c.apellido_cliente;
-- Ahora construimos la consulta para buscar clientes con dólares que vencen en los últimos 3 meses

-- Consulta para buscar clientes con dólares que vencen en los últimos 3 meses
SELECT 
    c.id_cliente,
    c.nombre_cliente,
    c.apellido_cliente,
    c.email,
    c.telefono,
    d.monto_dolares,
    d.fecha_vencimiento,
    DATEDIFF(day, GETDATE(), d.fecha_vencimiento) AS dias_hasta_vencimiento
FROM clientes c
INNER JOIN dolares d ON c.id_cliente = d.id_cliente
WHERE d.fecha_vencimiento BETWEEN DATEADD(month, -3, GETDATE()) AND GETDATE()
    AND d.estado = 'ACTIVO'  -- Solo considerar dólares activos
ORDER BY d.fecha_vencimiento ASC, c.apellido_cliente;
-- Esta consulta lo que hace es buscar en la tabla "clientes" y "dolares" aquellos clientes que tienen dólares cuyo campo "fecha_vencimiento" está entre la fecha actual y 3 meses atrás. Además, solo se consideran los dólares que están en estado "ACTIVO". Los resultados se ordenan por la fecha de vencimiento y el apellido del cliente para facilitar la revisión.