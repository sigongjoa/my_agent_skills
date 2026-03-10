# /render - 출판물 렌더링

pandoc을 사용하여 완성된 챕터를 다양한 형식으로 렌더링한다.
입력은 반드시 루트의 *-chapter.md 파일이어야 한다.

## 사용법
```
/render [챕터파일] --format [all|pdf|html|epub|docx]
```

## 실행 순서

### 1단계: 파일 확인
- 입력 파일이 존재하는지 확인
- YAML frontmatter (title, author, date, lang) 포함 여부 확인

### 2단계: 포맷별 렌더링

**PDF (XeLaTeX — 한국어 지원 + 컬러 템플릿)**
```bash
pandoc [입력파일] \
  -o [출력명].pdf \
  --pdf-engine=xelatex \
  -V mainfont="Noto Serif CJK KR" \
  -V sansfont="Noto Sans CJK KR" \
  -V monofont="Noto Sans Mono CJK KR" \
  -V fontsize=11pt \
  --include-in-header=templates/textbook-style.tex \
  --toc \
  --number-sections
```

**HTML (독립 실행형)**
```bash
pandoc [입력파일] \
  -o [출력명].html \
  --standalone \
  --toc \
  --mathjax \
  -V lang=ko \
  --css=style.css
```

**EPUB (전자책)**
```bash
pandoc [입력파일] \
  -o [출력명].epub \
  --toc \
  --epub-metadata=metadata.xml
```

**DOCX (편집용)**
```bash
pandoc [입력파일] \
  -o [출력명].docx \
  --toc
```

### 3단계: 출력 파일 확인
각 형식 렌더링 성공/실패 여부를 보고.
실패 시 에러 메시지를 보고 원인 파악 후 재시도.

### 4단계: 결과 보고
생성된 파일 목록과 경로를 사용자에게 알림.

## 출력 위치
`rendered/` 폴더에 저장 (없으면 생성)

## 주의사항
- 한국어 PDF: Noto CJK 폰트 설치 필요 (fonts-noto-cjk)
- 수식: HTML은 MathJax, PDF는 XeLaTeX으로 처리
- PDF 생성 실패 시 --pdf-engine=lualatex 으로 대체 시도
