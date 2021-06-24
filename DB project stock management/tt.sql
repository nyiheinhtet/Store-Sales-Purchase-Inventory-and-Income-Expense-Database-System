DO $$ 
	DECLARE
    pid    varchar := '0004';
    qty    integer := 5;
    pcolor varchar := 'red';
    pcid   varchar := '0002';
    new_invoice varchar:='yes';
    new_product varchar:='yes';
	prev_inv_id varchar:=(select max(invoice_id) from invoice);
	new_inv_id varchar:=(select lpad(((select coalesce(max(invoice_id),'0') from invoice)::int+1)::varchar,4,'0'));
    BEGIN
        IF new_product!='yes'--if old product
        THEN--if old product
            IF prev_inv_id is not null and new_invoice!='yes' 
            THEN--if invoice table has record and user do not request new invoice!
                --no new invoice 
                --insert into sale
                --update stock
                
                INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,prev_inv_id,pid,'0001','0002','0002'
                ,qty,(select unit_price*(qty) from product where product_id=pid),'stock_purchase_for_kamaryut_branch'
                );
                
                update product set quantity= (quantity+qty)where product_id in (pid);
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert into sale
                --update stock
                INSERT INTO INVOICE(invoice_id
                ,invoice_type,total_amount,invoice_date)VALUES
                ( (select lpad((select coalesce(max(invoice_id)::int+1,'0'::int+1) from invoice)::varchar,4,'0'))
                ,1,10000,'12/24/2020'
                );
                
                 INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,new_inv_id,pid,'0001','0002','0002'
                ,qty,(select unit_price*(qty) from product where product_id=pid),'stock_purchase_for_kamaryut_branch'
                );
                
                update product set quantity= (quantity+qty)where product_id in (pid);  
                
            ELSE--if user request new invoice!
                --new invoice
                --insert into sales
                --update stock
                INSERT INTO INVOICE(invoice_id
                ,invoice_type,total_amount,invoice_date)VALUES
                ( (select lpad((select coalesce(max(invoice_id)::int+1,'0'::int+1) from invoice)::varchar,4,'0'))
                ,1,10000,'12/24/2020'
                );
                
                 INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,new_inv_id,pid,'0001','0002','0002'
                ,qty,(select unit_price*(qty) from product where product_id=pid),'stock_purchase_for_kamaryut_branch'
                );
                
                update product set quantity= (quantity+qty)where product_id in (pid);
            END IF;
        ELSE--if new product
            IF prev_inv_id is not null and new_invoice!='yes' 
            THEN--if invoice table has record and user do not request new invoice!
                --no new invoice 
                --insert into sale
                --update stock
                
                INSERT INTO product
                (product_id,
                product_name,unit_price,quantity)VALUES
                ( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
                ,'newProduct',2000,qty
                );
                
                INSERT INTO product_color
                (product_id,color_id)VALUES
                ( (select max(product_id) from product),pcid);
                
                INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,prev_inv_id,(select max(product_id) from product),pcid,'0002','0002'
                ,qty,(select unit_price*(qty) from product where product_id=(select max(product_id) from product))
                ,'stock_purchase_for_kamaryut_branch'
                );
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert into sale
                --update stock
                INSERT INTO product
                (product_id,
                product_name,unit_price,quantity)VALUES
                ( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
                ,'newProduct',2000,qty
                );
                
                INSERT INTO product_color
                (product_id,color_id)VALUES
                ( (select max(product_id) from product),pcid);
                
                INSERT INTO INVOICE(invoice_id
                ,invoice_type,total_amount,invoice_date)VALUES
                ( (select lpad((select coalesce(max(invoice_id)::int+1,'0'::int+1) from invoice)::varchar,4,'0'))
                ,1,10000,'12/24/2020'
                );
                
                 INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,new_inv_id,(select max(product_id) from product),pcid,'0002','0002'
                ,qty,(select unit_price*(qty) from product where product_id=(select max(product_id) from product))
                ,'stock_purchase_for_kamaryut_branch'
                );
                
            ELSE--if user request new invoice!
                --new invoice
                --insert into sales
                --update stock
                 INSERT INTO product
                (product_id,
                product_name,unit_price,quantity)VALUES
                ( (select lpad((select coalesce(max(product_id)::int+1,'0'::int+1) from product)::varchar,4,'0'))
                ,'newProduct',1000,qty
                );
                
                INSERT INTO product_color
                (product_id,color_id)VALUES
                ( (select max(product_id) from product),pcid);
                
                INSERT INTO INVOICE(invoice_id
                ,invoice_type,total_amount,invoice_date)VALUES
                ( (select lpad((select coalesce(max(invoice_id)::int+1,'0'::int+1) from invoice)::varchar,4,'0'))
                ,1,10000,'12/24/2020'
                );
                
                 INSERT INTO stock(stock_purchase_id
                ,invoice_id,product_id,color_id,supplier_id,delivery_id
                ,quantity,purchase_amount,remark)VALUES
                ((select lpad((select coalesce(max(stock_purchase_id)::int+1,'0'::int+1) from stock)::varchar,4,'0'))
                ,new_inv_id,(select max(product_id) from product),pcid,'0002','0002'
                ,qty,(select unit_price*(qty) from product where product_id=(select max(product_id) from product))
                ,'stock_purchase_for_kamaryut_branch'
                );
            END IF;
        
        END IF;
    END $$;