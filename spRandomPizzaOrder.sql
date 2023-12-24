DROP procedure IF EXISTS `take_random_pizza_order`;
DELIMITER $$
CREATE PROCEDURE `take_random_pizza_order`(	IN id_customer VARCHAR(15),
											IN method CHAR(1),
											OUT order_taken BOOL)
BEGIN
	DECLARE id_random_pizza INT;
    DECLARE price_random_pizza DECIMAL(5,2);
    DECLARE price_with_discount DECIMAL(5,2);
    
    DECLARE WITH_ERRORS BOOL DEFAULT FALSE;
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
		SET WITH_ERRORS = TRUE;
    END;
    
	SELECT	id_pizza, price
    INTO 	id_random_pizza, price_random_pizza
    FROM 	pizza
    WHERE 	available = 1
    ORDER BY RAND()
    LIMIT 	1;
    
    SET price_with_discount = price_random_pizza - (price_random_pizza * 0.20);
    
    START TRANSACTION;
	INSERT INTO pizza_order (id_customer, date, total, method, additional_notes)
	VALUES (id_customer, SYSDATE(), price_with_discount, method, '20% OFF PIZZA RANDOM PROMOTION');
    
    INSERT INTO order_item (id_item, id_order, id_pizza, quantity, price)
	VALUES (1, LAST_INSERT_ID(), id_random_pizza, 1, price_random_pizza);
	
	IF WITH_ERRORS THEN 
		SET order_taken = FALSE;
		ROLLBACK;
	ELSE 
		SET order_taken = TRUE;
        COMMIT;
	END IF;
	
    SELECT order_taken;
END$$

DELIMITER ;