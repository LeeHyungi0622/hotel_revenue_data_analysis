-- Power BI에서 시각화를 하기 전에 우선적으로 2018, 2019, 2020년도의 데이터들을 하나의 테이블로 합쳐야 한다.
-- 임시 테이블로 생성

WITH hotels AS (
SELECT * FROM dbo.['2018$']
UNION
SELECT * FROM dbo.['2019$']
UNION
 SELECT * FROM dbo.['2020$'])


-- ADR은 평균 일일 요금으로, 호텔이 하루에 각 객실에 대해 받는 평균 수익을 측정하는데 사용된다.
-- ADR을 통해서 모든 점유 객실에서 발생하는 평균 요금을 확인할 수 있다.
-- ADR은 점유된 객실당 편균 임대 수익을 계산하는데, 총 객실 수익을 판매된 객실 수로 나눠서 계산하게 됩니다. 
-- (예를들어, 10개의 객실이 있는 호텔에서 5개의 객실을 판매하고, 총 $2000달러의 수익이 난 경우, ADR은 $400이다.

-- 각 연도별(2018, 2019, 2020) 수익의 합계를 비교하기 위해서 아래와 같이 arrival_date_year를 기준으로 그룹화해서 수익의 합을 구한다.
SELECT 
arrival_date_year,
sum((stays_in_week_nights+stays_in_weekend_nights)*adr) AS revenue 
FROM hotels
GROUP BY arrival_date_year;

-- 2018	4885517.05999998
-- 2019	20188409.4000001
-- 2020	14284246.24

-- 2020년은 아직 마감되지 않은 dataset으로, 두 호텔의 종합 수익은 2018~2020까지 점진적으로 성장하고 있음을 확인할 수 있다.

-- 호텔 두 군데를 운영하고 있기 때문에 연도와 호텔을 기준으로 그룹화해서 수익을 확인
SELECT 
arrival_date_year,
hotel,
sum((stays_in_week_nights+stays_in_weekend_nights)*adr) AS revenue 
FROM hotels
GROUP BY arrival_date_year, hotel;

-- 2018	City Hotel	  1764667.57
-- 2019	City Hotel	  10755979.11
-- 2020	City Hotel	  8018122.42999998
-- 2018	Resort Hotel  3120849.49
-- 2019	Resort Hotel  9432430.28999997
-- 2020	Resort Hotel  6266123.80999999

-- 2020년은 아직 마감되지 않은 dataset이기 때문에 두 호텔 모두 2018~2020까지 성장을 하고 있음을 확인할 수 있다.

-- 각 투숙객별 예약 방식에 따른 할인율 정보 테이블과 신청한 식사 정보 테이블을 JOIN하여
-- 전체적으로 데이터를 조회할 수 있도록 하였다.
-- Power BI에 데이터를 Import 할때, 아래의 query 사용

SELECT * FROM hotels
LEFT JOIN dbo.market_segment$
ON hotels.market_segment = market_segment$.market_segment
LEFT JOIN dbo.meal_cost$
ON meal_cost$.meal = hotels.meal

