# class-log & test-gen Skills

수업 기록 자동화 + 학생 맞춤 시험지 생성 시스템

## Skills

### `/class-log`
수업 직후 강사의 자유로운 메모를 구조화된 JSON으로 저장합니다.

```
/class-log
→ 학생 이름 입력
→ 수업 내용 자유 입력
→ JSON 자동 파싱 & 저장 (class-log/data/reviews/YYYY-MM-DD_학생명.json)
```

### `/test-gen`
이전 시험 날짜 이후의 class-log 데이터를 분석하여 학생 맞춤 수학 시험지를 생성합니다.

```
/test-gen [학생명] [문항수] [이전시험날짜]

예시:
/test-gen 학생A 20 2026-03-01
```

**흐름:**
1. 이전 시험 날짜 이후 로그 파싱
2. 약점 맵 추출 (stuck / weaknesses / understanding 기반)
3. 우선순위별 문제 생성 (고/중/저 우선 → 배점 자동 계산)
4. 강사 검토 화면 출력
5. 승인 후 Typst PDF 생성 (시험지 + 정답지)

## 파일 구조

```
class-log/
├── .claude/commands/
│   ├── class-log.md      ← /class-log skill
│   └── test-gen.md       ← /test-gen skill
├── templates/
│   ├── wawa-exam.typ     ← 5지선다 시험지 Typst 라이브러리
│   └── exam-example.typ  ← 사용 예시
└── README.md
```

## 시험지 디자인

- Typst 기반 출판 수준 PDF
- 5지선다 (①②③④⑤) 수능 스타일
- 학원 브랜딩 (헤더/푸터 자동 포함)
- 시험지 + 강사용 정답지 별도 생성

## 의존성

- [Typst](https://typst.app) 0.14+
- Noto Sans CJK KR 폰트
