#!/usr/bin/env bash
set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
verifiers=(
  "$repo_root/scripts/verify-logs.sh"
  "$repo_root/scripts/verify-permissions.sh"
  "$repo_root/scripts/verify-healthcheck.sh"
)

passed=0
failed=0
for verifier in "${verifiers[@]}"; do
  printf '\n=== %s ===\n' "$(basename "$verifier")"
  if "$verifier"; then
    ((passed+=1))
  else
    ((failed+=1))
  fi
done

printf '\n=== Overall verification ===\n'
printf 'Challenges passed: %d/3\n' "$passed"
if (( failed == 0 )); then
  echo "RESULT: PASS"
  exit 0
fi
echo "RESULT: INCOMPLETE"
exit 1
