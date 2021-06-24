create database stockdb;

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


INSERT INTO supplier
(supplier_id
,supplier_name,supplier_contact,supplier_bank_acc)VALUES
( (select lpad(((select coalesce(max(supplier_id),'0') from supplier)::int+1)::varchar,4,'0'))
,'Max Myanmar','09888888','KBZ-pay-09888888');

INSERT INTO supplier
(supplier_id
,supplier_name,supplier_contact,supplier_bank_acc)VALUES
( (select lpad((select coalesce(max(supplier_id)::int+1,'0'::int+1) from supplier)::varchar,4,'0'))
,'OoPine Myanmar','09999999','KBZ-pay-09999999');

INSERT INTO customer
(customer_id
,customer_phone,customer_name,customer_type,customer_add
,first_purchase_date,last_purchase_date)VALUES
( (select lpad((select coalesce(max(customer_id)::int+1,'0'::int+1) from customer)::varchar,4,'0'))
,'098588434','Myoe Aung',1,'944,LowerMingalarDoneRoad,Insein,Yangon'
,'12/20/2020','12/24/2020');

INSERT INTO customer
(customer_id
,customer_phone,customer_name,customer_type,customer_add
,first_purchase_date,last_purchase_date)VALUES
( (select lpad((select coalesce(max(customer_id)::int+1,'0'::int+1) from customer)::varchar,4,'0'))
,'097575757','Zaw Zaw',2,'877,InseinRoad,Insein,Yangon'
,'12/20/2020',(select now()::timestamp));

--,
--( (select lpad((select coalesce(max(customer_id)::int+1,'0'::int+1) from customer)::varchar,4,'0'))
--,'095555','Aye Nyein',1,'844,SanchaungRoad,Sanchaung,Yangon'
--,'12/20/2020',(select now()::timestamp));,
--( (select lpad((select coalesce(max(customer_id)::int+1,'0'::int+1) from customer)::varchar,4,'0'))
--,'0966666','Hlaing Zaq Aung',1,'779,KyiMyinDineRoad,KyimyinDine,Yangon'
--,'12/20/2020',(select now()::timestamp)),
--( (select lpad((select coalesce(max(customer_id)::int+1,'0'::int+1) from customer)::varchar,4,'0'))
--,'092222222','Moe aye',1,'221,PhoneGyiiRoad,Latha,Yangon'
--,'12/20/2020',(select now()::timestamp));


INSERT INTO product
(product_id,
product_name,unit_price)VALUES
( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
,'lipstick',2000
);

INSERT INTO product
(product_id,
product_name,unit_price)VALUES
( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
,'eyeliner',10000
);

INSERT INTO product
(product_id,
product_name,unit_price)VALUES
( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
,'mask',3000
);

INSERT INTO product
(product_id,
product_name,unit_price)VALUES
( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
,'faceshield',300
);

INSERT INTO product
(product_id,
product_name,unit_price)VALUES
( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
,'Enervon-C',7000
);

INSERT INTO product
(product_id,
product_name,unit_price)VALUES
( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
,'HandGel',1500
);



INSERT INTO color
(color_id
,color_name)VALUES
( (select lpad((select coalesce(max(color_id)::int+1,'0'::int+1) from color)::varchar,4,'0'))
,'pink');

INSERT INTO color
(color_id
,color_name)VALUES
( (select lpad((select coalesce(max(color_id)::int+1,'0'::int+1) from color)::varchar,4,'0'))
,'blue');

INSERT INTO color
(color_id
,color_name)VALUES
( (select lpad((select coalesce(max(color_id)::int+1,'0'::int+1) from color)::varchar,4,'0'))
,'green');

INSERT INTO color
(color_id
,color_name)VALUES
( (select lpad((select coalesce(max(color_id)::int+1,'0'::int+1) from color)::varchar,4,'0'))
,'red');

INSERT INTO color
(color_id
,color_name)VALUES
( (select lpad((select coalesce(max(color_id)::int+1,'0'::int+1) from color)::varchar,4,'0'))
,'yellow');

INSERT INTO color
(color_id
,color_name)VALUES
( (select lpad((select coalesce(max(color_id)::int+1,'0'::int+1) from color)::varchar,4,'0'))
,'white');

