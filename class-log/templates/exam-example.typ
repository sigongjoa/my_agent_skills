#import "wawa-exam.typ": *

#show: conf.with(
  student: [학생A],
  subject: [수학],
  date: [2026년 3월],
  exam-name: [정기고사],
)

#title-page(
  student: [학생A],
  subject: [수학],
  date: [2026. 3. 14.],
  exam-name: [정기고사],
  time-limit: [50분],
  total-marks: [100점],
  instructor: [홍길동],
)

#section[객관식 (1~5번 | 각 12점)]

#mcq(
  score: 12,
  [$log_2 32$의 값을 구하여라.],
  [3],
  [4],
  [*5*],
  [6],
  [7],
)

#mcq(
  score: 12,
  [$log_2 6 + log_2 display(2/3)$ 의 값을 구하여라.],
  [0],
  [1],
  [*2*],
  [3],
  [4],
)

#mcq(
  score: 12,
  [$log_3 (x - 1) = 2$를 만족하는 $x$의 값을 구하여라.],
  [6],
  [8],
  [9],
  [*10*],
  [11],
)

#mcq(
  score: 12,
  [1부터 10까지의 자연수 중 임의로 하나를 뽑을 때, 3의 배수도 아니고 5의 배수도 아닐 확률을 구하여라.],
  [$display(1/5)$],
  [$display(3/10)$],
  [$display(2/5)$],
  [$display(1/2)$],
  [$display(3/5)$],
)

#mcq(
  score: 12,
  [주머니에 빨간 공 3개, 파란 공 2개가 있다. 공을 한 개 꺼냈더니 빨간 공이었다. 이 공을 다시 넣지 않고 한 개 더 꺼낼 때, 빨간 공이 나올 확률을 구하여라.],
  [$display(1/5)$],
  [$display(1/4)$],
  [$display(2/5)$],
  [$display(1/2)$],
  [$display(3/5)$],
)

#section[단답형 (6~8번 | 각 10점)]

#saq(
  score: 10,
  lines: 5,
  [$U = {1, 2, 3, 4}$일 때, $A subset B subset U$이고 $A eq.not emptyset$인 순서쌍 $(A, B)$의 개수를 구하여라.],
)

#saq(
  score: 10,
  lines: 4,
  [서로 다른 공 3개를 서로 다른 상자 2개에 넣는 방법의 수를 구하여라. (단, 빈 상자가 있어도 된다.)],
)

#saq(
  score: 10,
  lines: 5,
  [10명 중 남학생 6명, 여학생 4명이 있다. 대표 2명을 뽑을 때, 적어도 한 명이 여학생일 확률을 구하여라.],
)

#section[서술형 (9~10번 | 각 5점)]

#saq(
  score: 5,
  lines: 3,
  [5명을 일렬로 세우는 방법의 수를 구하여라.],
)

#saq(
  score: 5,
  lines: 3,
  [주사위를 한 번 던질 때, 4 이상의 눈이 나올 확률을 구하여라.],
)
