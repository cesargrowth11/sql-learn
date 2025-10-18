CREATE TABLE PRODUCTOS (
    PK_PRODUCTO INT IDENTITY(1,1) NOT NULL,
        NOMBRE VARCHAR(100) NOT NULL,
        PRECIO DECIMAL(10, 2) NOT NULL CHECK (PRECIO >= 0),
        CANTIDAD INT NOT NULL CHECK (CANTIDAD >= 0),
        FECHA_CREACION DATETIME2 DEFAULT GETDATE(),
        FECHA_MODIFICACION DATETIME2 DEFAULT GETDATE(),
        ACTIVO BIT DEFAULT 1,
        CONSTRAINT PK_PRODUCTOS PRIMARY KEY (PK_PRODUCTO),
        CONSTRAINT UQ_PRODUCTOS_NOMBRE UNIQUE (NOMBRE)
    );

    -- Tabla robustecida con:
    -- - CHECK constraints para validar que precio y cantidad sean >= 0
    -- - FECHA_CREACION y FECHA_MODIFICACION para auditoría
    -- - ACTIVO para soft deletes
    -- - UNIQUE constraint en NOMBRE para evitar duplicados
