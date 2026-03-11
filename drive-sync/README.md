# drive-sync skill

Google Drive에 파일을 업로드하거나 다운로드하는 스킬.

## 스킬 파일

- `.claude/commands/drive-sync.md` — 자연어로 Drive 업로드/다운로드 명령
- `gdrive_tool.py` — 실제 Drive API 호출 Python 스크립트

## 설치

```bash
# 스킬 설치
cp drive-sync/commands/drive-sync.md ~/.claude/commands/
# 또는 프로젝트 로컬
cp drive-sync/commands/drive-sync.md .claude/commands/

# Python 툴 설치
cp drive-sync/gdrive_tool.py <프로젝트>/
pip install google-auth google-auth-oauthlib google-api-python-client
```

## 인증 설정

1. GCP Console에서 OAuth 2.0 클라이언트 ID (데스크톱 앱) 생성
2. `client_secret.json` → `~/.config/gws/client_secret.json` 에 저장
3. 첫 실행 시 브라우저 인증 → 토큰 자동 저장

## 사용법

`/drive-sync` 스킬로 자연어 명령:

- "이루다 증명 폴더 목록 보여줘"
- "전체 PDF 이루다 증명에 올려"
- "log_basic.pdf 김시우 폴더에 올려"
- "log_basic.pdf 다운받아"
