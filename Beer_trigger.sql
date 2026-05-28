DROP TRIGGER IF EXISTS trg_update_inventory_after_exim;
DROP TRIGGER IF EXISTS trg_update_order_total;
DROP TRIGGER IF EXISTS trg_update_customer_loyalty;
DROP TRIGGER IF EXISTS trg_update_inventory_audit;

DELIMITER $$
CREATE TRIGGER trg_update_inventory_after_exim -- Tự động cập nhật tồn kho khi có xuất/nhập
AFTER INSERT ON Ex_Im
FOR EACH ROW
BEGIN
    IF NEW.type = 'Import' THEN
        UPDATE Inventory
        SET current_quantity = current_quantity + NEW.ex_im_quantity
        WHERE inv_id = NEW.inv_id;
    ELSEIF NEW.type = 'Export' THEN
        UPDATE Inventory
        SET current_quantity = current_quantity - NEW.ex_im_quantity
        WHERE inv_id = NEW.inv_id;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_update_order_total -- Tự động cập nhật tổng tiền đơn hàng khi thêm OrderDetail
AFTER INSERT ON OrderDetail
FOR EACH ROW
BEGIN
    UPDATE Orders
    SET total_amount = fn_get_order_total(NEW.order_id)
    WHERE order_id = NEW.order_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_update_customer_loyalty -- Cộng điểm thưởng cho khách hàng khi thanh toán xong
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'Paid' AND OLD.payment_status <> 'Paid' THEN
        UPDATE Customers
        SET loyalty_points = loyalty_points + FLOOR(NEW.total_amount / 10)
        WHERE customer_id = NEW.customer_id;
    END IF;
END$$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER trg_update_inventory_audit -- Cập nhật ngày kiểm kê kho
BEFORE UPDATE ON Inventory
FOR EACH ROW
BEGIN
    SET NEW.last_audit_date = CURRENT_DATE();
END$$
DELIMITER ;



-- ----------------------------------------------------------------------------------------------------------------------
 /* TEST:
USE ecommerce;

/* trg_update_inventory_after_exim */

SELECT current_quantity FROM Inventory WHERE inv_id = 'INV001';

-- Valid Import:
INSERT INTO Ex_Im (prod_id, inv_id, type, ex_im_date, ex_im_quantity) VALUES ('PRD001', 'INV001', 'Import', NOW(), 100);
SELECT current_quantity FROM Inventory WHERE inv_id = 'INV001';

-- Valid Export:
INSERT INTO Ex_Im (prod_id, inv_id, type, ex_im_date, ex_im_quantity) VALUES ('PRD001', 'INV001', 'Export', NOW(), 50);
SELECT current_quantity FROM Inventory WHERE inv_id = 'INV001';

-- Invalid:
INSERT INTO Ex_Im (prod_id, inv_id, type, ex_im_date, ex_im_quantity) VALUES ('PRD001', 'INV001', 'Invalid', NOW(), 30);

SELECT * FROM Ex_Im;
SELECT * FROM Inventory;


-- Hiển thị trạng thái tồn kho ban đầu
SELECT current_quantity FROM Inventory WHERE inv_id = 'INV001';  

-- Gọi procedure để test Import (trigger sẽ cộng +50)
CALL ProcessExIm('PRD001', 'INV001', 'Import', 100);

-- Kiểm tra sau Import
SELECT current_quantity FROM Inventory WHERE inv_id = 'INV001';  

-- Gọi procedure để test Export (trigger sẽ trừ -30)
CALL ProcessExIm('PRD001', 'INV001', 'Export', 30);

-- Kiểm tra sau Export
SELECT current_quantity FROM Inventory WHERE inv_id = 'INV001';  -- Kết quả mong đợi: 120

-- (Tùy chọn) Kiểm tra log trong Ex_Im để xác nhận insert thành công
SELECT * FROM Ex_Im WHERE inv_id = 'INV001';

/* trg_update_order_total */

INSERT INTO Orders (order_id, customer_id, total_amount, payment_status, shipment_status) VALUES ('ORDTEST', 'CUS001', 0, 'Pending', 'Pending');
SELECT total_amount FROM Orders WHERE order_id = 'ORDTEST';

-- Valid:
INSERT INTO OrderDetail (order_id, prod_id, quantity) VALUES ('ORDTEST', 'PRD001', 10);
SELECT total_amount FROM Orders WHERE order_id = 'ORDTEST';

-- Invalid:
INSERT INTO OrderDetail (order_id, prod_id, quantity) VALUES ('ORDTEST', 'PRD001', 0);

DELETE FROM OrderDetail WHERE order_id = 'ORDTEST';
DELETE FROM Orders WHERE order_id = 'ORDTEST';

/* trg_update_customer_loyalty */

SELECT loyalty_points FROM Customers WHERE customer_id = 'CUS001';

INSERT INTO Orders (order_id, customer_id, total_amount, payment_status, shipment_status) VALUES ('ORDTEST2', 'CUS001', 150, 'Pending', 'Pending');

-- Valid:
UPDATE Orders SET payment_status = 'Paid' WHERE order_id = 'ORDTEST2';
SELECT loyalty_points FROM Customers WHERE customer_id = 'CUS001';

-- Invalid:
UPDATE Orders SET payment_status = 'Failed' WHERE order_id = 'ORDTEST2';
SELECT loyalty_points FROM Customers WHERE customer_id = 'CUS001';

DELETE FROM Orders WHERE order_id = 'ORDTEST2';

/* trg_update_inventory_audit */

SELECT last_audit_date FROM Inventory WHERE inv_id = 'INV001';

-- Valid:
UPDATE Inventory SET notes = 'Test' WHERE inv_id = 'INV001';
SELECT last_audit_date FROM Inventory WHERE inv_id = 'INV001';

-- Invalid (no change):
UPDATE Inventory SET notes = 'Test' WHERE inv_id = 'INV001';
SELECT last_audit_date FROM Inventory WHERE inv_id = 'INV001';

UPDATE Inventory SET notes = NULL WHERE inv_id = 'INV001';