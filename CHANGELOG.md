# CHANGELOG

## main

- Fixes the `4xx` error not correctly handled in `RingCentral.OAuth.get_token/2`.

## v0.2.1

- Fixes potential extra slash in API request URL.

## v0.2.0

⚠️ Rewriting with breaking changes

- Separate HTTP client and data processing into independent parts.
- Make it flexible to use custom HTTP client, default to `Finch`.
- Make it flexible to use custom JSON client, default to `Jason`.
- Make `RingCentral` a unified struct for OAuth and API requests.
- Minimal third-party dependencies.

Please check `docs/guide.md` for new usage guide.

## v0.1.0

Initial release
