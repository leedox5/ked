DELIMITER $$
CREATE PROCEDURE CHK_KED50TA (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50ta_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50ta a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;