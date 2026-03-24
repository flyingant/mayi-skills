# Slug Rule

Shared rule for generating file-name-safe slugs from project names. Referenced by skills that produce output files.

## Algorithm

1. Lowercase the input string.
2. Replace spaces and underscores with `-`.
3. Remove all characters except `a-z`, `0-9`, `-`.
4. Collapse repeated `-` into a single `-`.
5. Trim leading and trailing `-`.

## Examples

| Input | Slug |
| --- | --- |
| `Member Portal` | `member-portal` |
| `billing_platform` | `billing-platform` |
| `Order Service v2.0` | `order-service-v20` |
| `--my project--` | `my-project` |
| `CamelCaseApp` | `camelcaseapp` |
