# Complex Fern types

```swift
cd sdks/swift && swift run
```

## Generate Swift

```bash
FERN_NO_VERSION_REDIRECTION=true node ../fern/packages/cli/cli/dist/prod/cli.cjs generate --log-level debug --local --group swift-local

# Experimental without Fern CLI
FERN_NO_VERSION_REDIRECTION=true node ../fern/generators/swift/sdk-runner/dist/cli.cjs generate
```

## Generate Python

```bash
FERN_NO_VERSION_REDIRECTION=true node ../fern/packages/cli/cli/dist/prod/cli.cjs generate --log-level debug --local --group python-local
```