INSERT INTO color
(color_id
,color_name)VALUES
( (select lpad((select coalesce(max(color_id)::int+1,'0'::int+1) from color)::varchar,4,'0'))
,'black');

INSERT INTO product_color
(product_id,color_id,quantity)VALUES
( '0001','0007',20),
( '0001','0006',20),
( '0001','0004',20),
( '0002','0007',20),
( '0002','0006',20),
( '0002','0004',20);



INSERT INTO delivery
(delivery_id
,delivery_name,delivery_add
,first_purchase_date,last_purchase_date)VALUES
(
(select lpad((select coalesce(max(delivery_id)::int+1,'0'::int+1) from delivery)::varchar,4,'0'))
,'EMS','Sanchaung'
,'12/20/2020','12/20/2020');


INSERT INTO delivery
(delivery_id
,delivery_name,delivery_add
,first_purchase_date,last_purchase_date)VALUES
(
(select lpad((select coalesce(max(delivery_id)::int+1,'0'::int+1) from delivery)::varchar,4,'0'))
,'DDB','Mayangone'
,'12/20/2020',(select now()::timestamp));

INSERT INTO delivery
(delivery_id
,delivery_name,delivery_add
,first_purchase_date,last_purchase_date)VALUES
(
(select lpad((select coalesce(max(delivery_id)::int+1,'0'::int+1) from delivery)::varchar,4,'0'))
,'Royal Express','Tarmwe'
,(select now()::timestamp),(select now()::timestamp));

INSERT INTO delivery
(delivery_id
,delivery_name,delivery_add
,first_purchase_date,last_purchase_date)VALUES
(
(select lpad((select coalesce(max(delivery_id)::int+1,'0'::int+1) from delivery)::varchar,4,'0'))
,'DHL','Kamaryut'
,(select now()::timestamp),(select now()::timestamp));

INSERT INTO delivery
(delivery_id
,delivery_name,delivery_add
,first_purchase_date,last_purchase_date)VALUES
(
(select lpad((select coalesce(max(delivery_id)::int+1,'0'::int+1) from delivery)::varchar,4,'0'))
,'SusuHan','ShwePyiThar'
,'12/11/2020',(select now()::timestamp));

INSERT INTO delivery
(delivery_id
,delivery_name,delivery_add
,first_purchase_date,last_purchase_date)VALUES
(
(select lpad((select coalesce(max(delivery_id)::int+1,'0'::int+1) from delivery)::varchar,4,'0'))
,'YinYinThike','Hledan'
,'12/01/2020',(select now()::timestamp));

--INSERT INTO INVOICE(invoice_id
--,invoice_type,total_amount,invoice_date)VALUES
--( (select lpad((select coalesce(max(invoice_id)::int+1,'0'::int+1) from invoice)::varchar,4,'0'))
--,1,10000,'12/24/2020'
--);


--INSERT INTO sale(sale_id
--,invoice_id,product_id,color_id,delivery_id,customer_id,sale_type
--,quantity,sale_amount,discount,commission,grand_sale)VALUES
--((select lpad((select coalesce(max(sale_id)::int+1,'0'::int+1) from sale)::varchar,4,'0'))
--,'0001','0001','0001','0002','0002',1
--,5,(select unit_price*(5) from product where product_id='0001'),0,0,10000
--);

INSERT INTO profit
(profit_id
,product_id,color_id,profit_amount,profit_date
,sale_qty,instock_amount,order_amount)VALUES
((select lpad((select coalesce(max(profit_id)::int+1,'0'::int+1) from profit)::varchar,4,'0'))
,'0001','0004',20000,'12/22/2020'
,10,10,20);

INSERT INTO profit
(profit_id
,product_id,color_id,profit_amount,profit_date
,sale_qty,instock_amount,order_amount)VALUES
((select lpad((select coalesce(max(profit_id)::int+1,'0'::int+1) from profit)::varchar,4,'0'))
,'0001','0004',25500,'11/22/2020'
,10,10,20);

INSERT INTO profit
(profit_id
,product_id,color_id,profit_amount,profit_date
,sale_qty,instock_amount,order_amount)VALUES
((select lpad((select coalesce(max(profit_id)::int+1,'0'::int+1) from profit)::varchar,4,'0'))
,'0001','0006',10000,'12/22/2020'
,5,5,10);

