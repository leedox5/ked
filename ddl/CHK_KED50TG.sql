DELIMITER $$
CREATE PROCEDURE CHK_KED50TG (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50tg_h
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from ked50tg a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;