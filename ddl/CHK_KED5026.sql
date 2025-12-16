DELIMITER $$
CREATE PROCEDURE CHK_KED5026 (IN IN_DATE VARCHAR(20))
BEGIN

-- HIST 톄이쁠예 넣기
insert into ked5026_h  
select a.*
      ,DATE_FORMAT(NOW(), '%Y%m%d %H:%i:%s') AS updated
  from ked5026 a
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d %H:%i:%s');

END $$
DELIMITER ;