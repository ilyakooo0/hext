# hext

It can be tempting to keep all GHC extensions in your stack.yaml or cabal file but many haskell tools don't have integrations with build tools like stack and cabal, and thus would break if they don't see an explicit language pragma at the start of the file.

Hext alows you to mainain a single list of GHC extensions and automatically apply them to every file.

Create a `.hext.yaml` file and put it into your project directory:

```yaml
- src:
  - src
  - tests
  - app

  line_limit: 100

  extensions:
  - OverloadedStrings
  - NoImplicitPrelude
  - TypeApplications
  - DeriveGeneric
  - DeriveAnyClass
  - RecordWildCards
  - ScopedTypeVariables
  - LambdaCase
```

You can create multiple groups with different GHC extensions.

`line_limit` can be abset, indicating that every extensions should be on its own line, a positive int or `none`, indicating that all extensions should be placed on one lines.
