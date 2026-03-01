# research-note skill

현재 대화의 디버깅/연구 과정을 표준 연구노트 형식으로 정리해
**PDF** 생성 및 **GitHub 이슈**로 등록하는 Claude Code 스킬.

## 사용법

```
/research-note                     # 제목 자동 제안
/research-note "에러 제목"          # 제목 직접 지정
```

## 연구노트 섹션 구조

| 섹션 | 내용 |
|------|------|
| Background | 작업 맥락, 무엇을 하다가 문제를 만났는지 |
| Problem Statement | 에러 메시지, 증상, 재현 조건 |
| Investigation | 시도한 것들, 관찰 결과 |
| Solution | 실제 해결 방법 |
| Verification | 테스트 결과, 동작 확인 |
| Root Cause | 근본 원인 분석 |
| Conclusion & Takeaways | 교훈, 예방책, 다음 단계 |
| Related Issues | 관련 GitHub 이슈 번호 |
| References | 링크, 문서 |

## 출력 예시

```
✅ PDF 생성 완료
   복사본: /root/research-note-20260301-debugging.pdf

GitHub 이슈로도 올릴까요? (Y/n)
```

## 설치

### 1. 스킬 파일 복사
```bash
cp -r research-note ~/.claude/skills/
chmod +x ~/.claude/skills/research-note/scripts/build.sh
```

### 2. Typst 템플릿 설치
```bash
mkdir -p ~/.claude/templates
cp ../templates/research-note.typ ~/.claude/templates/
```

### 3. 의존성 확인
```bash
typst --version   # Typst 0.11+
gh --version      # GitHub CLI (이슈 생성 시 필요)
```

## 파일 구조

```
research-note/
  SKILL.md          ← Claude Code 스킬 정의
  README.md         ← 이 파일
  scripts/
    build.sh        ← typst compile 래퍼
```
