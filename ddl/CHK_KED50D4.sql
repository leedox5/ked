DELIMITER $$
CREATE PROCEDURE CHK_KED50D4 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50d4_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50d4 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;