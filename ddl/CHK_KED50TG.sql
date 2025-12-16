DELIMITER $$
CREATE PROCEDURE CHK_KED50TG (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50tg_h
select b.BASE_DT
      ,b.BZNO
      ,IN_DATE
      ,b.CONO
      ,b.PND_PTNTR_CN
      ,b.PND_UM_CN
      ,b.REG_PTNTR_CN
      ,b.REG_UM_CN
      ,b.REG_VLD_PTNTR_CN
      ,b.REG_VLD_UM_CN
      ,b.KODATA_UPD_DT
      ,b.CONO_BAD_INFO
      ,b.BZNO_BAD_INFO
      ,b.CO_REG_INFO
      ,b.LQDT_INFO
      ,b.KODATACD
      ,b.KODATA_ENP_NM
      ,b.KODATA_REPER_NM
      ,b.LOC
      ,b.ADDR1
      ,b.ADDR2
      ,b.TEL_NO
      ,b.ESTB_DT
      ,b.ASET_T_SUM
      ,b.LIAB_T_SUM
      ,b.SAM
      ,b.BZPF
      ,b.NPFCT
      ,b.RND_MP
      ,b.ACCT_DT
      ,b.BZC_CD
  from corp_info_main a
      inner join 
       ked50tg b
      on b.bzno = a.corp_no
    on duplicate key
update cono = b.cono;

END $$
DELIMITER ;