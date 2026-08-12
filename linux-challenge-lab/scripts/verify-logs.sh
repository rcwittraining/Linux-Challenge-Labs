#!/usr/bin/env bash
set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
answer_file="$repo_root/candidate-work/answers.env"
commands_file="$repo_root/candidate-work/log-commands.txt"

if [[ ! -f "$answer_file" ]]; then
  echo "FAIL: Run ./scripts/setup.sh and complete candidate-work/answers.env first."
  exit 1
fi

value_for() {
  local key="$1"
  awk -F= -v wanted="$key" '
    $1 == wanted {
      value = substr($0, index($0, "=") + 1)
      sub(/\r$/, "", value)
      print value
      exit
    }
  ' "$answer_file"
}

hash_value() {
  printf '%s' "$1" | sha256sum | awk '{print $1}'
}

check_hash() {
  local label="$1" actual="$2" expected_hash="$3"
  if [[ -n "$actual" && "$(hash_value "$actual")" == "$expected_hash" ]]; then
    printf 'PASS: %s\n' "$label"
    return 0
  fi
  printf 'FAIL: %s\n' "$label"
  return 1
}

failures=0
check_hash "source IP" "$(value_for Q1_IP)" "0c25434b09c62046f88142b1412b949ea7e9bc61479d71b2b74ab8dbc3d2d946" || ((failures+=1))
check_hash "failed count" "$(value_for Q1_FAILED_COUNT)" "7902699be42c8a8e46fbbb4501726517e86b22c56a189f7625a6da49081b2451" || ((failures+=1))
check_hash "top account" "$(value_for Q1_TOP_ACCOUNT)" "b7bd55c11b781b0ccc43aa6e57f9dadf0660e9d1d4e27e0979ee43a407d454ae" || ((failures+=1))
check_hash "first successful-login timestamp" "$(value_for Q1_FIRST_SUCCESS)" "b2063ed151fb8fa5190fb4419e42e2a00a4dfafddfd67ac6f3d7bf99b83b0474" || ((failures+=1))

if [[ -s "$commands_file" ]]; then
  echo "PASS: command evidence is present"
else
  echo "FAIL: candidate-work/log-commands.txt is empty"
  ((failures+=1))
fi

if (( failures == 0 )); then
  echo "Challenge 1 verification: PASS"
  exit 0
fi
printf 'Challenge 1 verification: FAIL (%d check(s))\n' "$failures"
exit 1
