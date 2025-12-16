-- KED50D5 : 사업장
DROP TABLE IF EXISTS KED50D5_H;

CREATE TABLE KED50D5_H (
    KEDCD          VARCHAR(10)  NOT NULL COMMENT '기업식별ID',

    BZPL_CD        VARCHAR(2)   NOT NULL COMMENT '사업장 유형별 구분코드(코드클래스:0035)',
    BZPL_SEQ       VARCHAR(4)   NOT NULL COMMENT '사업장구분코드별 일련번호',

    BZNO           VARCHAR(10)  NULL     COMMENT '해당 사업장 사업자등록번호',
    BZPL_NM        VARCHAR(100) NULL     COMMENT '사업장 명칭',

    M4BZPL_YN      CHAR(1)      NULL     COMMENT '주사업장 여부(Y/N/null)',
    ACTL_WK_YN     CHAR(1)      NULL     COMMENT '해당 사업장의 실제 사업장 영위 여부(Y/N/null)',
    OFBK_ACTL_CCD  CHAR(1)      NULL     COMMENT '공부상등록여부(Y/N/null)',

    LOC_ZIP        VARCHAR(6)   NULL     COMMENT '사업장 소재지 우편번호',
    LOC_ADDRA      VARCHAR(200) NULL     COMMENT '사업장 소재지 우편번호 주소',
    LOC_ADDRB      VARCHAR(200) NULL     COMMENT '사업장 소재지 우편번호 이하 주소',

    TEL_NO         VARCHAR(20)  NULL     COMMENT '사업장 전화번호',
    FAX_NO         VARCHAR(20)  NULL     COMMENT '사업장 팩스번호',
    TAXO_NM        VARCHAR(30)  NULL     COMMENT '해당 사업장 관할세무서명',

    MPD            VARCHAR(100) NULL     COMMENT '사업장 주생산품',

    LOC_CND_CCD    VARCHAR(2)   NULL     COMMENT '사업장 입지조건 구분코드(코드클래스:0049)',
    EP_REV_YN      CHAR(1)      NULL     COMMENT '공해방지시설 보유여부(Y/N/null)',

    INDEP_NM       VARCHAR(50)  NULL     COMMENT '사업장 소재 단지명',
    LOC_CND_ETC    VARCHAR(200) NULL     COMMENT '사업장 기타입지조건',

    LSZE_METR      BIGINT UNSIGNED NULL COMMENT '사업장 대지규모(M2)',
    LSZE_UAR       BIGINT UNSIGNED NULL COMMENT '사업장 대지규모(평)',
    BSZE_METR      BIGINT UNSIGNED NULL COMMENT '사업장 건물규모(M2)',
    BSZE_UAR       BIGINT UNSIGNED NULL COMMENT '사업장 건물규모(평)',

    OWNER          VARCHAR(40)  NULL     COMMENT '사업장 소유자명',
    OWNER_CONO_PID VARCHAR(13)  NULL     COMMENT '사업장 소유자 법인번호 또는 주민등록번호',
    OWNER_REL_CD   VARCHAR(2)   NULL     COMMENT '사업장 소유자와의 관계(코드클래스:0038)',
    OWN_YN         CHAR(1)      NULL     COMMENT '사업장 자가소유여부(Y/N/null)',

    LES_AM         BIGINT UNSIGNED NULL COMMENT '사업장 임차보증금(천원)',
    LES_AM_AM_CD   VARCHAR(2)   NULL     COMMENT '임차보증금금액코드(코드클래스:0048)',

    MMR            BIGINT UNSIGNED NULL COMMENT '사업장 월세금액(천원)',
    MMR_AM_CD      VARCHAR(2)   NULL     COMMENT '월세금액코드(코드클래스:0045)',

    RVOL_YN        CHAR(1)      NULL     COMMENT '사업장 권리침해사실(Y/N/null)',
    MOG_QER_YN     CHAR(1)      NULL     COMMENT '사업장 담보제공여부(Y/N/null)',

    T_SUP_AM       BIGINT UNSIGNED NULL COMMENT '해당 사업장에 대한 설정총액(천원)',
    MOG_CTT        VARCHAR(1000) NULL    COMMENT '사업장에 대한 설정내용(Text)',
    RMK            VARCHAR(200) NULL     COMMENT '사업장에 대한 특이사항',

    STD_DT         CHAR(8)      NOT NULL COMMENT '최종 입력된 정보의 기준일자(YYYYMMDD)',

    -- 도로명 주소(2012.05.02 추가)
    LOC_RDNM_ZIP   VARCHAR(6)   NULL     COMMENT '도로명주소지 우편번호(2012.05.02 추가)',
    LOC_RDNM_ADDRA          VARCHAR(100) NULL COMMENT '도로명소재지 우편번호주소',
    LOC_RDNM_ADDRB          VARCHAR(200) NULL COMMENT '도로명소재지 우편번호이하주소',
    LOC_RDNM_ADDRB_CONF_YN  CHAR(1)      NULL COMMENT '도로명이하주소확인여부(코드클래스:1041)',
    LOC_ADDRB_CONF_YN       CHAR(1)      NULL COMMENT '소재지주소확인여부(코드클래스:1041)',    

    UPDATED   VARCHAR(20)   COMMENT '갱신일',

    PRIMARY KEY (KEDCD, BZPL_CD, BZPL_SEQ)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci
COMMENT='KED50D5_H 사업장 이력';
