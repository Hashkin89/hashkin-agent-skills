# hashkin-agent-skills

Backup personnel de tous les agent skills installés (Claude Code / `npx skills`), pour ré-import rapide sur une nouvelle machine.

## Installer toutes les skills d'un coup

```bash
npx skills add hashkin89/hashkin-agent-skills
```

Si la commande n'installe qu'une partie ou rien (selon la convention attendue par la CLI `skills` au moment où tu l'utilises), passer par la méthode manuelle ci-dessous — elle marche à coup sûr.

## Installer une skill précise

```bash
npx skills add hashkin89/hashkin-agent-skills --skill <nom-du-skill>
```

## Méthode manuelle (fallback garanti)

```bash
git clone https://github.com/Hashkin89/hashkin-agent-skills.git
mkdir -p ~/.agents/skills
cp -r hashkin-agent-skills/skills/* ~/.agents/skills/
mkdir -p ~/.claude/skills
for d in ~/.agents/skills/*/; do
  name="$(basename "$d")"
  ln -sf "../../.agents/skills/$name" ~/.claude/skills/"$name"
done
```

## Tenir le backup à jour

Depuis ce repo :

```bash
./scripts/sync.sh
```

Ça synchronise `~/.agents/skills/` vers `skills/` dans ce repo, commit et push automatiquement. À relancer après chaque nouvelle skill installée ou supprimée.
