DELIMITER $$
CREATE PROCEDURE CHK_KED5026_HIST (IN IN_DATE VARCHAR(20))
BEGIN

-- HIST 톄이쁠예 넣기
insert into ked5026_hist  
select b.KEDCD
      ,b.STD_DT
      ,row_number() over (partition by kedcd, std_dt) as SEQ
      ,b.TXPL_CCD
      ,b.TXPL_SEQ
      ,b.TX_AM_BASE_STDT
      ,b.TX_AM_BASE_EDDT
      ,b.TXPL_NM
      ,b.TEL_NO
      ,b.BZNO
      ,b.TXPL_KEDCD
      ,b.DO_CCD
      ,b.TX_FCD
      ,b.PD_NM
      ,b.PD_CD
      ,b.TX_AM
      ,b.TX_RT
      ,b.TX_PRD
      ,b.CSH_STL_RT
      ,b.CR_STL_RT
      ,b.CR_STL_DCN
      ,b.CND_ETC
      ,b.RMK
      ,IN_DATE
      ,DATE_FORMAT(NOW(), '%Y%m%d %H:%i:%s') AS updated
  from corp_info_main a
      inner join
       ked5026 b
      on  b.kedcd = a.KED_CODE
    on duplicate key
update updated = DATE_FORMAT(NOW(), '%Y%m%d %H:%i:%s');

END $$
DELIMITER ;