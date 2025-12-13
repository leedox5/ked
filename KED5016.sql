DROP TABLE IF EXISTS KED5016;

CREATE TABLE KED5016 (
    KEDCD           VARCHAR(10)  NOT NULL COMMENT '기업식별ID',
    STD_DT          CHAR(8)      NOT NULL COMMENT '최종 입력된 정보의 기준일자(YYYYMMDD)',

    TTL_CD          VARCHAR(2)   NOT NULL COMMENT '직능직급코드 일련번호(코드클래스:0066)',

    ORDN_MEM        BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 상시근로자(남)(명)',
    ORDN_FEM        BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 상시근로자(여)(명)',
    ORDN_EM         BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 상시근로자(합계)(명)',

    T_YSLRY_MEM     BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 연간총급여(남)(천원)',
    T_YSLRY_FM      BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 연간총급여(여)(천원)',
    T_YSLRY         BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 연간총급여(합계)(천원)',

    AVG_SLR_PE_MEM  BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 연간평균급여(남)(천원)',
    AVG_SLR_PE_FE   BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 연간평균급여(여)(천원)',
    AVG_SLR_PE      BIGINT UNSIGNED NULL COMMENT '해당 직능직급 직전년도 연간평균급여(합계)(천원)',

    AVG_WK_PRD_MEM  DECIMAL(5,2) NULL COMMENT '종업원의 평균근속년수(남)',
    AVG_WK_PRD_FM   DECIMAL(5,2) NULL COMMENT '종업원의 평균근속년수(여)',
    AVG_WK_PRD      DECIMAL(5,2) NULL COMMENT '종업원의 평균근속년수(전체)',

    PRIMARY KEY (KEDCD, STD_DT, TTL_CD)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4
COLLATE=utf8mb4_0900_ai_ci
COMMENT='KED5016 인원현황';
