create database logisticChain;


create table customer(
id serial primary key,
first_name varchar(20),
last_name varchar(20),
city varchar(20),
country varchar(20),
phone varchar(20)
)

CREATE SEQUENCE order_id_seq start 101;
CREATE SEQUENCE order_number_seq start 00001;

create table ordertb(
id integer not null default nextval('order_id_seq') primary key,
order_Date date,
order_number integer not null default nextval('order_number_seq'),
customer_id integer,
total_amount integer,
constraint fk_order
foreign key(customer_id)
references customer(id)
);


ALTER SEQUENCE order_id_seq
OWNED BY ordertb.id;

ALTER SEQUENCE order_number_seq
OWNED BY ordertb.order_number;


create table orderitem(
id serial primary key,
order_id integer,
product_id integer,
unit_price integer,
quantity integer,
constraint fk_orderitem
foreign key(order_id)
references ordertb(id)
);

create table expense(
id serial primary key,
expense_type integer,
expense_amount integer,
expense_date date
);

insert into expense(expense_type,expense_amount,expense_date)
values(01,2000,'12/3/2020'),
(02,1000,'12/3/2020'),
(03,500,'12/3/2020');


insert into customer(first_name,last_name,city,country,phone)
values('Zaw','Moe','Yangon','Myanmar','099');
insert into customer(first_name,last_name,city,country,phone)
values('Win','Naing','Mudone','Germany','044'),
('Aung','Aung','Tahtone','Spain','055'),
('Hla','Tun','Mawlamyine','Italy','066'),
('Kyaw','Min','Pyay','Italy','077'),
('Inza','Khein Thein','Tokyo','Japan','088');
insert into customer(first_name,last_name,city,country,phone)
values('Maknun','Babushka','Snizth','Belarus','099');

insert into ordertb(order_Date,customer_id,total_amount)
values('12/3/2020',1,15000);
insert into ordertb(order_Date,customer_id,total_amount)
values('12-3-2020',1,15000);
insert into ordertb(order_Date,customer_id,total_amount)
values('12/3/2020',1,200000),
('12/3/2020',2,3000),
('12/7/2020',3,40000),
('12/10/2020',4,70000),
('12/11/2020',4,80000),
('12/12/2020',5,20000),
('12/20/2020',5,80000),
('12/22/2020',5,120000),
('12/24/2020',3,140000),
('12/26/2020',3,1770000),
('12/28/2020',2,270000);

insert into orderitem(order_id,product_id,unit_price,quantity)
values(101,13,200,10);
insert into orderitem(order_id,product_id,unit_price,quantity)
values(101,13,200,10),
(101,13,200,10),
(102,12,200,10),
(103,13,200,10),
(104,11,200,10),
(105,10,200,10),
(106,13,200,10),
(107,13,200,10),
(108,13,200,10),
(109,13,200,10),
(110,12,200,10),
(111,13,200,10),
(112,13,200,10),
(113,13,200,10),
(101,12,200,10),
(102,13,200,10),
(103,11,200,10),
(104,10,200,10),
(105,10,200,10),
(106,09,200,10),
(107,08,200,10),
(108,13,200,10),
(109,07,200,10),
(110,13,200,10),
(111,13,200,10),
(112,06,200,10),
(113,13,200,10);

SELECT DISTINCT (C.Id), first_name, last_name, COUNT(O.Id) AS Orders
  FROM ordertb O  
  JOIN orderitem I ON O.id = I.order_id AND I.product_id = 13
 RIGHT JOIN Customer C ON C.id = O.customer_id
 GROUP BY C.Id, first_name, last_name
 ORDER BY COUNT(O.id)
 
 select count(order_id) from orderitem where product_id = 13
 
 SELECT DISTINCT COUNT(O.Id) AS Orders
  FROM ordertb O  
  JOIN orderitem I ON O.id = I.order_id AND I.product_id = 13
  
  select c.id,c.first_name,c.last_name,count(o.id) as Orders
  from customer as c
 left join ordertb as o
  on c.id=o.customer_id
join orderitem as ot
  on o.id=ot.order_id
  where ot.product_id=13
  GROUP BY c.id, first_name, last_name
ORDER BY COUNT(o.id)

