
-- CREACION DE LA BASE DE DATOS
CREATE DATABASE retail_ventas;
use retail_ventas ;

-- CREACION DE TABLAS
CREATE TABLE productos(
id_producto INT PRIMARY KEY AUTO_INCREMENT,
producto VARCHAR(50),
proveedor VARCHAR(50),
costo DECIMAL(10,2)
);

CREATE TABLE ventas (
id_ventas INT PRIMARY KEY AUTO_INCREMENT,
id_producto INT,
cantidad INT,
precio DECIMAL(10,2),
fecha DATE,
FOREIGN KEY (id_producto) REFERENCES 
productos(id_producto)
);

-- INSERTAMOS DATOS
INSERT INTO productos (
producto,proveedor,costo) 
VALUES ('Casaca','Nike',80),
       ('Polo','Adidas',40),
       ('Zapatilllas','Puma',120),
       ('Gorra','Reebok',20);

INSERT INTO ventas(
id_producto,cantidad,precio,fecha)
VALUES (1,2,150,'2026-01-01'),
       (2,3,70,'2026-01-02'),
       (3,1,200,'2026-01-02'),
       (1,1,150,'2026-01-03'),
       (4,5,35,'2026-01-04');
       
--  CONSULTAS CLAVE 
-- ingresos totales --
SELECT SUM(cantidad *precio) AS 
ingresos
FROM ventas ;

-- ingresos por producto
SELECT p.producto,SUM(v.cantidad*v.precio) AS 
ingresosxproducto 
FROM ventas v
INNER JOIN productos p
ON p.id_producto = v.id_producto
group by p.producto;

-- ganacia por producto
select p.producto,SUM(v.cantidad*(v.precio-p.costo)) AS ganaciaxproducto
FROM ventas v
INNER JOIN productos p
ON p.id_producto = v.id_producto
group by p.producto;
-- producto mas vendido(por cantidad)
select p.producto,SUM(v.cantidad) AS cantidadxproducto
FROM ventas v
INNER JOIN productos p
ON p.id_producto = v.id_producto
group by p.producto
order by  cantidadxproducto DESC
LIMIT 1;
-- producto con mayor ganacia 
select p.producto,SUM(v.cantidad*(v.precio-p.costo)) AS gananciaxproducto
FROM ventas v
INNER JOIN productos p
ON p.id_producto = v.id_producto
group by p.producto
order by  gananciaxproducto DESC
LIMIT 1;

-- CREAR VISTA PROFESIONAL RESUMEN (total_ingresos,cantidad_total,ganacia)

CREATE VIEW vista_resumen_ventas AS
select p.producto, SUM(v.cantidad) AS cantidad_total,
SUM(v.cantidad*v.precio) AS ingresos_total,
SUM(v.cantidad*(v.precio-p.costo)) AS ganancia_total
FROM ventas v
INNER JOIN productos p
ON p.id_producto = v.id_producto
group by p.producto;

SELECT * FROM vista_resumen_ventas;


DELIMITER //
CREATE PROCEDURE productos_por_proveedor(IN proveedorx VARCHAR(50))
BEGIN
  SELECT producto,proveedor
  FROM productos
  WHERE proveedor = proveedorx;
END //
DELIMITER ;

CALL productos_por_proveedor('Proveedor A')
-- PROCEDIMIENTO CON PARAMETRO
-- cantidad de ventas por producto-----
DELIMITER //
CREATE PROCEDURE ventas_por_producto(IN productox VARCHAR(50))
BEGIN
SELECT p.producto,SUM(v.cantidad) AS cantidad_vendida
FROM ventas v
INNER JOIN productos p
ON v.id_producto =p.id_producto
WHERE p.producto = productox
group BY p.producto ;
END //
DELIMITER ;

CALL ventas_por_producto('Casaca');

