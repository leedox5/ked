DELIMITER $$
CREATE PROCEDURE CHK_KED5016 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked5016_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked5016 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;