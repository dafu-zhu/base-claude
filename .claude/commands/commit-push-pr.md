# Commit, Push, and Create PR

Current status:
```
${{ git status --short }}
```

Recent commits (for message style):
```
${{ git log -5 --oneline }}
```

Current branch: `${{ git branch --show-current }}`

---

Based on the changes above:
1. Stage all relevant changes
2. Write a concise commit message following the repo's style
3. Push to origin
4. Create a PR with clear title and description

If there are no changes to commit, inform me.
