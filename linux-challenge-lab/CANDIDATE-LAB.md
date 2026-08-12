# Linux Operations Challenge: Recover the Blog Server

**Time limit:** 40 minutes  
**Challenges:** 3  
**Maximum score:** 100 points  
**Recommended pass mark:** 70 points

## Scenario

You are the Linux operator for a static blog. A deployment window has gone badly:

1. SSH logs show repeated failed logins and a later successful login.
2. The shared publishing directory has unsafe permissions.
3. The operations team needs an automated health report before publishing can resume.

Work only inside this lab repository. Root access and network access are not required.

## Start the exam

When this lab opens in GitHub Codespaces, setup runs automatically. Wait for the **RCW LINUX CHALLENGE LAB IS READY** message, then open a new terminal. The terminal starts in `linux-challenge-lab/`, and `candidate-work/` is already prepared.

Save every answer in `candidate-work/`. You may use `man`, `--help`, and normal command-line tools, but do not edit anything under `assets/` or `scripts/`.

Only if you intentionally need to reset the exam, run:

```bash
./scripts/setup.sh
```

This deletes and recreates all work under `candidate-work/`.

---

## Challenge 1 — Trace the SSH Intruder (30 points, 10 minutes)

The file `assets/auth.log` contains a short SSH authentication log.

Use Linux text-processing commands such as `grep`, `awk`, `sort`, `uniq`, `head`, or `cut` to determine:

1. Which source IP produced the largest number of `Failed password` events?
2. How many failed-password events came from that IP?
3. Which account did that IP target most often?
4. What is the timestamp of the first successful (`Accepted`) login from that same IP? Use the format `MMM DD HH:MM:SS`, for example `Aug 12 09:07:05`.

Save your answers in `candidate-work/answers.env` with exactly these variable names:

```text
Q1_IP=
Q1_FAILED_COUNT=
Q1_TOP_ACCOUNT=
Q1_FIRST_SUCCESS=
```

Do not add quotes around values. Also paste the main command pipeline(s) you used into `candidate-work/log-commands.txt`.

Check your result:

```bash
./scripts/verify-logs.sh
```

**Scoring:** IP 8, count 7, account 7, timestamp 6, command evidence 2.

---

## Challenge 2 — Secure the Publishing Workspace (30 points, 10–12 minutes)

The directory `candidate-work/shared/` is used by a publishing team, but its current modes are unsafe and inconsistent.

Repair it to meet all requirements:

1. Every directory at or below `candidate-work/shared/` must have mode **2775**.
   - Owner and group can read, write, and enter.
   - Others can read and enter but cannot write.
   - The setgid bit ensures new items inherit the directory group.
2. Every content file inside `drafts/` and `published/` must have mode **0664**.
3. `candidate-work/shared/secret.env` must have mode **0640**.
4. No content file should be executable.
5. Do not delete or rename any file.

Use efficient commands; you should not need to run `chmod` separately for every file. Save the commands you used in:

```text
candidate-work/permissions-commands.txt
```

Check your repair:

```bash
./scripts/verify-permissions.sh
```

**Scoring:** directory modes 12, content-file modes 10, secret mode 5, command evidence 3.

---

## Challenge 3 — Build a Health-Check Script (40 points, 15–18 minutes)

Create this executable script:

```text
candidate-work/healthcheck.sh
```

It must accept exactly two arguments:

```bash
./candidate-work/healthcheck.sh SERVICES_CSV DISKS_CSV
```

### Input formats

The services file contains `service,status` rows. Blank lines and lines beginning with `#` must be ignored. A service is healthy only when its status is exactly `active`.

```text
nginx,active
blog-api,failed
```

The disk file contains `mount,integer_percent` rows. Blank lines and lines beginning with `#` must be ignored. A filesystem is a warning only when usage is **greater than 80**. A value of exactly 80 is not a warning.

```text
/,62
/var,86
```

### Required output

Print exactly four lines:

```text
BLOG HEALTH REPORT
CRITICAL services: LIST_OR_none
WARNING filesystems: LIST_OR_none
RESULT: PASS_OR_WARN_OR_FAIL
```

Rules:

- Lists must be comma-separated, contain no spaces, and be sorted alphabetically.
- Print `none` when a list is empty.
- `RESULT: FAIL` if one or more services are unhealthy.
- Otherwise, `RESULT: WARN` if one or more filesystems exceed 80%.
- Otherwise, `RESULT: PASS`.
- Exit `2` for FAIL, `1` for WARN, and `0` for PASS.
- With the wrong number of arguments, print a useful `Usage:` line to standard error and exit nonzero.
- Your solution must parse the supplied files; do not hard-code names from the sample data.

Test with the supplied evidence:

```bash
./candidate-work/healthcheck.sh assets/services.csv assets/disks.csv
printf 'exit=%s\n' "$?"
```

Then run the automated behavioral checks:

```bash
./scripts/verify-healthcheck.sh
```

**Scoring:** parsing and filtering 12, exact report 10, sorting/threshold 6, exit codes 6, argument handling 3, executable/readable code 3.

---

## Final submission

Confirm that these files exist:

```text
candidate-work/answers.env
candidate-work/log-commands.txt
candidate-work/permissions-commands.txt
candidate-work/healthcheck.sh
```

Run the complete checker:

```bash
./scripts/verify-all.sh
```

The verifier is a feedback tool; the instructor awards points according to the rubric, including partial credit and command quality.
