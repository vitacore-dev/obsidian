---
title: "Ошибка входа: SSO timeout"
owner: "support-l2"
last_updated: "2026-04-15"
product_version: ">= 2.4.0"
tags: [runbook, auth, sso]
---

## Symptoms

- Пользователь видит `SSO authentication timeout` на экране входа.
- Повторные попытки входа завершаются ошибкой после редиректа на IdP.
- В логах поддержки auth-flow завершается без успешного обмена токеном.

## Scope

- Версия продукта: `2.4.0+`
- Окружение: cloud, все регионы
- Провайдеры идентификации: чаще всего Azure AD и Okta

## Diagnosis

1. Проверить, что это не глобальный инцидент:
   - посмотреть status page и канал инцидентов.
2. Проверить часы и таймзону на стороне клиента:
   - сильный рассинхрон времени ломает валидацию OAuth/OIDC-токенов.
3. Проверить callback URL в IdP:
   - сравнить redirect URI у клиента с настройками tenant.
4. Проверить логи auth-сервиса по tenant:
   - искать timeout между `authorize_redirect` и `token_exchange`.
5. Повторить сценарий на тестовой support-учетке в проблемном tenant:
   - зафиксировать timestamp и request ID для эскалации.

## Resolution / Workaround

1. Попросить администратора клиента проверить точное совпадение IdP redirect URI:
   - `https://app.company.tld/auth/callback`
2. Попросить администратора клиента временно упростить conditional access:
   - отключить дополнительный prompt на короткое окно проверки.
3. Если обнаружен рассинхрон времени:
   - синхронизировать NTP на стороне IdP клиента или endpoint пользователя.
4. Повторить вход и подтвердить успешный token exchange в логах.

## Escalation

Эскалировать, если:

- Timeout сохраняется после проверок redirect URI и синхронизации времени.
- Затронуто более 20 пользователей или VIP-клиент.
- Видна вспышка ошибок сразу по нескольким tenant.

Эскалировать в:

- Команда: `Engineering On-call (Auth)`
- Канал: `#inc-auth`
- Передать: tenant ID, request ID, timestamp (UTC), тип IdP.