SELECT DISTINCT (C.Id), first_name, last_name, COUNT(O.Id) AS Orders
  FROM ordertb O  
  JOIN orderitem I ON O.id = I.order_id AND I.product_id = 13
 right JOIN Customer C ON C.id = O.customer_id
 GROUP BY C.Id, first_name, last_name
 ORDER BY COUNT(O.id)
 
 
 create table supplier(
 id serial primary key,
 company_name varchar(20),
 contact_name varchar(20),
 city varchar(20),
 country varchar(20),
 phone varchar(20),
 fax varchar(20)
 );
 
 insert into supplier(company_name,contact_name,city,country,phone,fax)
 values('CDC','JohnSmith','New Orleans','Myanmar','030-0888-9012','030-0888-9012'),
 ('Zego Bird','JohnSmith','New Orleans','Germany','030-0888-9012','030-0888-9012'),
 ('GoodMart','JohnSmith','New Orleans','Italy','030-0888-9012','030-0888-9012'),
 ('GrabFood','JohnSmith','New Orleans','Spain','030-0888-9012','030-0888-9012'),
 ('Klugen','JohnSmith','New Orleans','Spain','030-0888-9012','030-0888-9012'),
 ('”ª•S‰®‚³‚ñ','JohnSmith','New Orleans','Japan','030-0888-9012','030-0888-9012'),
 ('Phaphadous','JohnSmith','New Orleans','Germany','030-0888-9012','030-0888-9012'),
 ('Himlark','JohnSmith','New Orleans','Myanmar','030-0888-9012','030-0888-9012');
 insert into supplier(company_name,contact_name,city,country,phone,fax)
 values('KGB','Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
  insert into supplier(company_name,contact_name,city,country,phone,fax)
 values((select first_name from customer where city='Tokyo')
 ,'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
 
  
 
 select c.first_name,c.last_name,c.country as CusCountry,s.country as SupCountry,s.company_name
 from customer c 
 join supplier s
 on c.country=s.country
 order by s.country,c.country
 
 select phone from supplier where contact_name='JohnSmith'
 
 
 select sum(quantity) from orderitem where product_id=13
 
 
 select count(product_id)-6 from orderitem where product_id=13;-12
 
 select sum(quantity*unit_price) as net_profit from orderitem
 right join ordertb on orderitem.order_id=ordertb.id
  where order_date='12/3/2020'
  
  
  select (select sum(quantity*unit_price) as net_profit from orderitem
 right join ordertb on orderitem.order_id=ordertb.id
  where order_date='12/3/2020' and expense_date='12/3/2020')-sum(expense_amount)from expense
  where expense_date='12/3/2020'
group by expense_date

 select (
 select sum(quantity*unit_price) from orderitem
 right join ordertb-->sa on orderitem.order_id=ordertb.id
  where order_date='12/3/2020'
  )-sum(expense_amount) as net_profit from expense
  where expense_date='12/3/2020'
--group by expense_date

select sum(expense_amount)from expense where expense_date='12/3/2020'

------------
-----------
---complex query
with tcl as (
select coalesce(first_name) from customer where city='moscow'
)
insert into supplier(company_name,contact_name,city,country,phone,fax)
values((select * from tcl)
 ,'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
 
DO $$ 
    BEGIN
         IF EXISTS
        (
            SELECT first_name
            FROM customer
            WHERE city = 'moscow'
        )

        THEN
            insert into supplier(company_name,contact_name,city,country,phone,fax)
            values((SELECT first_name
            FROM customer
            WHERE city = 'moscow')),'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
        END IF;
    END
$$;


DO $$ 
    BEGIN
         IF EXISTS--check if product instock
        (
            SELECT first_name
            FROM customer
            WHERE city = 'gokhan'
			--comment
        )

        THEN--if product instock
            IF EXISTS
            (   
                --select  if invoice exist
                SELECT
                FROM ordertb
                WHERE id = '114'
    			--comment
            )
            THEN--if invoice exist
                --no new invoice
                --insert into sales
                --update stock
                insert into supplier(company_name,contact_name,city,country,phone,fax)
                values((SELECT first_name FROM customer
                WHERE city = 'Yangon'),'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
                update customer set first_name='Pout'||'Si' where city='Yangon';
            ELSE--if invoice not exist
                --no new invoice
                --insert into sales
                --update stock
                insert into ordertb(order_Date,customer_id,total_amount)
                values('12/3/2020',1,15000);
                insert into supplier(company_name,contact_name,city,country,phone,fax)
                values((SELECT first_name FROM customer
                WHERE city = 'Yangon'),'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
                update customer set first_name='KyarrNyi'||'maung' where city='Yangon';
            END IF;
        END IF;
    END
$$;


DO $$ 
    BEGIN
         IF EXISTS--check if product instock
        (
            SELECT first_name
            FROM customer
            WHERE city = 'Yangon'
			--comment
        )

        THEN--if product instock
            IF EXISTS
            (   
                --select  if invoice exist
                SELECT
                FROM ordertb
                WHERE id = '115'
    			--comment
            )
            THEN--if invoice exist
                --no new invoice
                --insert into sales
                --update stock
                insert into supplier(company_name,contact_name,city,country,phone,fax)
                values((SELECT first_name FROM customer
                WHERE city = 'Yangon'),'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
                update customer set first_name='Pout'||'Si' where city='Yangon';
            ELSE--if invoice not exist
                --no new invoice
                --insert into sales
                --update stock
                insert into ordertb(order_Date,customer_id,total_amount)
                values('12/3/2020',1,15000);
                insert into supplier(company_name,contact_name,city,country,phone,fax)
                values((SELECT first_name FROM customer
                WHERE city = 'Yangon'),'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
                update customer set first_name='KyarrNyi'||'maung' where city='Yangon';
            END IF;
        END IF;
    END
$$;


insert into supplier(company_name,contact_name,city,country,phone,fax)
values('GG'
 ,'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012')
 WHERE 
    EXISTS( select first_name from customer where city='moscow');
 
 
  insert into supplier(company_name,contact_name,city,country,phone,fax)
 values((select first_name from customer where city='moscow')
 ,'Oblak','Moscow','Russia','030-0888-9012','030-0888-9012');
 
 --select for check query
 select id,product_name,quantity as instock_quantity from product where id in (1,3);
 
 --update quantity
 update product set quantity=(select quantity from product where id=1)-1 
 where id=1;
 
 --update quantity with equal quantity ordered
update product set quantity=(
select quantity from product where id in (1,3) and price in (100,150))-1
where id in (1,3);
  -->>>>>>-update quantity with equal quantity ordered
 update product set quantity= (quantity-1) 
 where id in (1,3,4) and price in (100,150);
 -->>>wrong with max function -->aggregate functions are not allowed in UPDATE
 update product set max(quantity)-2 
 where id in (3,4);
 
 CREATE PROCEDURE SelectAllCustomers @City varchar(20)
AS
(SELECT * FROM "Customer" WHERE City = @City)
GO;

EXEC SelectAllCustomers @City = 'London';
 

select check for existence of product, customer
(if exist)
 
 create table product
 (
 id serial primary key,
 product_name varchar(20),
 quantity int,
 price int
 );
 
 insert into product(product_name,quantity,price)
 values('lipstick',10,100),
 ('eyeshadow',5,55),
 ('drawingbook',20,150);
 
 select first_name||last_name from customer;
 
  create table gg
 (
 id serial primary key,
 "HELLO" varchar(20)
 );
 
 insert into gg("HELLO")
 values('xx'),
 ('yy'),
 ('zz');
 
 select "hello" from gg
 
 
 create table frtable(
 id serial primary key,
 cus_id int,
 supp_id int,
 constraint cust_id
 foreign key(cus_id)
 references customer(id),
 constraint suppl_id
 foreign key(supp_id)
 references supplier(id)
 )
 
  create table frtable2(
 id serial,
 cus_id int,
 supp_id int,
 fruitsu_name varchar(10),
 primary key(id,cus_id,supp_id),
 constraint cust_id
 foreign key(cus_id)
 references customer(id),
 constraint suppl_id
 foreign key(supp_id)
 references supplier(id)
 )
 
   create table frtable3(
 id serial,
 cus_id int,
 supp_id int,
 fruitsu_name varchar(10),
 primary key(id,cus_id,supp_id),
 constraint fk_cust_id foreign key(cus_id) references customer(id),
 constraint fk_suppl_id foreign key(supp_id) references supplier(id)
 )
 
    create table frtable4(
 id serial,
 cus_id int,
 supp_id int,
 fruitsu_name varchar(10),
 teimu timestamp without time zone,
 primary key(id,cus_id,supp_id),
 constraint fk_cust_id foreign key(cus_id) references customer(id),
 constraint fk_suppl_id foreign key(supp_id) references supplier(id)
 )

 
