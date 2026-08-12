# Instructor Guide — Linux Operations Challenge

> Keep this directory private. Do not include it in the candidate-facing GitHub branch or blog download.

## Intended audience and duration

This lab targets intermediate Linux learners who already know basic navigation, file viewing, and command execution. The recommended exam window is **40 minutes**, with a reasonable range of **30–45 minutes**.

## Learning objectives

Candidates should be able to:

1. Combine Linux text filters to extract operational facts from SSH logs.
2. Interpret and repair numeric permissions, including the setgid bit.
3. Write a Bash script that parses delimited data, sorts results, formats exact output, and returns meaningful exit codes.

## Delivery procedure

1. Put candidate-facing files in a public or access-controlled GitHub repository.
2. Keep `instructor/` private.
3. Ask candidates to clone/download the repository.
4. Start a 40-minute timer after candidates successfully run `./scripts/setup.sh`.
5. Candidates submit the entire `candidate-work/` directory or commit it to an assigned private branch.
6. Run `./scripts/verify-all.sh`, then grade command quality and partial results manually.

For a proctored or high-stakes exam, do not rely on local verifiers as secure grading. Candidates can inspect any script delivered to them. Run hidden copies of the behavioral tests after submission.

## Scoring rubric

### Challenge 1 — 30 points

| Criterion | Points |
|---|---:|
| Correct source IP | 8 |
| Correct failed-attempt count | 7 |
| Correct most-targeted account | 7 |
| Correct first successful-login timestamp | 6 |
| Useful command evidence, not purely manual counting | 2 |

Partial credit: award up to half for a sound pipeline with a small field-selection or counting mistake.

### Challenge 2 — 30 points

| Criterion | Points |
|---|---:|
| All directories are 2775 | 12 |
| All draft/published content files are 0664 | 10 |
| `secret.env` is 0640 | 5 |
| Efficient command evidence using `find`, symbolic/numeric modes, or equivalent | 3 |

Deduct 2–5 points if a candidate uses unsafe broad recursion and only happens to repair this fixture. Do not award requirement points for files that were deleted to avoid checking.

### Challenge 3 — 40 points

| Criterion | Points |
|---|---:|
| Parses both files and ignores comments/blank lines | 12 |
| Produces the exact four-line report | 10 |
| Alphabetical lists and correct `> 80` threshold | 6 |
| Correct PASS/WARN/FAIL exit codes | 6 |
| Wrong-argument handling and stderr usage message | 3 |
| Executable and reasonably readable/maintainable | 3 |

Partial credit suggestions:

- 5–8 points for parsing only one input correctly.
- 4–6 points for correct results with minor formatting differences.
- 2–4 points for correct status logic but wrong exit numbers.
- No parsing credit if results are hard-coded.

## Pass bands

- **90–100:** Strong operational fluency
- **70–89:** Pass; competent intermediate performance
- **50–69:** Developing; targeted practice recommended
- **Below 50:** Review shell pipelines, permissions, and Bash fundamentals

## Timing intervention

At 20 minutes, announce that candidates should begin Challenge 3 if they have not already done so. At 35 minutes, give a five-minute warning. At 40 minutes, collect submissions; permit up to 45 minutes only if that is your published policy.

## Reset and validation

Reset:

```bash
./scripts/setup.sh
```

Validate a completed candidate workspace:

```bash
./scripts/verify-all.sh
```

A reference completion is documented in `SOLUTION.md`.
