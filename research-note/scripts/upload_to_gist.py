#!/usr/bin/env python3
"""
research-note 스킬용 PDF → Gist 업로드 스크립트

흐름:
  1. PDF → PNG 변환 (PyMuPDF)
  2. PNG들을 GitHub Gist에 업로드
  3. 이슈에 임베드할 마크다운 반환
"""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path


def convert_pdf_to_png(pdf_path: str, output_dir: str, max_pages: int = 5) -> list[str]:
    """PDF 페이지들을 PNG로 변환."""
    try:
        import fitz  # PyMuPDF
    except ImportError:
        print("⚠️  PyMuPDF 없음. 설치: pip install pymupdf", file=sys.stderr)
        return []

    pdf_path = Path(pdf_path)
    if not pdf_path.exists():
        print(f"⚠️  파일 없음: {pdf_path}", file=sys.stderr)
        return []

    os.makedirs(output_dir, exist_ok=True)
    doc = fitz.open(str(pdf_path))
    n = min(max_pages, len(doc))
    print(f"📄 PDF {len(doc)}페이지 → {n}페이지 PNG 변환 중...")

    png_files = []
    for i in range(n):
        page = doc[i]
        mat = fitz.Matrix(2.0, 2.0)  # 2x 해상도
        pix = page.get_pixmap(matrix=mat)
        out_path = os.path.join(output_dir, f"page_{i+1:02d}.png")
        pix.save(out_path)
        size_kb = os.path.getsize(out_path) // 1024
        print(f"  ✅ 페이지 {i+1} → {out_path} ({size_kb}KB)")
        png_files.append(out_path)

    doc.close()
    return png_files


def upload_to_gist(png_files: list[str], title: str) -> dict[str, str]:
    """PNG 파일들을 GitHub Gist에 업로드하고 raw URL 딕셔너리 반환."""
    if not png_files:
        return {}

    # gh 설치 확인
    result = subprocess.run(["gh", "--version"], capture_output=True)
    if result.returncode != 0:
        print("⚠️  GitHub CLI(gh) 없음.", file=sys.stderr)
        return {}

    desc = f"Research Note: {title}"
    print(f"\n📤 Gist 업로드 중: {len(png_files)}개 파일...")

    # gh gist create로 업로드
    cmd = ["gh", "gist", "create", "--public", "--desc", desc] + png_files
    result = subprocess.run(cmd, capture_output=True, text=True)

    if result.returncode != 0:
        print(f"⚠️  Gist 업로드 실패:\n{result.stderr}", file=sys.stderr)
        return {}

    # Gist URL에서 ID 추출
    # 출력 예: https://gist.github.com/sigongjoa/abc123def456
    gist_url = result.stdout.strip()
    gist_id = gist_url.rstrip("/").split("/")[-1]

    # 로그인 유저명 가져오기
    user_result = subprocess.run(
        ["gh", "api", "user", "--jq", ".login"],
        capture_output=True, text=True
    )
    username = user_result.stdout.strip() if user_result.returncode == 0 else "user"

    print(f"  ✅ Gist 생성: {gist_url}")

    # raw URL 구성
    urls = {}
    for path in png_files:
        filename = Path(path).name
        raw_url = f"https://gist.githubusercontent.com/{username}/{gist_id}/raw/{filename}"
        urls[filename] = raw_url
        print(f"  🖼️  {filename}: {raw_url}")

    return urls


def build_issue_body(
    content_md: str,
    image_urls: dict[str, str],
    gist_url: str = "",
) -> str:
    """GitHub 이슈 본문 생성 (Markdown 내용 + PDF 이미지 임베드)."""

    image_section = ""
    if image_urls:
        lines = ["\n---\n", "## 📄 Research Note PDF\n"]
        for filename, url in image_urls.items():
            page_num = filename.replace("page_", "").replace(".png", "")
            lines.append(f"### Page {page_num}\n")
            lines.append(f"![{filename}]({url})\n")
        if gist_url:
            lines.append(f"\n> 원본 Gist: {gist_url}\n")
        image_section = "\n".join(lines)

    return content_md + image_section


def main():
    parser = argparse.ArgumentParser(description="Research Note PDF → Gist 업로드")
    parser.add_argument("--pdf",     required=True,  help="업로드할 PDF 파일 경로")
    parser.add_argument("--title",   default="Research Note", help="노트 제목")
    parser.add_argument("--pages",   type=int, default=5, help="변환할 최대 페이지 수")
    parser.add_argument("--content", default="", help="이슈 본문 Markdown (선택)")
    parser.add_argument("--output",  default="/tmp/issue_body.md", help="최종 이슈 본문 저장 경로")
    parser.add_argument("--no-upload", action="store_true", help="업로드 건너뛰기 (로컬 PNG만)")

    args = parser.parse_args()

    # 1. PDF → PNG
    tmp_dir = f"/tmp/research_note_pages"
    png_files = convert_pdf_to_png(args.pdf, tmp_dir, args.pages)

    if not png_files:
        print("❌ PNG 변환 실패")
        sys.exit(1)

    if args.no_upload:
        print(f"\n📁 로컬 PNG 저장 완료:")
        for f in png_files:
            print(f"  - {f}")
        sys.exit(0)

    # 2. Gist 업로드
    urls = upload_to_gist(png_files, args.title)

    # Gist URL 재조회
    gist_url = ""
    if urls:
        sample_raw = list(urls.values())[0]
        # https://gist.githubusercontent.com/user/ID/raw/file → https://gist.github.com/user/ID
        parts = sample_raw.split("/")
        gist_url = f"https://gist.github.com/{parts[3]}/{parts[4]}"

    # 3. 이슈 본문 생성
    body = build_issue_body(args.content, urls, gist_url)

    with open(args.output, "w", encoding="utf-8") as f:
        f.write(body)

    print(f"\n{'='*60}")
    print(f"✅ 이슈 본문 저장: {args.output}")
    print(f"{'='*60}")
    print(f"\n다음 명령으로 이슈 생성:")
    print(f'  gh issue create --title "[Research Note] {args.title}" \\')
    print(f'    --body "$(cat {args.output})" \\')
    print(f'    --label "research-note"')


if __name__ == "__main__":
    main()
