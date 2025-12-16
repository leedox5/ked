DELIMITER $$
CREATE PROCEDURE CHK_KED50D1 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50d1_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50d1 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;