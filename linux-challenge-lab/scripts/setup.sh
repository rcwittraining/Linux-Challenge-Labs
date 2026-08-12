#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
work_dir="$repo_root/candidate-work"
source_dir="$repo_root/assets/site-source"

if [[ ! -d "$source_dir" ]]; then
  printf 'ERROR: missing source directory: %s\n' "$source_dir" >&2
  exit 1
fi

rm -rf -- "$work_dir"
mkdir -p -- "$work_dir/shared"
cp -R -- "$source_dir/." "$work_dir/shared/"

# Deliberately unsafe/inconsistent modes for Challenge 2.
find "$work_dir/shared" -type d -exec chmod 0777 {} +
find "$work_dir/shared/drafts" "$work_dir/shared/published" -type f -exec chmod 0755 {} +
chmod 0666 "$work_dir/shared/secret.env"

cat > "$work_dir/answers.env" <<'ANSWERS'
Q1_IP=
Q1_FAILED_COUNT=
Q1_TOP_ACCOUNT=
Q1_FIRST_SUCCESS=
ANSWERS
: > "$work_dir/log-commands.txt"
: > "$work_dir/permissions-commands.txt"

cat <<EOF
Linux challenge workspace created:
  $work_dir

Begin with CANDIDATE-LAB.md.
Re-run this setup script at any time to reset all candidate work.
EOF
