drop procedure if exists AddNewCustomer;
drop procedure if exists AddNewOrder;
drop procedure if exists AddOrderDetail;
drop procedure if exists ProcessExIm;
drop procedure if exists UpdateOrderStatus;

-- Thêm khách hàng mới (auto tạo ID có chữ và số )
DELIMITER $$
CREATE PROCEDURE AddNewCustomer(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15),
    IN p_address VARCHAR(255)
)
BEGIN
    DECLARE v_customer_id VARCHAR(10);
    DECLARE v_next INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(customer_id, 4) AS UNSIGNED)), 0) + 1 INTO v_next FROM Customers;
    SET v_customer_id = CONCAT('CUS', LPAD(v_next, 3, '0'));
    INSERT INTO Customers(customer_id, first_name, last_name, email, phone, address)
    VALUES(v_customer_id, p_first_name, p_last_name, p_email, p_phone, p_address);
    SELECT v_customer_id AS new_customer_id;
END$$
DELIMITER ;


--  Thêm đơn hàng mới
DELIMITER $$
CREATE PROCEDURE AddNewOrder(
    IN p_customer_id VARCHAR(10),
    IN p_payment_method VARCHAR(50),
    IN p_tax_amount DECIMAL(10,2),
    IN p_shipment_cost DECIMAL(10,2),
    IN p_payment_status VARCHAR(50),
    IN p_shipment_status VARCHAR(50),
    IN p_delivery_date DATE
)
BEGIN
    DECLARE v_order_id VARCHAR(10);
    DECLARE v_next INT;
    SELECT IFNULL(MAX(CAST(SUBSTRING(order_id, 4) AS UNSIGNED)), 0) + 1 INTO v_next FROM Orders;
    SET v_order_id = CONCAT('ORD', LPAD(v_next, 3, '0'));
    INSERT INTO Orders(order_id, customer_id, payment_method, payment_status, shipment_status, delivery_date)
    VALUES(v_order_id, p_customer_id, p_payment_method, p_payment_status, p_shipment_status, p_delivery_date);
    SELECT v_order_id AS new_order_id;
END$$
DELIMITER ;

-- Thêm chi tiết đơn hàng
DELIMITER $$
CREATE PROCEDURE AddOrderDetail(
    IN p_order_id VARCHAR(10),
    IN p_prod_id VARCHAR(10),
    IN p_quantity INT
)
BEGIN
    INSERT INTO OrderDetail(order_id, prod_id, quantity)
    VALUES(p_order_id, p_prod_id, p_quantity);
    UPDATE Orders
    SET total_amount = fn_get_order_total(p_order_id)
    WHERE order_id = p_order_id;
END$$
DELIMITER ;

-- Xử lý nhập hoặc xuất hàng
DELIMITER $$
CREATE PROCEDURE ProcessExIm(
    IN p_prod_id VARCHAR(10),
    IN p_inv_id VARCHAR(10),
    IN p_type ENUM('Export','Import'),
    IN p_exim_quantity INT
)
BEGIN
    -- Cập nhật tồn kho
    IF p_type = 'Import' THEN
        UPDATE Inventory
        SET current_quantity = current_quantity + p_exim_quantity,
            last_audit_date = CURRENT_DATE()
        WHERE inv_id = p_inv_id;
    ELSEIF p_type = 'Export' THEN
        UPDATE Inventory
        SET current_quantity = current_quantity - p_exim_quantity,
            last_audit_date = CURRENT_DATE()
        WHERE inv_id = p_inv_id;
    END IF;

    -- Sau đó mới ghi log Ex_Im
    INSERT INTO Ex_Im(prod_id, inv_id, type, ex_im_quantity)
    VALUES(p_prod_id, p_inv_id, p_type, p_exim_quantity);
END$$
DELIMITER ;

-- Cập nhật trạng thái thanh toán và vận chuyển
DELIMITER $$
CREATE PROCEDURE UpdateOrderStatus(
    IN p_order_id VARCHAR(10),
    IN p_payment_status VARCHAR(50),
    IN p_shipment_status VARCHAR(50)
)
BEGIN
    UPDATE Orders
    SET payment_status = p_payment_status,
        shipment_status = p_shipment_status
    WHERE order_id = p_order_id;
END$$
DELIMITER ;
	