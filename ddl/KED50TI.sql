DROP TABLE IF EXISTS KED50TI;

CREATE TABLE KED50TI (
    BASE_DT         CHAR(8)      NOT NULL COMMENT 'DB수집일자',
    BZNO            VARCHAR(10)  NOT NULL COMMENT '사업자등록번호',
    CONO            VARCHAR(13)  NULL COMMENT '법인번호',

    ENP_NM          VARCHAR(100) NULL COMMENT '인증기관 사이트에서 제공하는 기업명',
    REPR_NM         VARCHAR(50)  NULL COMMENT '인증기관 사이트에서 제공하는 대표자명',

    CERBT_STD_DT    CHAR(8)      NULL COMMENT '인증지표작성일자',
    CERBT_XPIR_DT   CHAR(8)      NULL COMMENT '인증만료일자',
    CERBT_CAN_DT    CHAR(8)      NULL COMMENT '인증취소일자',

    KODATA_UPD_DT   CHAR(8)      NULL COMMENT 'KoDATA 작업일자',

    CONO_BAD_INFO   VARCHAR(2)   NULL COMMENT '법인번호 신용불량정보 결과(코드:1)',
    BZNO_BAD_INFO   VARCHAR(2)   NULL COMMENT '사업자번호 신용불량정보 결과(코드:1)',
    CO_REG_INFO     VARCHAR(2)   NULL COMMENT '법인등기등록 상태(코드:2)',
    LGDT_INFO       VARCHAR(2)   NULL COMMENT '국세청 휴폐업 조회 정보(코드:3)',

    KODATACD        VARCHAR(10)  NOT NULL COMMENT 'KoDATA 기업식별ID(구 KED코드)',
    KODATA_ENP_NM   VARCHAR(100) NULL COMMENT 'KoDATA DBA 기업명',
    KODATA_REPER_NM VARCHAR(50)  NULL COMMENT 'KoDATA DBA 대표자명',

    LOC             VARCHAR(6)   NULL COMMENT '우편번호',
    ADDR1           VARCHAR(200) NULL COMMENT '기초 구역 주소(1순위:도로명, 2순위:지번)',
    ADDR2           VARCHAR(200) NULL COMMENT '상세 주소(1순위:도로명, 2순위:지번)',
    TEL_NO          VARCHAR(20)  NULL COMMENT '본점 전화번호',

    ESTB_DT         CHAR(8)      NULL COMMENT '법인 설립일자 또는 개인기업 개업일자',

    ASET_T_SUM      BIGINT UNSIGNED NULL COMMENT '재무상태표 자산총액(천원)',
    LIAB_T_SUM      BIGINT UNSIGNED NULL COMMENT '재무상태표 부채총액(천원)',
    SAM             BIGINT UNSIGNED NULL COMMENT '손익계산서 매출액(천원)',
    BZPF            BIGINT UNSIGNED NULL COMMENT '손익계산서 영업이익(천원)',
    NPFCT           BIGINT UNSIGNED NULL COMMENT '손익계산서 당기순이익(천원)',
    RND_MP          BIGINT UNSIGNED NULL COMMENT '기업설립 시 사용중인 연구개발비(천원)',

    ACCT_DT         CHAR(8)      NULL COMMENT '재무제표 결산기준일',
    BZC_CD          VARCHAR(6)   NULL COMMENT '표준산업분류코드(2017년 7월 기준 10차)',

    PRIMARY KEY (BASE_DT, BZNO)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci
COMMENT='KED50TI 메인비즈인증기업';
