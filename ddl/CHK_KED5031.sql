DELIMITER $$
CREATE PROCEDURE CHK_KED5031 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked5031_h 
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked5031 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;