INSERT INTO profit
(profit_id
,product_id,color_id,profit_amount,profit_date
,sale_qty,instock_amount,order_amount)VALUES
((select lpad((select coalesce(max(profit_id)::int+1,'0'::int+1) from profit)::varchar,4,'0'))
,'0001','0007',5000,'12/22/2020'
,2,3,5);

INSERT INTO profit
(profit_id
,product_id,color_id,profit_amount,profit_date
,sale_qty,instock_amount,order_amount)VALUES
((select lpad((select coalesce(max(profit_id)::int+1,'0'::int+1) from profit)::varchar,4,'0'))
,'0002','0004',30000,'12/22/2020'
,8,12,20);

INSERT INTO profit
(profit_id
,product_id,color_id,profit_amount,profit_date
,sale_qty,instock_amount,order_amount)VALUES
((select lpad((select coalesce(max(profit_id)::int+1,'0'::int+1) from profit)::varchar,4,'0'))
,'0002','0006',40000,'12/22/2020'
,20,10,30);

INSERT INTO profit
(profit_id
,product_id,color_id,profit_amount,profit_date
,sale_qty,instock_amount,order_amount)VALUES
((select lpad((select coalesce(max(profit_id)::int+1,'0'::int+1) from profit)::varchar,4,'0'))
,'0002','0007',40000,'12/22/2020'
,20,10,30);


INSERT INTO expense
(expense_id
,expense_type,expense_amount,expense_date,remark)VALUES
((select lpad((select coalesce(max(expense_id)::int+1,'0'::int+1) from expense)::varchar,4,'0'))
,1,10000,'12/20/2020','ExpenseForOthers');

INSERT INTO expense
(expense_id
,expense_type,expense_amount,expense_date,remark)VALUES
((select lpad((select coalesce(max(expense_id)::int+1,'0'::int+1) from expense)::varchar,4,'0'))
,2,10000,'12/02/2020','ExpenseForCleaning');

INSERT INTO expense
(expense_id
,expense_type,expense_amount,expense_date,remark)VALUES
((select lpad((select coalesce(max(expense_id)::int+1,'0'::int+1) from expense)::varchar,4,'0'))
,3,1000000,'12/28/2020','ExpenseForEmployeeSalary');

-------------
select profit_amount,date_part('month',profit_date) as "Profit_Month" from profit where
product_id='0001' and color_id='0004' 
and profit_date between '12/01/2020' and '12/30/2020';

select (select sum(profit_amount) from profit
where profit_date between '12/1/2020' and '12/31/2020') - sum(expense_amount) as "Net_Profit" from expense						
where expense_date between '12/1/2020' and '12/31/2020';


select sum(expense_amount)from expense where expense_date between '12/1/2020' and '12/31/2020';
---------

