-----------------------------------------------------------------------------------------
-------------------------Use the query below for sales transaction-----------------------
-----------------------------------------------------------------------------------------
DO $$ 
DECLARE
    pid    varchar := '0011';
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
         IF EXISTS  --※※※check if product instock
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
                --update stock
				
                call sales_insert(prev_inv_id,pid,pcolorid,del_id,cus_id,sale_type,qty,disc,commission);
                call updateInv(prev_inv_id,(g_sale+prev_inv_grandsale),now_time);
                
                call update_productcolortable_DecreaseSales(pid,pcolorid,qty);
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert into sale
                --update stock             
                call insertInv(invoice_type,g_sale,now_time);
                call sales_insert(new_inv_id,pid,pcolorid,del_id,cus_id,sale_type,qty,disc,commission);  
                call update_productcolortable_DecreaseSales(pid,pcolorid,qty);
                
            ELSE--if user request new invoice!
                --new invoice
                --insert into sales
                --update stock
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
    pid varchar := '0007';--new product not required to enter
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
                --insert into sale
                --update stock
                call insertStock(prev_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
                call updateInv(prev_inv_id,(purchase_amount+prev_inv_grandsale),now_time);     
                call update_productcolortable_IncreaseStock(pid,pcolorid,qty);
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert into sale
                --update stock
                call insertInv(invoice_type,purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
                call update_productcolortable_IncreaseStock(pid,pcolorid,qty);
                
            ELSE--if user request new invoice!
                --new invoice
                --insert into sales
                --update stock
                call insertInv(invoice_type,purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
			    call update_productcolortable_IncreaseStock(pid,pcolorid,qty);
            END IF;
        ELSE--if new product
            IF prev_inv_id is not null and new_invoice!='yes' 
            THEN--if invoice table has record and user do not request new invoice!
                --no new invoice 
                --insert into sale
                --update stock
                call insertProduct(p_name,p_price);
                call insertProductColor(pcolorid,qty);
                call insertStock(prev_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
                call updateInv(prev_inv_id,(new_product_purchase_amount+prev_inv_grandsale),now_time);
                
            ELSIF prev_inv_id=null and new_invoice!='yes' 
            THEN--if invoice table has no record and user do not request new invoice!
                --new invoice 
                --insert into sale
                --update stock
                call insertProduct(p_name,p_price);
                call insertProductColor(pcolorid,qty);
                call insertInv(invoice_type,new_product_purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);     
                
            ELSE--if user request new invoice!
                --new invoice
                --insert into sales
                --update stock
                call insertProduct(p_name,p_price);
                call insertProductColor(pcolorid,qty);
                call insertInv(invoice_type,new_product_purchase_amount,now_time);
                call insertStock(new_inv_id,pid,pcolorid,supp_id,deli_id,qty,remark,new_product);
            END IF;
        END IF;
    END $$;