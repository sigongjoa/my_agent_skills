# proof-workbook skill

수학 증명 워크북을 Typst로 생성하고 PDF로 컴파일하는 스킬.

## 스킬 파일

- `.claude/commands/new-proof-sheet.md` — 새 증명 워크북 .typ 파일 생성
- `.claude/commands/compile-proof.md` — .typ → PDF 컴파일

## 설치

```bash
cp proof-workbook/commands/*.md ~/.claude/commands/
# 또는 프로젝트 로컬
cp proof-workbook/commands/*.md .claude/commands/
cp proof-workbook/proof_lib.typ <프로젝트>/
```

## 사용법

- `/new-proof-sheet` — 수학 공식 증명 워크북 생성
- `/compile-proof` — Typst 파일 컴파일
