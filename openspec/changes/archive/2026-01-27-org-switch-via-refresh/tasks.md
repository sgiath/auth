## 1. Refresh Flow Updates

- [x] 1.1 Change refresh route to POST-only and update `Controller.refresh/2` to read POST params
- [x] 1.2 Extend `SgiathAuth.refresh_session` to accept optional params and forward `organization_id` to WorkOS
- [x] 1.3 Store `org_id` in session from WorkOS refresh response on success
- [x] 1.4 Add LiveView refresh hook example (client POST with `return_to`) in docs

## 2. Failure Handling

- [x] 2.1 Preserve current refresh failure behavior (clear session, unauthenticate)
- [x] 2.2 Add test coverage for POST refresh with valid/invalid `organization_id` and GET rejection if tests exist

## 3. Documentation

- [x] 3.1 Document POST-only refresh and org switching via refresh in `README.md`
- [x] 3.2 Include a POST form + JS hook example with CSRF token and `return_to` in `README.md`
- [x] 3.3 Update `usage-rules.md` with POST-only note, LiveView hook pattern, and example params (`organization_id`, `return_to`)
