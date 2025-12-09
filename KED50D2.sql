CREATE TABLE KED50D2 (
    -- 기본 식별자
    KEDCD           VARCHAR(10)  NOT NULL COMMENT '기업식별ID',
    PCD             VARCHAR(10)  NOT NULL COMMENT '인물식별ID',
    STD_DT          CHAR(8)      NOT NULL COMMENT '정보 기준일자(YYYYMMDD)',

    -- 기본 인적 정보
    NAME            VARCHAR(40)           COMMENT '대표자 성명',
    PID             VARCHAR(13)           COMMENT '대표자 주민등록번호',

    -- 대표자 구분/표시 여부
    REPER_CCD       VARCHAR(2)            COMMENT '대표자 유형 구분코드',
    MRK_REPER_YN    CHAR(1)               COMMENT '표시대표자 여부(Y/N)',

    -- 취임/퇴임/현직 여부
    ASMP_DT         CHAR(8)               COMMENT '취임일자 또는 인정일자(YYYYMMDD)',
    RTRR_DT         CHAR(8)               COMMENT '퇴임일자 또는 인정일자(YYYYMMDD)',
    PO_YN           CHAR(1)               COMMENT '현직 여부(Y/N/NULL)',

    -- 직위 및 경영형태
    TTL             VARCHAR(30)           COMMENT '직위명',
    MNG_FCD         VARCHAR(2)            COMMENT '경영형태코드',

    -- 동업계 종사 경력(년/월)
    SBZC_EG_YCN_REPER SMALLINT            COMMENT '동업계 종사연수_대표자 기준(년)',
    SBZC_EG_MCN_REPER SMALLINT            COMMENT '동업계 종사연수_대표자 기준(월)',
    SIND_EG_PRD_YY    SMALLINT            COMMENT '동업계 종사기간(년)',
    SIND_EG_PRD_MM    SMALLINT            COMMENT '동업계 종사기간(월)',

    -- 평가/관계 코드
    SBZC_EVL_CD     VARCHAR(2)            COMMENT '동업계 평가코드',
    MDM_REL_CD      VARCHAR(2)            COMMENT '경영실권자와의 관계코드',
    REPER_MABL_CD   VARCHAR(2)            COMMENT '경영능력 코드',

    -- 주식/소득 정보
    CSTK_OWN        BIGINT                COMMENT '보통주 보유주식수(주)',
    PSTK_OWN        BIGINT                COMMENT '우선주 보유주식수(주)',
    SO_REG_CN       BIGINT                COMMENT '소득등록 건수(건)',

    -- 비고
    RMK             VARCHAR(200)          COMMENT '비고(특이사항)',

    PRIMARY KEY (KEDCD, PCD, STD_DT)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COMMENT = 'KED50D2 대표자 정보';
