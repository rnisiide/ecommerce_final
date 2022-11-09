-- criação do banco de dados para o cenário de e-commerce

create database ecommerce;
use ecommerce;

-- criar tabela cliente

create table clients(
	idClient int auto_increment primary key,
    Fname varchar(15),
    Minit char (3),
    Lname varchar(20),
    CPF char(11) not null,
    Address varchar(45),
    constraint unique_client_CPF unique (CPF)
);


alter table clients auto_increment = 1;
alter table clients drop column Address; 
ALTER TABLE clients ADD Address varchar(255);


-- criar tabela produto
-- size = dimensão do produto
create table products(
	idProduct int auto_increment primary key,
    Pname varchar(15),
    classification_kids bool default false,
    category enum('Eletrônico', 'Vestuário', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    Valor float,
    Avaliação float default 0,
    Size varchar(20)
);

alter table products auto_increment = 1;
alter table products drop column Pname; 
ALTER TABLE products ADD Pname varchar(45);



-- para ser continuado no desafio: termine de implementar a tabela e crie a conexão com as tabelas necessárias
-- além disso, reflita essa modificação no diagrama de esquema relacional
create table payments(
	idClient int,
    idPayment int,
    paymentType enum('Boleto', 'Pix', 'Cartão de crédito'),
    limitAvailable float,
    primary key (idClient, idPayment)

);


-- criar tabela pedido
-- payment cash booleano para pagamentos pix/boleto, possivelmente criar desconto para esse tipo de pagamento
create table orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    order_Status enum('Em andamento', 'Em processamento', 'Enviado', 'Entregue', 'Cancelado') not null default 'Em processamento',
    order_Description varchar(255),
    shipping float default 10,
    paymentCash bool default false,
    constraint fk_client_order foreign key (idOrderClient) references clients(idClient)

);

alter table orders auto_increment = 1;

-- tabela estoque
create table products_storage (
	idProdStorage int auto_increment primary key,
    storage_location varchar(255)
);

alter table products_storage auto_increment = 1;

-- tabela fornecedor
create table supplier (
	idSupplier int auto_increment primary key,
    Razão_social varchar(45) not null, 
    CNPJ char(14) not null,
    contact varchar(11) default 0,
    constraint unique_supplier unique (CNPJ)
);

alter table supplier auto_increment = 1;

-- tabela vendedor
create table seller (
	idSeller int auto_increment primary key,
    Social_name varchar(45) not null, 
    Nome_Fantasia varchar(45),
    CNPJ char(14), 
    CPF char(9),
    contact varchar(11) default 0,
    Location varchar(255),
    constraint unique_seller_CNPJ unique (CNPJ),
    constraint unique_seller_CPF unique (CPF)
);

alter table seller auto_increment = 1;

create table productSeller (
	idPseller int,
    idPProduct int,
    prodQuantity int not null default 1,
    primary key (idPseller, idPProduct), 
    constraint fk_product_seller foreign key (idPseller) references seller(idSeller),
    constraint fk_product_product foreign key (idPProduct) references products(idProduct)
);

create table productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int default 1,
    poStatus enum ('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder), 
	constraint fk_porder_product foreign key (idPOproduct) references products(idProduct),
	constraint fk_order_order foreign key (idPOorder) references orders(idOrder)
);

create table storageLocation (
	idLproduct int,
    idLstorage int,
    quantity int,
    primary key (idLproduct, idLstorage), 
	constraint fk_location_product foreign key (idLproduct) references products(idProduct),
	constraint fk_location_storage foreign key (idLstorage) references products_storage (idProdStorage)
);

create table productSupplier (
	idPsPsupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsPsupplier, idPsProduct),
	constraint fk_product_supplier_supplier foreign key (idPsPsupplier) references supplier(idSupplier),
	constraint fk_product_supplier_product foreign key (idPsProduct) references products(idProduct)
);

use information_schema;
desc REFERENTIAL_CONSTRAINTS;
select * from REFERENTIAL_CONSTRAINTS where CONSTRAINT_SCHEMA = 'ecommerce';


insert into clients(Fname, Minit, Lname, CPF, Address) 
	values 	('Maria','M','Silva', '12345678911', 'R. Silva de Prata 29, Carangola - Toledo'),
			('Ricardo','A','Nisiide', '05465919799', 'Av das Cataratas, 1010, Vila Yolanda - Foz do Iguaçu'),
			('Anderson','D','Longen','07587465907','Av Iguaçu 1012, Vila Yolanda - Foz do Iguaçu'),
            ('Karin','G','Nishide','07984125690','Av Brasil 1020, Centro - Curitiba'),
            ('João','F','da Silva', '32548910571','Rua do Centro, 985, Centro - São Paulo'),
            ('Chibi','e','Jager','65919347890','Av das Cataratas, 639, Vila Yolanda - Foz do Iguaçu');
            
