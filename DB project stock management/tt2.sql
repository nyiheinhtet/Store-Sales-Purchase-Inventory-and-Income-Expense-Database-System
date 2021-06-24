-------
DO $$
DECLARE
invtype int:=1;
ttl_amount numeric:=79797;
now_time timestamp without time zone:=(select now()::timestamp);
new_invoice varchar:='no';
p_id varchar:='0004';
pc_id  varchar:= '0002';
supp_id varchar:= '0002';
deli_id varchar:= '0002';
qty int:=5;
remark varchar:='insert stock Data';
new_product varchar:='yes';
prev_inv_id varchar:=(select max(invoice_id) from invoice);
new_inv_id varchar:=(select lpad(((select coalesce(max(invoice_id),'0') from invoice)::int+1)::varchar,4,'0'));
	BEGIN
		IF new_invoice!='yes'
		THEN
			call insertInv(invtype,ttl_amount,now_time);
			call insertStock(new_inv_id,p_id,pc_id,supp_id,deli_id,qty,remark,new_product);
		END IF;
	END $$;


drop procedure update_productcolortable_IncreaseStock;

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

call insertInv(invtype,ttl_amount,now_time);

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

call updateInv('0001',(79797+3),'12/29/2020');

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

call insertStock(new_inv_id,p_id,pc_id,supp_id,deli_id,qty,remark,new_product);

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

call insertProductColor('0001',5);

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

call insertProduct('Lube',500);

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

call update_productcolortable_IncreaseStock('0007','0001',10);

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

call update_productcolortable_DecreaseSales('0007','0001',5);

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

call sales_insert('0001','0002','0004','0001','0001',1,5,10,2000);