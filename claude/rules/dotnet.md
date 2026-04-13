---
paths:
  - "**/*.cs"
  - "**/*.csproj"
  - "**/*.sln"
---
# C# Conventions

## Structure & Patterns
- File-scoped namespaces
- One type per file, filename matches type name
- Prefer records for DTOs and value objects
- Repository pattern for data access
- Use IOptions<T> pattern for configuration
- Use MediatR/CQRS pattern if already present in the project — don't introduce it otherwise
- Prefer dependency injection over static helpers

## Null Handling
- Nullable reference types enabled (<Nullable>enable</Nullable>)
- Always check for null using pattern matching (is null / is not null)
- Never use == null or != null
- Use required keyword on properties that must be set

## Async
- Use CancellationToken in async methods that do I/O
- Suffix async methods with Async
- Never use .Result or .Wait() — always await
- Prefer ValueTask over Task for hot paths that often complete synchronously

## Documentation
- XML doc comments on ALL public types, methods, and properties
- Always include <summary>, <param>, <returns>, and <exception> tags where applicable
- Document parameter constraints and valid ranges in <param> tags

## Formatting
- Max line length: 200 chars
- Indentation: 4 spaces
- Primary constructors where appropriate
- Prefer pattern matching (switch expressions, is patterns)
- Prefer explicit types over var when the type isn't obvious
- Use collection expressions ([]) where supported

## Error Handling
- Use Result pattern or throw specific exceptions — never throw bare Exception
- Use guard clauses (ArgumentNullException.ThrowIfNull) at method entry
- Log exceptions with structured logging (ILogger), not Console.Write
