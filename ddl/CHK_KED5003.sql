DELIMITER $$
CREATE PROCEDURE CHK_KED5003 (IN IN_DATE VARCHAR(20))
BEGIN

insert into ked5003_h
select KEDCD
      ,IN_DATE
      ,ACCT_DT
      ,SUMASSET
      ,PAYMENTFUND
      ,FUNDTOTAL
      ,SALES
      ,PROFIT
      ,TERMNETPROFIT  
  from corp_info_main a
      inner join
       ked5003 b
      on b.kedcd = a.ked_code
    on duplicate key
update acct_dt = b.acct_dt
;

END $$
DELIMITER ;