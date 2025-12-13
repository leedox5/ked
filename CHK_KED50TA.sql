DELIMITER $$
CREATE PROCEDURE CHK_KED50TA (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50ta_h 
select b.*
      ,DATE_FORMAT(NOW(), '%Y%m%d%H%i%s')
  from corp_info_main a
      inner join
       ked50ta b
      on b.kodatacd = a.ked_code
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d%H%i%s');

END $$
DELIMITER ;