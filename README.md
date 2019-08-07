# hext

It can be tempting to keep all GHC extensions in your stack.yaml or cabal file but many haskell tools don't have integrations with build tools like stack and cabal, and thus would break if they don't see an explicit language pragma at the start of the file.

Hext alows you to mainain a single list of GHC extensions and automatically apply them to every file.

Create a `.hext.yaml` file and put it into your project directory:

```yaml
- src:
  - src
  - tests
  - app

  extensions:
  - OverloadedStrings
  - NoImplicitPrelude
  - TypeApplications
  - DeriveGeneric
  - DeriveAnyClass
  - RecordWildCards
```

You can create multiple groups with different GHC extensions.
