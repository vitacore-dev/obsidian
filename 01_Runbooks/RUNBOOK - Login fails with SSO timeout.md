---
title: "Login fails with SSO timeout"
owner: "support-l2"
last_updated: "2026-04-15"
product_version: ">= 2.4.0"
tags: [runbook, auth, sso]
---

## Symptoms

- User sees `SSO authentication timeout` on login screen.
- Repeated login attempts fail after redirect to IdP.
- In support logs, auth flow ends without token exchange completion.

## Scope

- Product/version: `2.4.0+`
- Environment: cloud, all regions
- Identity providers: mostly Azure AD and Okta

## Diagnosis

1. Confirm the incident is not global:
   - Check current status page and incident channel.
2. Validate customer-side clock and timezone:
   - Large time drift can break OAuth/OIDC token validation.
3. Validate IdP callback URL:
   - Compare customer-configured redirect URI against tenant settings.
4. Check auth service logs by tenant:
   - Look for timeout between `authorize_redirect` and `token_exchange`.
5. Reproduce with support test account in affected tenant:
   - Capture timestamp and request ID for escalation if needed.

## Resolution / Workaround

1. Ask customer admin to verify IdP redirect URI exactly matches:
   - `https://app.company.tld/auth/callback`
2. Ask customer admin to reduce conditional access friction temporarily:
   - Disable extra prompt only for a short verification window.
3. If clock drift is found:
   - Sync NTP on customer IdP side or user endpoint.
4. Retry login and confirm token exchange success in logs.

## Escalation

Escalate if:

- Timeout persists after redirect URI and time sync checks.
- Affected users > 20 or VIP customer impacted.
- Error rate spike is visible across multiple tenants.

Escalate to:

- Team: `Engineering On-call (Auth)`
- Channel: `#inc-auth`
- Include: tenant ID, request IDs, timestamps (UTC), IdP type.

