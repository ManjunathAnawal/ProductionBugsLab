# Contributing

Thanks for helping. The easiest ways:

1. **Report a build problem** with the "Build or app problem" issue template.
2. **Suggest a case.** Use the "New case idea" template.
3. **Fix a typo or unclear hint** with a pull request.
4. **Add a case.** Follow `docs/case-template.md`.

## Adding a case (short)

1. Add the bug as `TriageLab/Logic/Lxx_Name.swift` (plain Swift where possible).
2. Add the screen in `TriageLab/CaseViews`.
3. Add the entry in `TriageLab/Catalog/CaseCatalog.swift`.
4. Add `docs/cases/Cxx.md` and a row in `docs/cases.md`.
5. Open a pull request. CI must pass.

## Rules

- Keep the bug intentional, small and realistic.
- One statement per line. Short inline comments. No force unwraps except in the bug itself.
- No personal data, no company or employer material, no copied text from other sites. Paraphrase and link.
- Be kind. See `CODE_OF_CONDUCT.md`.
