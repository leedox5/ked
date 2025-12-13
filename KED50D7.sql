-- KED50D7 : 경영진주요정보
DROP TABLE IF EXISTS KED50D7;

CREATE TABLE KED50D7 (
    KEDCD        VARCHAR(10)  NOT NULL COMMENT '기업식별ID',
    PCD          VARCHAR(10)  NOT NULL COMMENT '인물식별ID',
    STD_DT       CHAR(8)      NOT NULL COMMENT '최종 입력된 정보의 기준일자(YYYYMMDD)',

    NAME         VARCHAR(40)  NULL     COMMENT '경영진 성명',
    PID          VARCHAR(13)  NULL     COMMENT '경영진 주민등록번호',

    MNGR_CCD     VARCHAR(2)   NULL     COMMENT '경영진구분코드(코드클래스:0007)',
    REG_YN       CHAR(1)      NULL     COMMENT '경영진의 등기 여부(Y/N/null)',
    ASMP_DT      CHAR(8)      NULL     COMMENT '경영진 취임일자 또는 인정일자(YYYYMMDD)',
    RTRD_DT      CHAR(8)      NULL     COMMENT '경영진 퇴임일자 또는 인정일자(YYYYMMDD)',
    PO_YN        CHAR(1)      NULL     COMMENT '해당기업 유직 여부(Y/N/null)',

    TTL          VARCHAR(30)  NULL     COMMENT '경영진에게 부여된 직위명',
    CHRG_BZ      VARCHAR(50)  NULL     COMMENT '기업내 경영진 담당업무',

    WK_PRD       SMALLINT UNSIGNED NULL COMMENT '해당기업 근무년수(년)',
    SBZC_EG_YCN  SMALLINT UNSIGNED NULL COMMENT '동업계 종사연수 년수부분(년)',
    SBZC_EG_MCN  SMALLINT UNSIGNED NULL COMMENT '동업계 종사연수 월수부분(월)',

    MDM_REL_CD   VARCHAR(2)   NULL     COMMENT '경영실권자와의 관계코드(코드클래스:0006)',

    CSTK_OWN     BIGINT UNSIGNED NULL COMMENT '보통주 보유주식수(주)',
    PSTK_OWN     BIGINT UNSIGNED NULL COMMENT '우선주 보유주식수(주)',
    SO_REG_CN    BIGINT UNSIGNED NULL COMMENT '스톡옵션 부여주식수(주)',

    RMK          VARCHAR(200) NULL     COMMENT '경영진에 대한 특이사항',

    PRIMARY KEY (KEDCD, PCD, STD_DT)
) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_0900_ai_ci
  COMMENT='KED50D7 경영진주요정보';
