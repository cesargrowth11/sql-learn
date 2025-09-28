CREATE TABLE PRODUCTOS (
    PK_PRODUCTO INT IDENTITY(1,1) NOT NULL, -- Primary Key with auto-increment
    NOMBRE VARCHAR(100) NOT NULL, -- Name of the product
    PRECIO DECIMAL(10, 2) NOT NULL, -- Price of the product
    CANTIDAD INT NOT NULL, -- Quantity of the product
    CONSTRAINT PK_PRODUCTOS PRIMARY KEY (PK_PRODUCTO) -- Primary Key constraint
);

-- Lo que hace esta consulta es crear una tabla llamada "PRODUCTOS" con cuatro columnas: PK_PRODUCTO, NOMBRE, PRECIO y CANTIDAD. La columna PK_PRODUCTO es la clave primaria de la tabla y se auto-incrementa con cada nuevo registro. Las otras columnas almacenan el nombre, precio y cantidad del producto, respectivamente. Todas las columnas están definidas como NOT NULL, lo que significa que no pueden contener valores nulos.
CREATE TABLE INSTRUCTORS ( --- IGNORE ---
    instructor_id INT IDENTITY(1,1) NOT NULL, -- Primary Key with auto-increment
    first_name VARCHAR(50) NOT NULL, -- First name of the instructor
    last_name VARCHAR(50) NOT NULL, -- Last name of the instructor
    email VARCHAR(100) NOT NULL, -- Email address of the instructor
    phone VARCHAR(20), -- Phone number of the instructor
    salary DECIMAL(10,2), -- Salary of the instructor
    
    CONSTRAINT PK_INSTRUCTORS PRIMARY KEY (instructor_id)
);
-- Lo que hace esta consulta es crear una tabla llamada "INSTRUCTORS" con seis columnas: instructor_id, first_name, last_name, email, phone y salary. La columna instructor_id es la clave primaria de la tabla y se auto-incrementa con cada nuevo registro. Las columnas first_name, last_name y email están definidas como NOT NULL, lo que significa que no pueden contener valores nulos. Las columnas phone y salary son opcionales y pueden contener valores nulos.