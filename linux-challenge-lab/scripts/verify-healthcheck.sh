#!/usr/bin/env bash
set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
script="$repo_root/candidate-work/healthcheck.sh"

if [[ ! -f "$script" ]]; then
  echo "FAIL: candidate-work/healthcheck.sh does not exist."
  exit 1
fi
if [[ ! -x "$script" ]]; then
  echo "FAIL: candidate-work/healthcheck.sh is not executable."
  exit 1
fi

failures=0
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

run_case() {
  local label="$1" services="$2" disks="$3" expected_status="$4" expected_output="$5"
  local output status
  set +e
  output="$($script "$services" "$disks" 2>&1)"
  status=$?
  set -e

  if [[ "$status" -ne "$expected_status" ]]; then
    printf 'FAIL: %s returned %d; expected %d\n' "$label" "$status" "$expected_status"
    ((failures+=1))
    return
  fi
  if [[ "$output" != "$expected_output" ]]; then
    printf 'FAIL: %s output did not match the required report.\n' "$label"
    printf '%s\n' '--- actual ---' "$output" '--- expected ---' "$expected_output"
    ((failures+=1))
    return
  fi
  printf 'PASS: %s\n' "$label"
}

cat > "$tmp/healthy-services.csv" <<'EOF'
# all healthy
zeta,active

alpha,active
EOF
cat > "$tmp/healthy-disks.csv" <<'EOF'
/,80
/data,12
EOF

cat > "$tmp/warn-services.csv" <<'EOF'
worker,active
EOF
cat > "$tmp/warn-disks.csv" <<'EOF'
/var,99
/tmp,81
/edge,80
EOF

run_case \
  "supplied FAIL data" \
  "$repo_root/assets/services.csv" \
  "$repo_root/assets/disks.csv" \
  2 \
  $'BLOG HEALTH REPORT\nCRITICAL services: nginx,redis\nWARNING filesystems: /srv/blog,/var\nRESULT: FAIL'

run_case \
  "generated PASS data and comments" \
  "$tmp/healthy-services.csv" \
  "$tmp/healthy-disks.csv" \
  0 \
  $'BLOG HEALTH REPORT\nCRITICAL services: none\nWARNING filesystems: none\nRESULT: PASS'

run_case \
  "generated WARN data, sorting, and 80-percent boundary" \
  "$tmp/warn-services.csv" \
  "$tmp/warn-disks.csv" \
  1 \
  $'BLOG HEALTH REPORT\nCRITICAL services: none\nWARNING filesystems: /tmp,/var\nRESULT: WARN'

set +e
"$script" >"$tmp/noargs.stdout" 2>"$tmp/noargs.stderr"
noargs_status=$?
set -e
if (( noargs_status == 0 )); then
  echo "FAIL: no-argument invocation must return nonzero"
  ((failures+=1))
elif grep -q 'Usage:' "$tmp/noargs.stderr"; then
  echo "PASS: argument validation"
else
  echo "FAIL: no-argument invocation must print Usage: to standard error"
  ((failures+=1))
fi

if (( failures == 0 )); then
  echo "Challenge 3 verification: PASS"
  exit 0
fi
printf 'Challenge 3 verification: FAIL (%d check(s))\n' "$failures"
exit 1
