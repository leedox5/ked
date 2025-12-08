DELIMITER $$
CREATE PROCEDURE CHK_KED50D1 (IN IN_DATE VARCHAR(20))
BEGIN
insert into ked50d1_h 
select b.KEDCD
      ,IN_DATE
      ,b.ENP_NM
      ,b.ENP_NM_TRD
      ,b.ENP_NM_ENG
      ,b.ENP_TYP
      ,b.ENP_SZE
      ,b.GRDT_PLN_DT
      ,b.ENP_FCD
      ,b.ESTB_FCD
      ,b.ENP_SCD
      ,b.ENP_SCD_CHG_DT
      ,b.PUBI_FCD
      ,b.VENP_YN
      ,b.ENP_FORM_FR
      ,b.BZC_CD
      ,b.FS_BZC_CD
      ,b.GRP_CD
      ,b.GRP_NM
      ,b.CONO_PID
      ,b.ESTB_DT
      ,b.IPO_CD
      ,b.TRDBZ_RPT_NO
      ,b.LIST_DT
      ,b.DLIST_DT
      ,b.MTX_BNK_CD
      ,b.MTX_BNK_NM
      ,b.OVD_TX_BNK_CD
      ,b.OVD_TX_BNK_NM
      ,b.ACCT_EDDT
      ,b.HPAGE_URL
      ,b.EMAIL
      ,b.STD_DT
      ,b.BZNO
      ,b.LOC_ZIP
      ,b.LOC_ADDRA
      ,b.LOC_ADDRB
      ,b.TEL_NO
      ,b.FAX_NO
      ,b.LABORER_SUM
      ,b.PD_NM
      ,b.KSIC9_BZC_CD
      ,b.REL_KEDCD
      ,b.REL_ESTB_DT
      ,b.LOC_RDNM_ZIP
      ,b.LOC_RDNM_ADDRA
      ,b.LOC_RDNM_ADDRB
      ,b.LOC_RDNM_ADDRB_CONF_YN
      ,b.LOC_ADDRB_CONF_YN
  from corp_info_main a
      inner join
       ked50d1 b
      on b.kedcd = a.KED_CODE 
    on duplicate key
update enp_nm = b.enp_nm;

END $$
DELIMITER ;