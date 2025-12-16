DELIMITER $$
CREATE PROCEDURE CHK_KED50D5 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50d5_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50d5 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;