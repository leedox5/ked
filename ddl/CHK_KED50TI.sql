DELIMITER $$
CREATE PROCEDURE CHK_KED50TI (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50ti_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50ti a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;