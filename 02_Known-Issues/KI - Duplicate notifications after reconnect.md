---
title: "Duplicate notifications after reconnect"
owner: "support-l2"
last_updated: "2026-04-15"
product_version: "2.6.1 - 2.6.3"
tags: [known-issue, notifications, websocket]
---

## Issue Summary

Some users receive duplicate in-app notifications after temporary network reconnect.

## Symptoms

- Same notification appears 2-3 times in UI.
- Browser console may show repeated websocket subscription events.
- Most common after VPN reconnect or laptop wake-up.

## Root Cause

Client reconnect handler in versions `2.6.1-2.6.3` may register duplicate subscriptions before stale channel cleanup completes.

## Workaround

1. Ask user to hard refresh browser tab once.
2. If issue repeats, ask user to log out and log in.
3. For high-impact teams, disable real-time notifications in user preferences and use email channel until patch rollout.

## Permanent Fix Status

- [ ] Planned
- [x] In progress
- [ ] Released

Target fix version: `2.6.4`

## References

- Ticket: `SUP-1842`
- Incident: `INC-2026-04-11-NOTIFY`

