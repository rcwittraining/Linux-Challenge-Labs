# Linux Operations Challenge Lab

A GitHub-ready, three-challenge Linux practical designed for a **30–45 minute exam**.

## Scenario

A static blog has experienced suspicious SSH activity, unsafe publishing-directory permissions, and service failures. Candidates investigate the evidence, repair the workspace, and automate a health report.

## Exam profile

- **Level:** Intermediate
- **Time limit:** 40 minutes recommended (acceptable range: 30–45 minutes)
- **Challenges:** 3
- **Total:** 100 points
- **Suggested pass mark:** 70 points
- **Environment:** Linux with Bash, GNU `grep`, `awk`, `sort`, `uniq`, `find`, and `stat`
- **Root access:** Not required
- **Network access:** Not required

## Repository layout

```text
linux-challenge-lab/
├── CANDIDATE-LAB.md          # Publish this as the blog/exam page
├── ANSWER-TEMPLATE.md
├── README.md
├── assets/
│   ├── auth.log
│   ├── disks.csv
│   ├── services.csv
│   └── site-source/
├── scripts/
│   ├── setup.sh
│   ├── verify-all.sh
│   ├── verify-logs.sh
│   ├── verify-permissions.sh
│   └── verify-healthcheck.sh
└── instructor/
    ├── INSTRUCTOR-GUIDE.md
    └── SOLUTION.md
```

## Quick start

From the repository root:

```bash
chmod +x scripts/*.sh
./scripts/setup.sh
```

Give candidates `CANDIDATE-LAB.md`, `ANSWER-TEMPLATE.md`, `assets/`, and `scripts/`. The setup command creates `candidate-work/`, where all answers must be saved.

Run all automated checks with:

```bash
./scripts/verify-all.sh
```

## GitHub/blog publishing notes

- `CANDIDATE-LAB.md` is ready to paste into a blog post or render as Markdown.
- Keep `instructor/` in a **private repository or private branch**. Do not publish it with the candidate files.
- For a clean candidate release, omit `instructor/` and protect the default branch during the exam.
- The lab is self-contained, so a blog frontend can link to a ZIP or GitHub release containing the candidate files.

## Resetting the lab

Running setup again deletes and recreates only `candidate-work/`:

```bash
./scripts/setup.sh
```

## Scoring

| Challenge | Topic | Suggested time | Points |
|---|---|---:|---:|
| 1 | SSH log investigation | 10 min | 30 |
| 2 | Permission repair | 10–12 min | 30 |
| 3 | Bash health-check script | 15–18 min | 40 |
| **Total** |  | **35–40 min** | **100** |
