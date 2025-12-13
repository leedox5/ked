DELIMITER $$
CREATE PROCEDURE CHK_KED5016 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked5016_h 
select b.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from corp_info_main a
      inner join
       ked5016 b
      on b.kedcd = a.ked_code
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;