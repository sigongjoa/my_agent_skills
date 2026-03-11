# 증명 워크북 Typst 컴파일

`/mnt/g/mathesis/proof_workbook/` 디렉토리의 `.typ` 파일을 PDF로 컴파일합니다.

## Arguments 처리

- `$ARGUMENTS`가 없으면: 모든 .typ 파일 컴파일 (proof_lib.typ 제외)
- `$ARGUMENTS`에 파일명이 있으면: 해당 파일만 컴파일 (확장자 생략 가능)
- `$ARGUMENTS`가 `--all`이면: 모든 .typ 파일 컴파일

## 실행

### 특정 파일
```bash
cd /mnt/g/mathesis/proof_workbook && typst compile [파일명].typ
```

### 전체 컴파일
```bash
cd /mnt/g/mathesis/proof_workbook && for f in *.typ; do
  [ "$f" = "proof_lib.typ" ] && continue
  typst compile "$f" && echo "✅ ${f%.typ}.pdf" || echo "❌ $f 에러"
done
```

## 에러 처리

실패 시:
1. 에러 메시지 분석
2. `unknown variable` → `#import "proof_lib.typ": *` 확인
3. 괄호 불일치 → 해당 줄 수정
4. 수정 가능하면 자동 수정 후 재컴파일
5. 결과를 표로 출력

## 출력 형식

```
✅ odd_root_negative.pdf
✅ negative_rational_exponent.pdf
✅ sample_v3.pdf
```
