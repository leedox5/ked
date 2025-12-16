DELIMITER $$
CREATE PROCEDURE CHK_KED5003 (IN IN_DATE VARCHAR(20))
BEGIN

insert into ked5003_h
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked5003 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;