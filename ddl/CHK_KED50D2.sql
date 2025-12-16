DELIMITER $$
CREATE PROCEDURE CHK_KED50D2 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50d2_h 
select b.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50d2 b
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;