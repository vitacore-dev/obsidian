---
title: "pg_hba.conf: доступ к PostgreSQL"
owner: "support-l2"
last_updated: "2026-04-15"
product_version: "all"
tags: [postgresql, config, access]
---

## Описание

`pg_hba.conf` — конфигурационный файл PostgreSQL, который определяет правила подключения клиентов к БД.

## Типичный путь (пример)

- CentOS: `/var/lib/pgsql/12/data`

## Пример правила доступа

Разрешение подключения из подсети `192.168.20.0/24`:

```text
# "local" is for Unix domain socket connections only
local   all             all                             peer
# IPv4 local connections:
host    all             all             192.168.20.0/24 md5
```

## Применение изменений

```sql
SELECT pg_reload_conf();
```

## Связанные материалы

- [[PostgreSQL - базовая админка для поддержки]]
- [[pgAdmin - управление PostgreSQL для поддержки]]
