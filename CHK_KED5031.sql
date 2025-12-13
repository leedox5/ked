DELIMITER $$
CREATE PROCEDURE CHK_KED5031 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked5031_h 
select b.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from corp_info_main a
      inner join
       ked5031 b
      on b.kedcd = a.ked_code
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;