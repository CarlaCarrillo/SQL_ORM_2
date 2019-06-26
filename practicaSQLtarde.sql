use zapatos2;
DROP TABLE IF EXISTS `zapatos`;

create database zapatos2;

use zapatos2;

CREATE TABLE zapatos2 (
zapato_id INT NOT NULL,
talla INT NOT NULL,
precio numeric NOT NULL,
descripción VARCHAR(100) NOT NULL,
altura VARCHAR(100) NOT NULL,
modelo VARCHAR(64) NOT NULL,
CONSTRAINT zapatos_PK primary key (zapato_id)
); 

CREATE TABLE colores (
    color_id INT NOT NULL AUTO_INCREMENT,
    nombre varchar(128) NOT NULL,
    CONSTRAINT colores_PK PRIMARY KEY (color_id)
);

CREATE TABLE materiales (
material_id int not null auto_increment,
nombre varchar(128) not null,
descripcion varchar(45) null,
CONSTRAINT materiales_PK PRIMARY KEY (material_id)
);

CREATE TABLE ventas (
ventas_id INT  NOT NULL  AUTO_INCREMENT,
fecha varchar(19) NOT NULL,
CONSTRAINT ventas_PK PRIMARY KEY (ventas_id)
);



ALTER TABLE zapatos2 ADD material_id INT NOT NULL;
ALTER TABLE zapatos2 ADD CONSTRAINT zapatos_FK_1 FOREIGN KEY (material_id) REFERENCES materiales(material_id);

ALTER TABLE ventas ADD zapato_id INT NOT NULL;
ALTER TABLE ventas ADD CONSTRAINT ventas_FK FOREIGN KEY (zapato_id) REFERENCES zapatos2(zapato_id);

ALTER TABLE ventas ADD empleado_id INT NOT NULL;
ALTER TABLE ventas ADD CONSTRAINT ventas_FK_1 FOREIGN KEY (empleado_id) REFERENCES empleados(empleado_id);
CREATE TABLE empleados (
    empleado_id INT NOT NULL AUTO_INCREMENT,
    nombre varchar(256) NOT NULL,
    CONSTRAINT empleados_PK PRIMARY KEY (empleado_id)
);

CREATE TABLE existencias (
    existencia_id INT NOT NULL AUTO_INCREMENT,
    fecha_entrada varchar(19) NOT NULL,
    fecha_salida varchar(19) NOT NULL,
    candidad INT NOT NULL,
    CONSTRAINT existencias_PK PRIMARY KEY (existencia_id)
);
ALTER TABLE existencias ADD zapato_id INT NOT NULL;
ALTER TABLE existencias ADD CONSTRAINT existencias_FK FOREIGN KEY (zapato_id) REFERENCES zapatos(zapato_id);

CREATE TABLE sucursales (
    sucursal_id INT NOT NULL AUTO_INCREMENT,
    nombre TEXT NOT NULL,
    CONSTRAINT sucursales_PK PRIMARY KEY (sucursal_id)
);

CREATE TABLE sucursales_existencias (
    sucursal_existencia_id INT NOT NULL AUTO_INCREMENT,
    sucursal_id INT NOT NULL,
    existencia_id INT NOT NULL,
    CONSTRAINT sucursales_existencias_PK PRIMARY KEY (sucursal_existencia_id),
    CONSTRAINT sucursales_existencias_FK FOREIGN KEY (sucursal_id) REFERENCES sucursales(sucursal_id),
    CONSTRAINT sucursales_existencias_FK_1 FOREIGN KEY (existencia_id) REFERENCES existencias(existencia_id)
)

/*Functions - Comparison- COALESCE*/
#Toma un numero de argumentos y regresa el primer no NULL.
SELECT 
    customerName, city, COALESCE(state, 'N/A'), country
FROM
    customers;

insert into empleados (nombre) values ("Carla");
select * from empleados;
update empleados set nombre = "Carla" where nombre="Ivonne";