--INSERT INTO stock(stock_purchase_id
--,invoice_id,product_id,color_id,supplier_id,delivery_id
--,quantity,purchase_amount,remark)VALUES
--((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
--,'0001','0001','0001','0002','0002'
--,5,(select unit_price*(5) from product where product_id='0001'),'stock_purchase_for_kamaryut_branch'
--);
-----------------------------------------------------------------------------------------
-------------------------Use the query below for sales transaction-----------------------
-----------------------------------------------------------------------------------------
DO $$ 
DECLARE
    pid    varchar := '0001';
    qty    integer := 5;
    pcolor varchar := 'red';
    pcolorid varchar := '0004';
    del_id varchar := '0002';
    cus_id varchar := '0002';
    sale_type int := 1;
    disc int :=10;
    commission int:=1000;
    invoice_type int :=1;
    new_invoice varchar:='no';
	--
    prev_inv_id varchar:=(select max(invoice_id) from invoice);
    new_inv_id varchar:=(select lpad(((select coalesce(max(invoice_id),'0') from invoice)::int+1)::varchar,4,'0'));
    sale_amount int:=(select unit_price*(qty) from product where product_id=pid);
    prev_inv_grandsale int:= (select total_amount from invoice where invoice_id=(select max(invoice_id) from invoice));
	g_sale int:=sale_amount-(((sale_amount*disc)/100)+commission);
    now_time timestamp without time zone:=(select now()::timestamp);
    BEGIN
         IF EXISTS  --¦¦¦check if product instock
        (
            SELECT p.product_name,pc.product_id,pc.color_id,c.color_name,pc.quantity                  
            FROM product p join product_color pc
            on p.product_id=pc.product_id
            join color c
            on pc.color_id=c.color_id
            WHERE c.color_name = pcolor  and pc.product_id = pid and pc.color_id=pcolorid and pc.quantity>=qty
        )

        THEN--if product instock
            IF prev_inv_id is not null and new_invoice!='yes' 
            THEN--if invoice table has record and user do not request new invoice!
                --no new invoice 
                --insert into sale
                --update stockqty
				
                call sales_insert(prev_inv_id,pid,pcolorid,del_id,cus_id,sale_type,qty,disc,commission);
                call update_productcolortable_DecreaseSales(pid,pcolorid,qty);
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert into sale
                --update stockqty             
                call insertInv(invoice_type,g_sale,now_time);
                call sales_insert(new_inv_id,pid,pcolorid,del_id,cus_id,sale_type,qty,disc,commission);  
                call update_productcolortable_DecreaseSales(pid,pcolorid,qty);
                
            ELSE--if user request new invoice!
                --new invoice
                --insert new invoice
                --insert into sales
                --update stockqty
                call insertInv(invoice_type,g_sale,now_time);
                call sales_insert(new_inv_id,pid,pcolorid,del_id,cus_id,sale_type,qty,disc,commission);
				call update_productcolortable_DecreaseSales(pid,pcolorid,qty);
            END IF;
        END IF;
    END $$;   
    
-----------------------------------------------------------------------------------------
-------------------------Use the query below for stock transaction-----------------------
-----------------------------------------------------------------------------------------    
    
    DO $$ 
DECLARE
    p_name varchar :='new Product3';--only new product required to enter
    p_price integer := 3000;--only new product required to enter
    pid varchar := '0001';--new product not required to enter
    qty integer := 10;
    pcolor varchar := 'red';
    pcolorid varchar := '0001';--required both old/new product
    deli_id varchar := '0002';
    supp_id varchar := '0002';
    new_invoice varchar :='yes';
    new_product varchar :='no';
    remark varchar :='remark_sample_data';
    invoice_type int :=2;
    --
	prev_inv_id varchar:=(select max(invoice_id) from invoice);
	new_inv_id varchar:=(select lpad(((select coalesce(max(invoice_id),'0') from invoice)::int+1)::varchar,4,'0'));
    purchase_amount int:=(select unit_price*(qty) from product where product_id=pid);
	new_product_purchase_amount int:=(p_price*qty);
    prev_inv_grandsale int:= (select total_amount from invoice where invoice_id=(select max(invoice_id) from invoice));
	--g_sale int:=purchase_amount-(((purchase_amount*disc)/100)+commission);
    now_time timestamp without time zone:=(select now()::timestamp);
    BEGIN
        IF new_product!='yes'--if old product
        THEN--if old product
            IF prev_inv_id is not null and new_invoice!='yes' 
            THEN--if invoice table has record and user do not request new invoice!
                --no new invoice 
                --insert into stock
                --update stockqty
                call insertStock(prev_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
                call updateInv(prev_inv_id,(purchase_amount+prev_inv_grandsale),now_time);     
                call update_productcolortable_IncreaseStock(pid,pcolorid,qty);
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert into stock
                --update stockqty
                call insertInv(invoice_type,purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
                call update_productcolortable_IncreaseStock(pid,pcolorid,qty);
                
            ELSE--if user request new invoice!
                --new invoice
                --insert new invoice
                --insert into stock
                --update stockqty
                call insertInv(invoice_type,purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
			    call update_productcolortable_IncreaseStock(pid,pcolorid,qty);
            END IF;
        ELSE--if new product
            IF prev_inv_id is not null and new_invoice!='yes' 
            THEN--if invoice table has record and user do not request new invoice!
                --no new invoice 
                --insert product
                --insert into stock
                call insertProduct(p_name,p_price);
                call insertProductColor(pcolorid,qty);
                call insertStock(prev_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
                call updateInv(prev_inv_id,(new_product_purchase_amount+prev_inv_grandsale),now_time);
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert product
                --insert into stock
                call insertProduct(p_name,p_price);
                call insertProductColor(pcolorid,qty);
                call insertInv(invoice_type,new_product_purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);     
                
            ELSE--if user request new invoice!
                --new invoice
                --insert product
                --insert new invoice
                --insert into stock
                call insertProduct(p_name,p_price);
                call insertProductColor(pcolorid,qty);
                call insertInv(invoice_type,new_product_purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
            END IF;
        END IF;
    END $$;

-------
--invoice insert procedure
-------
create or replace procedure insertInv(
   inv_type int, 
   ttl_amount numeric,
   inv_date timestamp without time zone
)
language plpgsql    
as $$
begin
    INSERT INTO INVOICE(invoice_id
    ,invoice_type,total_amount,invoice_date)VALUES
    ( (select lpad((select coalesce(max(invoice_id)::int+1,'0'::int+1) from invoice)::varchar,4,'0'))
    ,inv_type,ttl_amount,inv_date
    );
    commit;
end;$$

-------
--invoice update procedure
-------
create or replace procedure updateInv(
   inv_id varchar(4), 
   ttl_amount numeric,
   inv_date timestamp without time zone
)
language plpgsql    
as $$
begin
    UPDATE INVOICE
	set total_amount=ttl_amount,invoice_date=inv_date where invoice_id=inv_id;

    commit;
end;$$

-------
--stock insert procedure
-------
create or replace procedure insertStock(
   inv_id varchar(4), 
   p_id varchar(4), 
   c_id varchar(4),
   supp_id varchar(4),
   deli_id varchar(4),
   ins_stck_qty int,
   remark varchar,
   new_product varchar
)
language plpgsql    
as $$
begin
     IF new_product!='yes'   
     THEN
                 INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,inv_id,p_id,c_id,supp_id,deli_id
                ,ins_stck_qty,(select unit_price*(ins_stck_qty) from product where product_id=p_id),remark
                );
    ELSE
                INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,inv_id,(select max(product_id) from product),c_id,supp_id,deli_id
                ,ins_stck_qty,(select unit_price*(ins_stck_qty) from product where product_id=(select max(product_id) from product))
                ,remark
                );
    END IF;
    commit;
end;$$

-------
--product_color insert procedure
-------
create or replace procedure insertProductColor( 
   c_id varchar(4),
   qty int
)
language plpgsql    
as $$
begin
            INSERT INTO product_color
            (product_id,color_id,quantity)VALUES
            ( (select max(product_id) from product),c_id,qty);
    commit;
end;$$

-------
--product insert procedure
-------
create or replace procedure insertProduct(
   p_name varchar,
   unit_price int
)
language plpgsql    
as $$
begin
            INSERT INTO product
            (product_id,
            product_name,unit_price)VALUES
            ( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
            ,p_name,unit_price
            );
    commit;
end;$$

-------
--product_color updateIncreaseStock procedure
-------
create or replace procedure update_productcolortable_IncreaseStock(
   	pid  varchar(4),
	cid  varchar(4),
   	qty int
)
language plpgsql    
as $$
begin
            update product_color set quantity= (quantity+qty)where product_id in (pid) and color_id in(cid);
    commit;
end;$$

-------
--product_color updateDecreaseSales procedure
-------
create or replace procedure update_productcolortable_DecreaseSales(
   	pid  varchar(4),
	cid  varchar(4),
   	qty int
)
language plpgsql    
as $$
begin
            update product_color set quantity= (quantity-qty)where product_id in (pid) and color_id in(cid);
    commit;
end;$$

-------
--sales insert procedure
-------
create or replace procedure sales_insert(
   	inv_id  varchar(4),
	p_id  varchar(4),
	c_id  varchar(4),
	del_id varchar(4),
	cus_id varchar(4),
	saletype int,
   	sale_qty int,
	disc int,
	commission int
)
language plpgsql    
as $$
DECLARE
	sale_amount int:=(select unit_price*(sale_qty) from product where product_id=p_id);
	g_sale int:=sale_amount-(((sale_amount*disc)/100)+commission);
begin
            INSERT INTO sale(sale_id
                ,invoice_id,product_id,color_id,delivery_id,customer_id,sale_type
                ,quantity,sale_amount,discount,commission,grand_sale)VALUES
                ((select lpad((select coalesce(max(sale_id)::int+1,'0'::int+1) from sale)::varchar,4,'0'))
                ,inv_id,p_id,c_id,del_id,cus_id,saletype
                ,sale_qty,sale_amount,disc,commission,g_sale
                );
    commit;
end;$$

