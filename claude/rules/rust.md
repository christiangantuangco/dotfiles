---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Conventions

## Style
- Follow official Rust style guide
- Use rustfmt defaults — never override rustfmt.toml settings
- Max line length: 100 chars
- Trailing commas on multi-line lists
- No comments unless explicitly requested

## Naming
- UpperCamelCase for types and traits (acronyms as one word: Uuid, Usize)
- snake_case for functions, variables, modules
- SCREAMING_SNAKE_CASE for constants and statics
- Use get_ prefix on getters, is_ prefix on boolean-returning methods
- Crate names: no -rs or -rust suffix

## Error Handling
- Use anyhow::Result and anyhow::Error everywhere
- Propagate errors with ? operator — avoid manual match on Result unless handling specific variants
- Never panic in library code — panic is acceptable only in main() or tests
- Use .context("message") and .with_context(|| ...) for adding error context

## Types & Ownership
- Derive Debug on all public types
- Prefer &str over String in function parameters when ownership isn't needed
- Prefer &[T] over Vec<T> in function parameters when ownership isn't needed
- Use impl Trait in argument position for single-use generic bounds
- Use Cow<'_, str> when a function may or may not need to allocate

## Structure
- One module per file — avoid inline mod blocks for anything nontrivial
- pub(crate) over pub when the item doesn't need to leave the crate
- Group imports: std, external crates, crate-internal (separated by blank lines)
- #[must_use] on functions returning values that shouldn't be ignored

## Testing
- Tests in a #[cfg(test)] mod tests block at the bottom of the file
- Test function names: snake_case describing the scenario (test_parse_empty_input_returns_error)
- Use assert_eq! and assert!(matches!(...)) over manual if/panic
