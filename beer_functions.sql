drop function if exists fn_get_order_total;
drop function if exists fn_get_customer_total_spent;
drop function if exists fn_get_stock;
drop function if exists fn_get_customer_order_count;
drop function if exists fn_get_total_inventory;

DELIMITER $$
CREATE FUNCTION fn_get_order_total(p_order_id VARCHAR(10)) -- Tính tổng tiền 1 đơn hàng
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT SUM(od.quantity * p.price)
    INTO v_total
    FROM OrderDetail od
    JOIN Products p ON od.prod_id = p.prod_id
    WHERE od.order_id = p_order_id;
    RETURN IFNULL(v_total, 0);
END$$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION fn_get_customer_total_spent(p_customer_id VARCHAR(10)) -- Tính tổng tiền khách hàng đã chi
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE v_total DECIMAL(10,2);
    SELECT SUM(total_amount)
    INTO v_total
    FROM Orders
    WHERE customer_id = p_customer_id;
    RETURN IFNULL(v_total, 0);
END$$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION fn_get_stock(p_prod_id VARCHAR(10)) -- Lấy tồn kho thực tế (Import - Export)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_import INT;
    DECLARE v_export INT;
    SELECT IFNULL(SUM(ex_im_quantity),0)
    INTO v_import
    FROM Ex_Im
    WHERE prod_id = p_prod_id AND type = 'Import';

    SELECT IFNULL(SUM(ex_im_quantity),0)
    INTO v_export
    FROM Ex_Im
    WHERE prod_id = p_prod_id AND type = 'Export';

    RETURN v_import - v_export;
END$$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION fn_get_customer_order_count(p_customer_id VARCHAR(10)) -- Tính tổng số đơn hàng của khách hàng
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_count INT;
    SELECT COUNT(*) INTO v_count
    FROM Orders
    WHERE customer_id = p_customer_id;
    RETURN IFNULL(v_count, 0);
END$$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION fn_get_total_inventory() -- Tính tổng sản phẩm hiện có trong kho
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_total INT;
    SELECT SUM(current_quantity) INTO v_total FROM Inventory;
    RETURN IFNULL(v_total, 0);
END$$
DELIMITER ;

select fn_get_total_inventory() as currentInv; 
select customer_id, fn_get_customer_order_count(customer_id) as totalAmountOrder from Customers;