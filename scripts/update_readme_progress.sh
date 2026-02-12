#!/bin/bash
# README 태스크 상태 자동 업데이트 스크립트
# 커밋 메시지에서 [done:X.X.X], [skip:X.X.X], [wip:X.X.X] 태그를 파싱하여
# README.md의 체크박스 상태를 변경하고 진행률을 재계산합니다.
#
# 사용법:
#   ./scripts/update_readme_progress.sh "feat: 기능 구현 [done:1.3.1]"
#
# 지원 태그:
#   [done:X.X.X] - 태스크 완료 (체크박스 [x])
#   [skip:X.X.X] - 태스크 스킵 (체크박스 [-])
#   [wip:X.X.X]  - 태스크 진행 중 (체크박스 [~])

set -euo pipefail

README="README.md"
COMMIT_MSG="${1:-}"

if [ -z "$COMMIT_MSG" ]; then
  echo "Usage: $0 <commit-message>"
  exit 1
fi

if [ ! -f "$README" ]; then
  echo "ERROR: $README not found"
  exit 1
fi

UPDATED=false

# macOS(BSD sed)와 Linux(GNU sed)의 -i 옵션 차이 처리
sed_inplace() {
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$@"
  else
    sed -i "$@"
  fi
}

# 커밋 메시지에서 태그 파싱 (여러 개 지원: [done:1.3.1] [skip:2.1.1])
parse_and_update() {
  local tag="$1"    # done, skip, wip
  local marker="$2" # x, -, ~ 등

  while IFS= read -r task_id; do
    [ -z "$task_id" ] && continue

    escaped_id=$(echo "$task_id" | sed 's/\./\\./g')

    if grep -qE "^- \[.\] \*\*${escaped_id} " "$README"; then
      sed_inplace -E "s/^- \[.\] (\*\*${escaped_id} )/- [${marker}] \1/" "$README"
      echo "  [${tag}] ${task_id}"
      UPDATED=true
    else
      echo "  WARNING: Task ${task_id} not found in README"
    fi
  done < <(echo "$COMMIT_MSG" | grep -oE "\[${tag}:[0-9]+(\.[0-9]+)*\]" | sed -E "s/\[${tag}:([0-9]+(\.[0-9]+)*)\]/\1/")
}

echo "Parsing commit message..."
parse_and_update "done" "x"
parse_and_update "skip" "-"
parse_and_update "wip"  "~"

# 마일스톤 이름 조회
get_milestone_name() {
  case "$1" in
    1) echo "계산기 화면 완성" ;;
    2) echo "환율 로직 구현" ;;
    3) echo "오프라인 대응" ;;
    4) echo "테스트 코드" ;;
    *) echo "Unknown" ;;
  esac
}

# 마일스톤 테이블 행 업데이트
update_milestone_count() {
  local num="$1"
  local done="$2"
  local all="$3"
  local name
  name=$(get_milestone_name "$num")

  sed_inplace -E "s/\| ${num}\. [^|]+ \| [0-9]+개 \| [0-9]+\/[0-9]+ \|/| ${num}. ${name} | ${all}개 | ${done}\/${all} |/" "$README"
}

# 진행률 재계산
update_progress() {
  if [ "$UPDATED" = false ]; then
    echo "No task tags found in commit message. Skipping."
    exit 0
  fi

  echo "Updating progress..."

  local total_done=0
  local total_all=0
  local milestone_num=0
  local current_done=0
  local current_all=0
  local in_milestone=false

  while IFS= read -r line; do
    # 마일스톤 헤더 감지
    if echo "$line" | grep -qE "^### 마일스톤 [0-9]+"; then
      if [ "$in_milestone" = true ]; then
        update_milestone_count "$milestone_num" "$current_done" "$current_all"
      fi
      milestone_num=$(echo "$line" | grep -oE "[0-9]+" | head -1)
      current_done=0
      current_all=0
      in_milestone=true
      continue
    fi

    # 태스크 요약 테이블에 도달하면 마일스톤 파싱 종료
    if echo "$line" | grep -qE "^### 태스크 요약"; then
      if [ "$in_milestone" = true ]; then
        update_milestone_count "$milestone_num" "$current_done" "$current_all"
      fi
      in_milestone=false
      continue
    fi

    # 체크박스 라인 카운트 (- [.] **숫자 패턴만)
    if [ "$in_milestone" = true ]; then
      if echo "$line" | grep -qE "^- \[.\] \*\*[0-9]"; then
        current_all=$((current_all + 1))
        total_all=$((total_all + 1))
        if echo "$line" | grep -qE "^- \[x\] "; then
          current_done=$((current_done + 1))
          total_done=$((total_done + 1))
        fi
      fi
    fi
  done < "$README"

  # 합계 행 업데이트
  sed_inplace -E "s/\| \*\*합계\*\* \| \*\*[0-9]+개\*\* \| \*\*[0-9]+\/[0-9]+\*\* \|/| **합계** | **${total_all}개** | **${total_done}\/${total_all}** |/" "$README"

  # 진행률 배지 업데이트
  if [ "$total_all" -gt 0 ]; then
    local percent=$((total_done * 100 / total_all))
  else
    local percent=0
  fi

  local color="red"
  if [ "$percent" -ge 80 ]; then
    color="brightgreen"
  elif [ "$percent" -ge 50 ]; then
    color="yellow"
  elif [ "$percent" -ge 20 ]; then
    color="orange"
  fi

  local badge_value="${total_done}%2F${total_all}_(${percent}%25)"
  # 배지가 포함된 전체 라인을 치환 (URL 내 괄호로 인한 패턴 깨짐 방지)
  sed_inplace "s|.*V1_Progress-.*|![Progress](https://img.shields.io/badge/V1_Progress-${badge_value}-${color})|" "$README"

  echo "  Progress: ${total_done}/${total_all} (${percent}%)"
}

update_progress
echo "Done!"
