DROP TABLE IF EXISTS sale;
DROP TABLE IF EXISTS stock;
DROP TABLE IF EXISTS profit;
DROP TABLE IF EXISTS expense;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS product_color;
DROP TABLE IF EXISTS color;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS delivery;


CREATE TABLE invoice(
invoice_id varchar(4) NOT NULL,
invoice_type int NOT NULL,
total_amount numeric NOT NULL,
invoice_date timestamp without time zone NOT NULL,
PRIMARY KEY(invoice_id));

CREATE TABLE product(
product_id varchar(4) NOT NULL,
--color_id varchar(4) NOT NULL,
product_name varchar(100) NOT NULL,
unit_price int NOT NULL,
--quantity int NOT NULL,
--PRIMARY KEY (product_id,color_id),
PRIMARY KEY (product_id)
--constraint fk_color_id foreign key(color_id) references color(color_id)
);

CREATE TABLE color(
color_id varchar(4) NOT NULL,
color_name varchar(100) NOT NULL,
PRIMARY KEY (color_id)
);

create table product_color(
product_id varchar(4) NOT NULL,
color_id varchar(4) NOT NULL,
quantity int NOT NULL,
PRIMARY KEY (product_id,color_id),
constraint fk_product_id foreign key(product_id) references product(product_id),
constraint fk_color_id foreign key(color_id) references color(color_id)
);

CREATE TABLE delivery(
delivery_id varchar(4) NOT NULL,
delivery_name varchar(100) NOT NULL,
delivery_add varchar(200) NOT NULL,
first_purchase_date timestamp without time zone NOT NULL,
last_purchase_date timestamp without time zone,
PRIMARY KEY (delivery_id)
);

CREATE TABLE customer(
customer_id varchar(4) NOT NULL,
customer_phone varchar(100) NOT NULL,
customer_name varchar(100) NOT NULL,
customer_type int NOT NULL,
customer_add varchar(200),
first_purchase_date timestamp without time zone NOT NULL,
last_purchase_date timestamp without time zone,
PRIMARY KEY(customer_id));

CREATE TABLE supplier(
supplier_id varchar(4) NOT NULL,
supplier_name varchar(100) NOT NULL,
supplier_contact varchar(100) NOT NULL,
supplier_bank_acc varchar(50),
PRIMARY KEY (supplier_id)
);


CREATE TABLE sale(
sale_id varchar(4) NOT NULL,
invoice_id varchar(4) NOT NULL,
product_id varchar(4) NOT  NULL,
color_id varchar(4) NOT NULL,
delivery_id varchar(4) NOT NULL,
customer_id varchar(4)  NOT NULL,
sale_type int NOT NULL,
quantity int NOT NULL,
sale_amount numeric NOT NULL,
discount int,
commission int,
grand_sale int,
PRIMARY KEY(sale_id, invoice_id),
constraint fk_invoice_id foreign key(invoice_id) references invoice(invoice_id),
constraint fk_product_id foreign key(product_id) references product(product_id),
constraint fk_color_id foreign key(color_id) references color(color_id),
constraint fk_delivery_id foreign key(delivery_id) references delivery(delivery_id),
constraint fk_customer_id foreign key(customer_id) references customer(customer_id)
);

CREATE TABLE stock(
stock_purchase_id varchar(20) NOT NULL,
invoice_id varchar(4)  NOT NULL,
product_id varchar(4) NOT NULL,
color_id varchar(4) NOT NULL,
supplier_id varchar(4) NOT NULL,
delivery_id varchar(4) NOT NULL,
quantity int NOT NULL,
purchase_amount numeric NOT NULL,
remark varchar(500),
PRIMARY KEY(stock_purchase_id, invoice_id),
constraint fk_invoice_id foreign key(invoice_id) references invoice(invoice_id),
constraint fk_product_id foreign key(product_id) references product(product_id),
constraint fk_color_id foreign key(color_id) references color(color_id),
constraint fk_supplier_id foreign key(supplier_id) references supplier(supplier_id),
constraint fk_delivery_id foreign key(delivery_id) references delivery(delivery_id)
);

CREATE TABLE profit(
profit_id varchar(4) NOT NULL,
product_id varchar(4) NOT NULL,
color_id varchar(4) NOT NULL,
profit_amount numeric NOT NULL,
profit_date timestamp without time zone NOT NULL,
sale_qty varchar(4) NOT NULL,
instock_amount numeric NOT NULL,
order_amount numeric NOT NULL,
PRIMARY KEY (profit_id,product_id,color_id,profit_date),
constraint fk_product_id foreign key(product_id) references product(product_id),
constraint fk_color_id foreign key(color_id) references color(color_id)
);

CREATE TABLE expense(
expense_id varchar(4) NOT NULL,
expense_type int NOT NULL,
expense_amount numeric NOT NULL,
expense_date timestamp without time zone NOT NULL,
remark varchar(500),
PRIMARY KEY (expense_id)
);




