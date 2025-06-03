# window에서는 기본설치가 안됨 -> 도커를 통한 redis 설치
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속
redis-cli

# docker redis 접속명령어
docker exec -it 컨테이너ID /bin/sh 
docker exec -it 컨테이너ID redis-cli

# redis는 0~15번까지의 db로 구성(defaultsms 0번 db)
# db번호 선택
select db번호

# db내 모든 키 조회
keys *

# 가장 일반적인 strings 자료구조

# set을 통해 key-value 세팅
set user1 hong1@naver.com
set user:email:1 hong1@naver.com
set user:email:2 hong2@naver.com
# 기존에 키value가 존재한다면 덮어쓰기됨.
set user:email:1 hong3@naver.com
# key값이 이미 존재하면 pass,없으면 set : nx
set user:email:1 hong4@naver.com nx
# 만료시간(ttl) 설정(초단위) : ex
set user:email:5 hong5@naver.com ex 10
# redis 실전활용: token등 사용자 인증정보 저장 -> 빠른성능활용
set user:1:access_token tkdghks12345 ex 1800
set user:1:refresh_token tkdghks12345 ex 1800

# key를 통해 value get 
get user1
# 특정 key 삭제
del user1
# 현재 db내 모든 key값 삭제
flushdb

# redis실전활용 : 좋아요기능 구현 -> 동시성이슈 해결 (싱글스레드로 인해 해결)
set likes:posting:1 0 #redis는 기본적으로 모든 key:value가 문자열. 내부적으로는 '0'으로 저장.
incr likes:posting:1 #특정 key값의 value를 1만큼 증가
decr likes:posting:1 #특정 key값의 value를 1만큼 감소
# redis실전활용 : 재고관리구현 -> 동시성이슈해결
set stocks:product:1 100
decr stocks:product:1 
incr stocks:product:1 

#redis실전활용: 캐싱기능구현
# 1번 회원 정보 조회 : select name,email.age from member where id=1;
# 위 데이터의 겳과값을  spring서버를 통해 json으로 변형하여, redis에 캐싱
# 최종적인 데이터 형식 : {"name":"hong", "email":"hong@daum.net", "age":30}
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list 자료구조
# redis의 list는 deque와 같은 자료구조 즉 double-ended queue 구조
# lpush 데이터를 list 자료구조에 왼쪽부터 삽입
# rpush 데이터를 list 자료구조에 오른쪽쪽부터 삽입
lpush hongs hong1
lpush hongs hong2

# rpush 데이터를 list 자료구조에 오른쪽쪽부터 삽입
rpush hongs hong3

# list조회 ㅣ 0은 리스트의 시작인덱스를 의미. -1은 리스트의 마지막 인덱스를 의미
lrange hongs 0 -1 # 전체조회
lrange hongs -1 -1 # 마지막값조회
lrange hongs 0 0 # 첫번째값조회
lrange hongs -2 -1 #마지막2번째부터 마지막까지
lrange hongs 0 2 #0번째부터 2번째까지

# list값 꺼네기 pop:꺼내면서 삭제
lpop hongs
rpop hongs
# a리스트에서 rpop하여 b리스트에서 lpush
rpoplpush a리스트 b리스트
rpush abc a1
rpush abc a2
rpush abc b1
rpush abc b2
rpoplpush abc def

# list의 데이터 개수 조회
llen hongs
# ttl 적용
expire hongs 20
# ttl 조회
ttl hongs 

# redis실전활용 : 최근조회한상품목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango

# 최근본상품1개조회
lrange user:1:recent:product -3 -1

# set 자료구조의 특징: 중복없음,순서없음
sadd memberlist a1
sadd memberlist a2
sadd memberlist a3
sadd memberlist a3

# set 조회 
smembers memberlist

# set멤버 개수 조회
scard memberlist

# 특정멤버가 set안에 있는 존재여부 확인
sismember memberlist a2

# redis실전활용: 좋아요 구현
# 게시글상세보기에 들어가면
scard posting:likes:1
sismember posting:likes:1 a1@naver.com
# 게시글에 좋아요를 하면
sadd posing:likes:1 a1@naver.com
# 좋아요한사람 클릭시
smembers posting:likes:1

# zset : sorted set
# zset을 활용해서 최근시간순으로 정렬가능 
# zset도 set이므로 같은 상품을 add할 경우의 중복이 제거되고,score(시간)값만 업데이트
ZADD user:1:recent:product 91330 banana
ZADD user:1:recent:product 91340 apple
ZADD user:1:recent:product 91350 orange
ZADD user:1:recent:product 91351 mango
ZADD user:1:recent:product 91326 apple

# zset조회 : zrange(score기준 오름차순), zrevrange(score기준내림차순)
zrange user:1:recent:product 0 2
zrange user:1:recent:product -3 -1
# withscore를 통해 score값까지 같이 출력
zrevrange user:1:recent:product 0 2 withscores

# 주식시세저장
# 중복:삼성전자, 시세: 55000원 , 시간 : 현재시간(유닉스타임스탬프) -> 년원일시간을 초단위로 변환한것.

zadd stock:price:se 1748911141 55000
zadd stock:price:lg 1748911141 100000
zadd stock:price:se 1748911141 55500
zadd stock:price:lg 1748911141 100000
# 삼성전자의 현재시세
zrevrange stock:price:se 0 0
zrange stock:price:lg -1 -1

# hashes: value가 map형태의 자료구조(key:value, key:value.... 형태의 자료구조)
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" 
hset member:info:1 name hong email hong@naver.com age 30
# 특정값 조회
hget member:info:1 name
# 특정 요소값 수정
hset member:info:1 name hong2
# redis활용상황 : 빈번하고 변경되는 객체값을 찾아서 효율적.