insert into products (Pname, classification_kids, category, Valor, Avaliação, Size) values 
						('Fone de ouvido', false, 'Eletrônico', 70.51, 4, null),
                        ('Mesa de madeira', false, 'Móveis', 670.00, 5, '10 x 5 x 60'),
                        ('Barbie', true, 'Brinquedos', 145.49, 5, null),
                        ('Calça jeans', true, 'Vestuário', 91.99, 3, null),
                        ('Farinha de arroz', false, 'Alimentos', 52.50, 2,null),
                        ('Fire stick Amazon', false, 'Eletrônico', 400.90, 4, null),
                        ('Sofá retrátil', false, 'Móveis', 5463.50, 3, '3x57x80');
                        

insert into orders (idOrderClient, order_Status, order_Description, shipping, paymentCash) values
				(7, 'Em processamento', 'Compra via aplicativo', 15, 0),
                (8, 'Enviado', 'Compra via site', 0, 1),
                (9, 'Entregue', null, null, 1),
                (10, 'Cancelado', 'Compra via website', 150, 0);

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus) values 
							(29, 14, 6, 'Disponível'),
                            (32, 16, 0, 'Sem estoque'),
                            (35, 15, 0, 'Sem estoque'),
                            (34, 13, 20, 'Disponível');

insert into products_storage (storage_location) values
				('Rio de Janeiro'),
                ('São Paulo'),
                ('Curitiba');

insert into storageLocation	(idLproduct, idLstorage, quantity) values
							(29, 1, 1000),
                            (30, 3, 2500),
                            (35, 2, 10000),
                            (32, 1, 15355),
                            (31, 2, 2);

insert into supplier (Razão_social, CNPJ, contact) values
						('Almeida e filhos', '01120011000100', '4531391119'),
                        ('Bazar Segal', '91124658000112', '11999553214'),
                        ('Eletrônicos da vila', '21321966000132', '4132569871'),
                        ('Pireiros Vestimentas', '65987123000132', null);
   
insert into productseller (idPseller, idPProduct, prodQuantity) values 
						(7, 29, 1000),
                        (8, 35, 6222),
                        (9, 30, 100),
                        (8, 33, 235),
                        (7, 34, 9846);
                        
insert into productsupplier (idPsPsupplier, idPsProduct, quantity) values 
								(1, 33, 3200),
                                (2, 35, 100),
                                (3, 29, 135),
                                (4, 30, 9500),
                                (1, 31, 132),
                                (2, 32, 369),
                                (3, 30, 1354),
                                (4, 34, 100);
                        

insert into seller (Social_name, Nome_Fantasia, CNPJ, CPF, contact, Location) values 
						('Bazar Setti LTDA', 'Bazar secos e molhados', '23123456000123', null, '4532693269', 'Av. Brasil 19 - Foz do Iguaçu'),
                        ('João Silva Almeida', 'Lojinha do João', null, '049659193', '45999896523', 'Home office'),
                        ('Confecções Silva', 'Roupinhas mimosas', '23694326000132', null, '41945649813', 'R. das Ruas, 26 - Curitiba');


show tables;
select * from clients;
select * from products;
select * from orders;
select * from products_storage;
select * from supplier;
select * from storageLocation;
select * from productorder;
select * from seller;
select * from productseller;
select * from productsupplier;

select * from clients c, orders o where c.idClient = idOrderClient;

select concat(Fname, ' ', Lname) as Cliente, idOrder as Pedido, order_Status as 'Status' 
	from clients c, orders o 
    where c.idClient = idOrderClient;


-- duas formas de fazer o mesmo filtro
select Pname as Produto, storage_location as 'Local', quantity as Quantidade 
	from products p, products_storage s, storageLocation l 
    where idProduct = idLproduct and idProdStorage = idLstorage;
    
select Pname as Produto, storage_location as 'Local', quantity as Quantidade
	from products 
    INNER JOIN storageLocation on idProduct = idLproduct
    INNER JOIN products_storage on idProdStorage = idLstorage;
    
-- fazendo múltiplos filtros
select concat(Fname, ' ', Lname) as 'Nome completo', Pname as 'Produto comprado', Valor from clients 
	INNER JOIN orders o on idClient = idOrderClient
    INNER JOIN productorder p on idPOorder = idOrder
    INNER JOIN products ON idPOproduct = idProduct;
    
