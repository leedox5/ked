DELIMITER $$
CREATE PROCEDURE CHK_KED50D7 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50d7_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50d7 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;