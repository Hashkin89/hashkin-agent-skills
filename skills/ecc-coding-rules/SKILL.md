---
name: ecc-coding-rules
description: Language and framework-specific coding standards (style, testing, security, performance, patterns) for TypeScript, JavaScript/web, React, Python, Go, Rust, Java, Kotlin, Swift, C#, C++, PHP, Ruby, Dart, Vue, Angular, Nuxt, React Native, F#, Perl, ArkTS. Use when writing or reviewing code in any of these languages/frameworks to check style, testing, and security conventions.
---

# ECC Coding Rules

Reference set of language and framework-specific standards, extracted from the ECC project (github.com/affaan-m/ECC, MIT license) — kept as a standalone reference skill rather than the full ECC harness, to avoid duplicating the existing workflow skill set (TDD, code-review, security-and-hardening, etc. already installed).

## Usage

Before writing or reviewing code in a given language, check `rules/common/*.md` (always-applicable: coding style, testing, security, performance, patterns, git workflow) plus the language/framework-specific folder under `rules/<name>/`.

## Available stacks

`rules/common` (always applicable) + one or more of:

angular, arkts, cpp, csharp, dart, fsharp, golang, java, kotlin, nuxt, perl, php, python, react, react-native, ruby, rust, swift, typescript, vue, web

Each folder contains a subset of: `coding-style.md`, `testing.md`, `security.md`, `performance.md`, `patterns.md`, `hooks.md`, `design-quality.md` — only the files relevant to that stack exist.

For a web/TypeScript/React project, check `common`, `typescript`, `web`, and `react` together.
