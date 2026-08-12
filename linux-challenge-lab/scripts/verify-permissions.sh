#!/usr/bin/env bash
set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
shared="$repo_root/candidate-work/shared"
evidence="$repo_root/candidate-work/permissions-commands.txt"

if [[ ! -d "$shared" ]]; then
  echo "FAIL: Run ./scripts/setup.sh first."
  exit 1
fi

failures=0
checked_dirs=0
checked_content=0

while IFS= read -r -d '' path; do
  ((checked_dirs+=1))
  mode="$(stat -c '%a' "$path")"
  if [[ "$mode" != "2775" ]]; then
    printf 'FAIL: directory %s has mode %s; expected 2775\n' "${path#"$repo_root/"}" "$mode"
    ((failures+=1))
  fi
done < <(find "$shared" -type d -print0)

for content_dir in "$shared/drafts" "$shared/published"; do
  while IFS= read -r -d '' path; do
    ((checked_content+=1))
    mode="$(stat -c '%a' "$path")"
    if [[ "$mode" != "664" ]]; then
      printf 'FAIL: content file %s has mode %s; expected 664\n' "${path#"$repo_root/"}" "$mode"
      ((failures+=1))
    fi
  done < <(find "$content_dir" -type f -print0)
done

secret="$shared/secret.env"
if [[ ! -f "$secret" ]]; then
  echo "FAIL: candidate-work/shared/secret.env is missing"
  ((failures+=1))
else
  secret_mode="$(stat -c '%a' "$secret")"
  if [[ "$secret_mode" != "640" ]]; then
    printf 'FAIL: secret.env has mode %s; expected 640\n' "$secret_mode"
    ((failures+=1))
  fi
fi

if [[ -s "$evidence" ]]; then
  echo "PASS: command evidence is present"
else
  echo "FAIL: candidate-work/permissions-commands.txt is empty"
  ((failures+=1))
fi

if (( failures == 0 )); then
  printf 'Challenge 2 verification: PASS (%d directories, %d content files)\n' "$checked_dirs" "$checked_content"
  exit 0
fi
printf 'Challenge 2 verification: FAIL (%d check(s))\n' "$failures"
exit 1
