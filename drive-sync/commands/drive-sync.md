# Google Drive 동기화 스킬

Google Drive의 원하는 폴더에 파일을 올리거나 내려받습니다.
Python 툴: `/mnt/g/mathesis/proof_workbook/gdrive_tool.py`

## 지원 기능

| 요청 예시 | 실행 명령 |
|-----------|-----------|
| "증명 폴더 목록 보여줘" | `list --folder-name "이루다/증명"` |
| "전체 PDF 이루다 증명에 올려" | `upload --all-pdf --folder-name "이루다/증명"` |
| "log_basic.pdf 김시우 폴더에 올려" | `upload log_basic.pdf --folder-name "김시우/증명"` |
| "/home/user/file.pdf 를 시후에 올려" | `upload /home/user/file.pdf --folder-name "윤시후"` |
| "drive 폴더 구조 보여줘" | `folders` |
| "log_basic.pdf 다운받아" | `download log_basic.pdf --folder-name "이루다/증명"` |
| "~/Downloads 에 저장해줘" | `download 파일명 --dest ~/Downloads` |

## 실행

```bash
python3 /mnt/g/mathesis/proof_workbook/gdrive_tool.py <명령> [옵션]
```

### 폴더 지정 방법 (택 1)
```bash
--folder-name "학생 교제/이루다/증명"   # 이름 경로 (슬래시 구분)
--folder 1qzJkJk6pIXpq8sxxvigk...      # Drive 폴더 ID
# 둘 다 생략 시 기본값: 이루다/증명
```

### 예시
```bash
# 현재 워크북 PDF 전체 → 이루다/증명
python3 gdrive_tool.py upload --all-pdf --folder-name "학생 교제/이루다/증명"

# 특정 파일 → 다른 학생 폴더
python3 gdrive_tool.py upload log_basic.pdf --folder-name "학생 교제/김시우/증명"

# 임의 경로 파일 업로드
python3 gdrive_tool.py upload /tmp/test.pdf --folder-name "이루다/증명"

# 폴더 목록 확인
python3 gdrive_tool.py list --folder-name "이루다"

# Drive 전체 폴더 구조 보기
python3 gdrive_tool.py folders

# 파일 다운로드 (기본: workdir)
python3 gdrive_tool.py download log_basic.pdf --folder-name "이루다/증명"

# 다운로드 경로 지정
python3 gdrive_tool.py download log_basic.pdf --dest ~/Downloads
```

## 인증

- 토큰 자동 재사용: `~/.config/gws/drive_token.json`
- 만료 시 자동 갱신
- 토큰 없을 시: **WSL 터미널에서 직접 실행** → 브라우저 인증 → 이후 자동

## $ARGUMENTS 처리

사용자 요청에서 파일명, 폴더명, 경로를 파악해서 위 명령으로 변환하여 실행하세요.
파일명 없이 "올려줘"만 하면 `--all-pdf` 사용.
