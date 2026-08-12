# Reference Solution

> Instructor-only material. Keep it out of the candidate-facing branch.

## Challenge 1

One possible investigation:

```bash
grep 'Failed password' assets/auth.log \
  | awk '{print $(NF-3)}' \
  | sort \
  | uniq -c \
  | sort -nr
```

This shows the highest-volume source. With that IP saved manually or in a variable:

```bash
ip=203.0.113.77

grep 'Failed password' assets/auth.log \
  | awk -v ip="$ip" '$(NF-3) == ip {print $(NF-5)}' \
  | sort \
  | uniq -c \
  | sort -nr

grep 'Accepted' assets/auth.log \
  | awk -v ip="$ip" '$(NF-3) == ip {print $1, $2, $3; exit}'
```

Expected `candidate-work/answers.env`:

```text
Q1_IP=203.0.113.77
Q1_FAILED_COUNT=7
Q1_TOP_ACCOUNT=deploy
Q1_FIRST_SUCCESS=Aug 12 09:07:05
```

## Challenge 2

One efficient repair:

```bash
find candidate-work/shared -type d -exec chmod 2775 {} +
find candidate-work/shared/drafts candidate-work/shared/published \
  -type f -exec chmod 0664 {} +
chmod 0640 candidate-work/shared/secret.env
```

The leading `2` in `2775` enables setgid. New entries created in those directories inherit the directory's group. Group write supports collaborators, while the final `5` prevents other users from modifying the directory.

## Challenge 3

Reference `candidate-work/healthcheck.sh`:

```bash
#!/usr/bin/env bash
set -u

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 SERVICES_CSV DISKS_CSV" >&2
  exit 64
fi

services_file="$1"
disks_file="$2"

if [[ ! -r "$services_file" || ! -r "$disks_file" ]]; then
  echo "ERROR: both input files must be readable" >&2
  exit 66
fi

critical="$({
  awk -F, '
    function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    { name=trim($1); status=trim($2); if (status != "active") print name }
  ' "$services_file" | sort
} | paste -sd, -)"

warnings="$({
  awk -F, '
    function trim(s) { gsub(/^[[:space:]]+|[[:space:]]+$/, "", s); return s }
    /^[[:space:]]*#/ || /^[[:space:]]*$/ { next }
    { mount=trim($1); usage=trim($2); if (usage + 0 > 80) print mount }
  ' "$disks_file" | sort
} | paste -sd, -)"

[[ -n "$critical" ]] || critical="none"
[[ -n "$warnings" ]] || warnings="none"

result="PASS"
exit_code=0
if [[ "$critical" != "none" ]]; then
  result="FAIL"
  exit_code=2
elif [[ "$warnings" != "none" ]]; then
  result="WARN"
  exit_code=1
fi

printf 'BLOG HEALTH REPORT\n'
printf 'CRITICAL services: %s\n' "$critical"
printf 'WARNING filesystems: %s\n' "$warnings"
printf 'RESULT: %s\n' "$result"
exit "$exit_code"
```

Expected supplied-data result:

```text
BLOG HEALTH REPORT
CRITICAL services: nginx,redis
WARNING filesystems: /srv/blog,/var
RESULT: FAIL
```

Expected exit code: `2`.
