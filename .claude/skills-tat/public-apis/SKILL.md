---
name: public-apis
description: Find a free public API for a task (weather, currency, movies, sports, etc.) from the public-apis/public-apis list. Use when the user asks for an API, a free data source, or "is there an API for X".
---

# Public APIs

Source: https://github.com/public-apis/public-apis — one README with ~2,100 free APIs grouped by `### Category`. Each row is `| [Name](link) | Description | Auth | HTTPS | CORS |`.

1. Fetch the list: `curl -sL https://raw.githubusercontent.com/public-apis/public-apis/master/README.md`
2. Find the category heading (`### Weather`, `### Currency Exchange`, …) or grep the description for the user's keywords.
3. Prefer rows with `HTTPS = Yes`; prefer `Auth = No` unless the user has a key. Note `CORS` if the call runs in a browser.
4. Recommend 2–3 options with name, link, auth needed, and one example request taken from that API's own docs — never invent endpoints.

The list is community-maintained; some APIs may be dead. Say so, and check the link before building on it.
