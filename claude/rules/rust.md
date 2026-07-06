---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
  - "**/Cargo.lock"
---
# Rust Conventions

## Company Standards / Policy
Team-specific mandates. These take precedence over community conventions, including where they deviate from the official Rust API guidelines.

- Never use Display to print or render our own structs/enums in logs, error messages, or other displayed output — do not implement std::fmt::Display on our types for that purpose; expose an explicit conversion method (e.g. as_str(), as_u64()) or format the relevant fields directly at the call site
- No comments unless explicitly requested
- Use get_ prefix on getters, is_ prefix on boolean-returning methods (deviates from Rust API guidelines, which drop the get_ prefix)
- Use anyhow::Result and anyhow::Error everywhere
- Use .context(...) for adding error context — pass a static string or format!() directly; do not use .with_context(|| ...)
- Keep error values generic: messages in Err/anyhow!/bail! (and .context) state the failure category, not specific paths, values, identifiers, or upstream response bodies
- Put the specifics (paths, values, upstream responses) in a log macro (error!/warn!/info!/debug!) at the point of failure — never duplicate the same detailed string in both a log macro and an Err
- All `use` declarations at the top of the file — never inside function bodies or blocks
- clap builder methods: `_cmd` suffix for methods returning Command; `_arg` suffix for methods returning Arg; add the `opt_` prefix only when the argument is optional (not required / has a default) — never on required arguments

## Style
- Follow official Rust style guide
- Use rustfmt defaults — never override rustfmt.toml settings
- Max line length: 100 chars
- Trailing commas on multi-line lists

## Naming
- UpperCamelCase for types and traits (acronyms as one word: Uuid, Usize)
- snake_case for functions, variables, modules
- SCREAMING_SNAKE_CASE for constants and statics
- Crate names: no -rs or -rust suffix

## Error Handling
- Propagate errors with ? operator — avoid manual match on Result unless handling specific variants
- Never panic in library code — panic is acceptable only in main() or tests

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
