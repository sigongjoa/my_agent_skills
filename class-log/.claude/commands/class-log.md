# /class-log — 수업 리뷰 기록

수업 직후 강사의 자유로운 메모를 받아 구조화된 JSON으로 저장합니다.

## STEP 1 — 학생 이름 확인

아래 문구를 출력하세요:

> **학생 이름:**

사용자가 이름을 입력하면 다음 단계로 넘어가세요.

## STEP 2 — 자유 리뷰 입력 받기

아래 문구를 그대로 출력하세요:

---
**오늘 수업 어땠어요? 자유롭게 말해주세요.**
*(뭘 했는지, 잘 됐는지, 막힌 건, 숙제, 다음에 뭐 해야 할지 — 생각나는 대로)*

---

## STEP 3 — 파싱 & 구조화

입력된 자유 텍스트를 바탕으로 JSON을 만드세요.

**기본 뼈대:**
```json
{
  "date": "YYYY-MM-DD",
  "student": "이름",
  "subject": "수학 (단원명)",
  "topic": "오늘 다룬 내용",
  "understanding": 3,
  "good": ["잘 된 것"],
  "stuck": ["막힌 것"],
  "homework": "complete | partial | none | unknown",
  "next_focus": "다음 수업 집중 포인트",
  "notes": "수업 맥락 요약",
  "raw": "원문 그대로"
}
```

**그 외 필드는 맥락에 따라 자유롭게 추가하세요.**
예: `session_type`, `action_items`, `teaching_insight`, `homework_detail`, `teaching_principle`, `schedule_design` 등
내용이 있을 때만 포함하고, 없으면 생략하세요.

**이해도(understanding) 추론 — 1~5 정수:**
- "잘 함", "이해했어", "빠르게 습득" → 4~5
- "반반", "어느 정도", "끝엔 됐음" → 3
- "막힘", "어려워함", "실수 많음", "모름" → 1~2
- 언급 없으면 → 3

**숙제(homework) 추론:**
- "다 함", "완료", "빨리 끝냄" → `"complete"`
- "일부", "반만" → `"partial"`
- "안 해옴", "미완" → `"none"`
- 언급 없으면 → `"unknown"`

**강사 자기성찰 메모인 경우:**
`"type": "self_reflection"`, `"subject": "강사 자기성찰"`, `"understanding": null`

## STEP 4 — 저장

파일 경로: `class-log/data/reviews/YYYY-MM-DD_학생명.json`
같은 날짜·같은 학생 파일이 이미 있으면 `_2`, `_3` suffix.
`Write` 도구로 저장, 들여쓰기 2칸.

## STEP 5 — 확인 출력

```
저장 완료 → class-log/data/reviews/2026-03-03_민수.json

학생    민수
과목    수학 · 이차방정식 판별식
이해도  ★★★☆☆
잘된것  공식 암기 완료
막힌것  적용 조건 구분 (D>0/D=0/D<0)
숙제    완료
다음    판별식 사용 조건 집중
```

이해도는 별(★)로 표시. `action_items`가 있으면 아래 추가:
```
할일    [ ] 숙제 로그 만들기
```

---

## 파싱 예시

**입력 1 (짧은 메모):**
> 민수 이차방정식 판별식, 공식은 아는데 언제 쓰는지 모름. 숙제 빨리 끝냄. 다음엔 조건 구분.

→ understanding: 2 / homework: "complete" / stuck: ["적용 조건 구분 모름"]

---

**입력 2 (교수법 인사이트 포함):**
> 학생A, 기호로 풀어줬더니 학생은 케이스 나눠서 풀더라. 학생 방식도 유효한 사고임. 피드백 루프 더 강화 필요.

→ `teaching_insight` 필드 추가 (student_approach / direction 채움)

---

**입력 3 (강사 자기성찰):**
> 홍길동 수업 얘기 아니고 내 얘긴데, 숙제를 즉흥으로 내줘서 뭘 냈는지 모름. 내 1원칙이 내가 먼저 풀어봐야 시킨다인데 못 지키고 있음.

→ type: "self_reflection" / subject: "강사 자기성찰" / understanding: null
