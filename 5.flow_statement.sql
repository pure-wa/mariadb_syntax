-- 흐름제어 :case when,if,ifnull
-- if(a,b,c): a조건 이 참이면 b반환 , 그렇지 않으면 c를 반환.

select id, if(name is null, "익명 사용자",name) from author;

-- limit(a,b) : a가 null이면 b를 반환 , null아니면 a를 그대로 반환
select id, ifnull(name,'익명사용자')from author;

select id, 
case 
    when name is null then '익명사용자' 
    when name ='hong' then '홍길동'
    else name
end 
from author

-- 경기도에 위치한 식품창고 목록 출력하기
-- 조건에 부합하는 중고거래 상태 조회하기
-- 12세 이하인 여자 환자 목록 출력하기