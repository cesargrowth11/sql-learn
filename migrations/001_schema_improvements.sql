-- Schema improvements and indexes for SQL Server
-- Safe-guards with IF EXISTS/IF NOT EXISTS to avoid errors.

-- PRODUCTOS: non-negative checks and unique product name
IF OBJECT_ID('dbo.PRODUCTOS', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM sys.check_constraints 
        WHERE name = 'CK_PRODUCTOS_PRECIO_NONNEG' AND parent_object_id = OBJECT_ID('dbo.PRODUCTOS')
    )
    ALTER TABLE dbo.PRODUCTOS
    ADD CONSTRAINT CK_PRODUCTOS_PRECIO_NONNEG CHECK (PRECIO >= 0);

    IF NOT EXISTS (
        SELECT 1 FROM sys.check_constraints 
        WHERE name = 'CK_PRODUCTOS_CANTIDAD_NONNEG' AND parent_object_id = OBJECT_ID('dbo.PRODUCTOS')
    )
    ALTER TABLE dbo.PRODUCTOS
    ADD CONSTRAINT CK_PRODUCTOS_CANTIDAD_NONNEG CHECK (CANTIDAD >= 0);

    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE object_id = OBJECT_ID('dbo.PRODUCTOS') AND name = 'UX_PRODUCTOS_NOMBRE'
    )
    CREATE UNIQUE INDEX UX_PRODUCTOS_NOMBRE ON dbo.PRODUCTOS (NOMBRE);
END
GO

-- INSTRUCTORS: unique email, non-negative salary, name index
IF OBJECT_ID('dbo.INSTRUCTORS', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE object_id = OBJECT_ID('dbo.INSTRUCTORS') AND name = 'UQ_INSTRUCTORS_EMAIL'
    )
    CREATE UNIQUE INDEX UQ_INSTRUCTORS_EMAIL ON dbo.INSTRUCTORS (email);

    IF NOT EXISTS (
        SELECT 1 FROM sys.check_constraints 
        WHERE name = 'CK_INSTRUCTORS_SALARY_NONNEG' AND parent_object_id = OBJECT_ID('dbo.INSTRUCTORS')
    )
    ALTER TABLE dbo.INSTRUCTORS
    ADD CONSTRAINT CK_INSTRUCTORS_SALARY_NONNEG CHECK (salary IS NULL OR salary >= 0);

    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE object_id = OBJECT_ID('dbo.INSTRUCTORS') AND name = 'IX_INSTRUCTORS_LASTNAME_FIRSTNAME'
    )
    CREATE INDEX IX_INSTRUCTORS_LASTNAME_FIRSTNAME ON dbo.INSTRUCTORS (last_name, first_name);
END
GO

-- CLIENTES / DOLARES: FK, filtered indexes, and join helpers
IF OBJECT_ID('dbo.clientes', 'U') IS NOT NULL
   AND OBJECT_ID('dbo.dolares', 'U') IS NOT NULL
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys 
        WHERE name = 'FK_dolares_clientes' AND parent_object_id = OBJECT_ID('dbo.dolares')
    )
    ALTER TABLE dbo.dolares WITH CHECK
    ADD CONSTRAINT FK_dolares_clientes FOREIGN KEY (id_cliente)
        REFERENCES dbo.clientes (id_cliente);

    -- Filtered index to speed up ACTIVO by expiration date queries
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE object_id = OBJECT_ID('dbo.dolares') AND name = 'IX_dolares_activos_vencimiento'
    )
    CREATE INDEX IX_dolares_activos_vencimiento 
        ON dbo.dolares (fecha_vencimiento)
        INCLUDE (id_cliente, monto_dolares)
        WHERE estado = 'ACTIVO';

    -- Filtered index to speed up VENCIDO by expiration date queries
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE object_id = OBJECT_ID('dbo.dolares') AND name = 'IX_dolares_vencidos_vencimiento'
    )
    CREATE INDEX IX_dolares_vencidos_vencimiento 
        ON dbo.dolares (fecha_vencimiento)
        INCLUDE (id_cliente, monto_dolares)
        WHERE estado = 'VENCIDO';

    -- Helpful for the JOIN on id_cliente
    IF NOT EXISTS (
        SELECT 1 FROM sys.indexes 
        WHERE object_id = OBJECT_ID('dbo.dolares') AND name = 'IX_dolares_id_cliente'
    )
    CREATE INDEX IX_dolares_id_cliente ON dbo.dolares (id_cliente);
END
GO

-- Optional suggestion (commented): enforce unique emails on clientes if business allows it.
-- Uncomment if there are no duplicate emails in data.
-- IF OBJECT_ID('dbo.clientes', 'U') IS NOT NULL AND COL_LENGTH('dbo.clientes','email') IS NOT NULL
-- BEGIN
--     IF NOT EXISTS (
--         SELECT 1 FROM sys.indexes 
--         WHERE object_id = OBJECT_ID('dbo.clientes') AND name = 'UX_clientes_email'
--     )
--     CREATE UNIQUE INDEX UX_clientes_email ON dbo.clientes (email);
-- END
-- GO

