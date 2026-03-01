---
name: research-note
description: 현재 대화의 디버깅/연구 과정을 표준 연구노트 형식으로 정리해 PDF 생성 및 GitHub 이슈로 등록한다. "연구노트", "research note", "이슈로 올려줘", "노트 저장", "정리해서 이슈로" 등의 요청 시 사용.
argument-hint: "<제목>" (선택사항 — 생략 시 Claude가 제안)
allowed-tools: Bash, Write, Read
---

# research-note: 연구노트 생성

## 환경 정보
!`date +"%Y-%m-%d"`
!`git remote get-url origin 2>/dev/null || echo "no-remote"`
!`git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "no-branch"`

---

## 실행 순서

### Step 1: 대화 내용 분석 및 섹션 매핑

현재 대화 전체를 읽고 아래 섹션별로 내용을 추출하세요.
각 섹션이 비어있으면 `[]` 로 남겨둡니다 (자동 생략됨).

| 섹션 | 대화에서 찾을 내용 |
|------|------------------|
| `background` | 작업 맥락, 무엇을 하다가 문제를 만났는지 |
| `problem` | 에러 메시지, 증상, 재현 조건 |
| `investigation` | 시도한 것들, 관찰 결과 |
| `solution` | 실제 해결 방법 |
| `verification` | 테스트 결과, 동작 확인 |
| `root-cause` | 근본 원인 분석 |
| `conclusion` | 교훈, 예방책, 다음 단계 |

### Step 2: 제목 결정

- `$ARGUMENTS` 가 있으면 그것을 제목으로 사용
- 없으면 대화 내용을 보고 간결한 제목 3개를 제안하고 사용자가 선택하게 하세요

### Step 3: 메타데이터 결정

대화 내용과 git remote URL을 참고해서:
- `project`: repo 이름 또는 작업 프로젝트명
- `version`: 언급된 버전이 있으면 사용, 없으면 생략
- `tags`: 관련 기술 스택/카테고리 (최대 4개)
- `status`: `solved` / `in-progress` / `blocked` 중 하나
- `related-issues`: 대화에서 언급된 이슈 번호들 (없으면 빈 배열)

### Step 4: Typst 파일 생성

아래 템플릿을 채워서 `/tmp/research-note-YYYYMMDD.typ` 파일을 Write 툴로 생성하세요.
날짜는 위에서 주입된 오늘 날짜를 사용합니다.

**파일 경로**: `/tmp/research-note-[YYYYMMDD]-[slug].typ`
(slug = 제목에서 공백→하이픈, 한글 제거 or 영문 요약)

```typst
#import "/root/.claude/templates/research-note.typ": note

#note(
  title:   "[제목]",
  date:    datetime(year: YYYY, month: MM, day: DD),
  status:  "[solved|in-progress|blocked]",
  tags:    ("[tag1]", "[tag2]"),
  project: "[프로젝트명]",      // 없으면 이 줄 삭제
  version: "[버전]",            // 없으면 이 줄 삭제

  background: [
    [내용 또는 빈칸]
  ],

  problem: [
    [에러 메시지는 ```로 감싸기]
    ```
    [에러 전문]
    ```
  ],

  investigation: [
    [시도들은 *시도 N*: 형식으로]
  ],

  solution: [
    [해결책, 코드는 ```lang 으로 감싸기]
  ],

  verification: [
    [테스트 결과]
  ],

  root-cause: [
    [근본 원인]
  ],

  conclusion: [
    [교훈, 예방책]
  ],

  related-issues: (번호1, 번호2),  // 없으면 이 줄 삭제

  references: [
    [링크나 문서]
  ],
)
```

### Step 5: PDF 컴파일

```bash
~/.claude/skills/research-note/scripts/build.sh [typ파일경로]
```

컴파일 성공 시 PDF 경로를 사용자에게 알려주세요.
실패 시 에러 메시지를 보고 Typst 파일을 수정한 후 재시도하세요.

### Step 6: 출력 선택 (사용자에게 확인)

PDF 생성 완료 후 사용자에게 묻습니다:

> PDF가 생성되었습니다: `[경로]`
> GitHub 이슈로도 올릴까요? (Y/n)

**이슈 생성 선택 시 — PDF → Gist → 이슈 순서로 진행:**

#### 6-1. Markdown 이슈 본문 준비

Typst 내용을 Markdown으로 변환해서 변수로 준비하세요:
- 섹션: `## 🔍 Background` 형식
- 코드블록: ` ```lang ` 유지
- 볼드: `**텍스트**`, 리스트: `- 항목`

#### 6-2. PDF → Gist 업로드 + 이슈 본문 생성

```bash
python3 ~/.claude/skills/research-note/scripts/upload_to_gist.py \
  --pdf [PDF파일경로] \
  --title "[제목]" \
  --pages 5 \
  --content "[Markdown 본문]" \
  --output /tmp/issue_body.md
```

완료 시 `/tmp/issue_body.md` 에 PDF 이미지가 임베드된 최종 본문이 생성됨.

#### 6-3. GitHub 이슈 생성

```bash
gh issue create \
  --repo [owner/repo] \
  --title "[Research Note] [제목]" \
  --body "$(cat /tmp/issue_body.md)" \
  --label "research-note"
```

### 중요 규칙

- 이슈 생성 전 반드시 사용자 확인을 받을 것
- 코드블록은 언어 명시 (` ```python `, ` ```bash ` 등)
- 스크린샷/이미지 경로가 있으면 `#image("경로")` 로 포함
- 섹션이 비면 해당 파라미터 자체를 삭제 (빈 `[]` 말고)
