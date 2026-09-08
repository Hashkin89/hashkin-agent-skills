# hashkin-agent-skills

Backup personnel de tous les agent skills installés (Claude Code / `npx skills`), pour ré-import rapide sur une nouvelle machine.

## Réinstaller sur une nouvelle machine

```bash
npx skills add hashkin89/hashkin-agent-skills --skill <nom-du-skill>
```

Ou copier manuellement `skills/<nom>` dans `~/.agents/skills/` puis créer le lien symbolique :

```bash
ln -s "../../.agents/skills/<nom>" ~/.claude/skills/<nom>
```
