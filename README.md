# База знаний техподдержки (Obsidian + GitHub)

Общая база знаний технической поддержки с процессом изменений через GitHub Pull Request.

## Структура

- `01_Runbooks/`
- `02_Known-Issues/`
- `03_Product-FAQ/`
- `04_Integrations/`
- `05_Incidents-Postmortem/`
- `06_Onboarding/`
- `90_Templates/`

## Быстрый старт

1. Прочитать `CONTRIBUTING.md`
2. Создать ветку (`kb/add-...` или `kb/fix-...`)
3. Обновить заметки в Obsidian
4. Открыть PR в `main`

## Онбординг

- Чеклист нового сотрудника: `06_Onboarding/Onboarding Checklist.md`
- Полная инструкция подключения нового инстанса: `06_Onboarding/Инструкция: подключение нового Obsidian-инстанса.md`

## Ежедневный цикл работы

1. В начале задачи:
   - `git checkout main`
   - `git pull --rebase`
   - `git checkout -b kb/add-<topic>` (или `kb/fix-<topic>`)
2. Во время задачи:
   - обновить заметки в Obsidian
   - выполнить commit через плагин Obsidian Git или терминал
3. В конце задачи:
   - `git push -u origin <branch>`
   - открыть PR и запросить ревью
   - после merge вернуться в `main` и подтянуть последние изменения

