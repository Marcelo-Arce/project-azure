--Convertimos los datos correspondientes a INTEGER

alter table Categoria alter column Cod_Categoria integer NOT NULL;
alter table SubCategoria alter column Cod_SubCategoria integer NOT NULL;
alter table SubCategoria alter column Cod_Categoria integer NOT NULL;
alter table Producto alter column Cod_SubCategoria integer NOT NULL;
alter table Producto alter column Cod_Producto integer NOT NULL;
alter table Sucursales alter column Cod_Sucursal integer NOT NULL;
alter table VentasInternet alter column Cod_Producto integer NOT NULL;
alter table VentasInternet alter column Cantidad integer NOT NULL;
alter table VentasInternet alter column Cod_Territorio integer NOT NULL;

--Agregamos las Primary Key

alter table Categoria add primary key (Cod_Categoria);
alter table SubCategoria add primary key (Cod_SubCategoria);
alter table Sucursales add primary key (Cod_Sucursal);
alter table Producto add primary key (Cod_Producto);

--Agregamos las Foreign Key

alter table Producto add foreign key (Cod_SubCategoria) REFERENCES SubCategoria(Cod_SubCategoria);
alter table VentasInternet add foreign key (Cod_Producto) REFERENCES Producto(Cod_Producto);
alter table VentasInternet add foreign key (Cod_Territorio) REFERENCES Sucursales(Cod_Sucursal);
alter table SubCategoria add foreign key (Cod_Categoria) REFERENCES Categoria(Cod_Categoria);
alter table Stock add foreign key (Cod_Categoria) REFERENCES Categoria(Cod_Categoria);
alter table Stock add foreign key (Cod_SubCategoria) REFERENCES SubCategoria(Cod_SubCategoria);
alter table Stock add foreign key (Cod_Producto) REFERENCES Producto(Cod_Producto);
alter table Stock add foreign key (Cod_Sucursal) REFERENCES Sucursales(Cod_Sucursal);

--Limpiamos datos

DELETE FROM Sucursales WHERE Cod_Sucursal = 11;
SELECT * FROM Sucursales;

--Creamos la tabla Stock a partir de otras tablas

select P.Producto, P.Cod_Producto, P.Cod_SubCategoria, S.Cod_Sucursal
INTO Stock
from [dbo].[Producto] P, (SELECT * FROM Sucursales WHERE Cod_Sucursal<11) S

--Agrega la columna vacia del Cod_Categoria, SubCategoria y Categoria
ALTER TABLE dbo.stock
ADD Cod_Categoria varchar(2) NULL ;
ALTER TABLE Stock alter column Cod_Categoria integer NOT NULL;


ALTER TABLE dbo.stock
ADD SubCategoria varchar(50) NULL ;


ALTER TABLE dbo.stock
ADD Categoria varchar(50) NULL ;

ALTER TABLE dbo.SubCategoria
ADD Categoria varchar(50) NULL ;

--Llenamos las columna con los datos de otras tablas

UPDATE stock
SET Cod_Categoria = (SELECT Cod_Categoria  FROM SubCategoria WHERE SubCategoria.Cod_SubCategoria = stock.Cod_SubCategoria);

UPDATE stock
SET SubCategoria = (SELECT SubCategoria  FROM SubCategoria WHERE SubCategoria.Cod_SubCategoria = stock.Cod_SubCategoria);

UPDATE stock
SET Categoria = (SELECT Categoria  FROM Categoria WHERE Categoria.Cod_Categoria = stock.Cod_Categoria);

UPDATE SubCategoria
SET Categoria = (SELECT Categoria  FROM Categoria WHERE Categoria.Cod_Categoria = SubCategoria.Cod_Categoria);

--Agrega la columna vacia Cantidad
ALTER TABLE dbo.Stock
ADD Cantidad INT NULL;

--Llena la columna Cantidad con Números aleatorios hasta 100
UPDATE Stock Set Cantidad = ABS(CAST(NEWID() as binary(6)) % 100) + 1;

--convertimos la columna en entero not null
alter table Stock alter column Cantidad integer NOT NULL;


--Agregar la columna Cod_Sucursal a Ventas Internet
ALTER TABLE dbo.VentasInternet
ADD Cod_Sucursal varchar(50) NULL ;

UPDATE VentasInternet
SET Cod_Sucursal = (SELECT Cod_Sucursal FROM Stock WHERE Stock.Cod_Producto = VentasInternet.Cod_Producto);


--Ver Estado de tablas

SELECT * FROM Stock;

SELECT * FROM VentasInternet;

SELECT * FROM SubCategoria;








