-- KED50D4 : 관계회사
DROP TABLE IF EXISTS KED50D4;

CREATE TABLE KED50D4 (
    KEDCD           VARCHAR(10)  NOT NULL COMMENT '기업식별ID',
    STD_DT          CHAR(8)      NOT NULL COMMENT '최종 입력된 정보의 기준일자(YYYYMMDD)',

    RENP_SEQ        VARCHAR(4)   NOT NULL COMMENT '관계회사 일련번호',
    RENP_NM         VARCHAR(100) NULL     COMMENT '관계회사 기업명',
    CONO_PID        VARCHAR(13)  NULL     COMMENT '법인/주민등록번호',
    RENP_KEDCD      VARCHAR(10)  NULL     COMMENT '관계회사에 부여된 KED코드',

    RENP_REPR_NM    VARCHAR(40)  NULL     COMMENT '관계회사대표자명',
    RENP_ZIP        VARCHAR(6)   NULL     COMMENT '관계회사우편번호',
    RENP_ADDRA      VARCHAR(40)  NULL     COMMENT '관계회사우편번호주소',
    RENP_ADDRB      VARCHAR(60)  NULL     COMMENT '관계회사우편번호이하주소',

    RENP_BZCD_NM    VARCHAR(30)  NULL     COMMENT '관계회사업종',
    RENP_MPD_NM     VARCHAR(50)  NULL     COMMENT '관계회사주요제품',
    RENP_ACCT_DT    CHAR(8)      NULL     COMMENT '자본금증자일 등 기준결산일',

    RENP_CAP        BIGINT UNSIGNED NULL COMMENT '관계기업자본금(천원)',
    RENP_TASET      BIGINT UNSIGNED NULL COMMENT '관계기업총자산(천원)',
    RENP_SALE_AM    BIGINT UNSIGNED NULL COMMENT '관계기업매출액(천원)',
    RENP_CT_NPF     BIGINT UNSIGNED NULL COMMENT '관계기업당기순이익(천원)',

    EQRT            DECIMAL(5,2) NULL COMMENT '관계회사에 대한 지분보유율(%)',

    BUY_AM          BIGINT UNSIGNED NULL COMMENT '관계기업 연간 매입거래액(천원)',
    RENP_BUY_RIPT   DECIMAL(5,2) NULL COMMENT '매입거래액 대비 해당관계회사 매입거래비중(%)',

    SAM             BIGINT UNSIGNED NULL COMMENT '관계기업 직접년도 연간 매출거래액(천원)',
    RENP_SALE_RIPT  DECIMAL(5,2) NULL COMMENT '매출거래액 대비 해당관계회사 매출거래비중(%)',

    PRGN_AM         BIGINT UNSIGNED NULL COMMENT '관계기업 직접년도 연간 지급보증거래액(천원)',
    RENP_BONT_AMT   BIGINT UNSIGNED NULL COMMENT '관계기업 대여 채권 총액(천원)',
    RENP_DEBT_AMT   BIGINT UNSIGNED NULL COMMENT '관계기업 채무 총액(천원)',

    REL_CTT         VARCHAR(100) NULL COMMENT '관계내용 텍스트 기록',

    -- 도로명 주소 (2012.05.02 추가)
    RENP_RDNM_ZIP   VARCHAR(6)   NULL COMMENT '관계회사 도로명우편번호',
    RENP_RDNM_ADDRA VARCHAR(100) NULL COMMENT '관계회사 도로명주소',
    RENP_RDNM_ADDRB VARCHAR(200) NULL COMMENT '관계회사 도로명이하주소',
    RENP_RDNM_ADDRB_CONF_YN CHAR(1) NULL COMMENT '도로명이하주소확인여부(코드클래스:1041)',

    RENP_ADDRB_CONF_YN CHAR(1) NULL COMMENT '관계기업주소확인여부(코드클래스:1041)',

    PRIMARY KEY (KEDCD, STD_DT, RENP_SEQ),
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci
COMMENT='KED50D4 관계회사';
