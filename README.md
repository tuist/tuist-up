# tuist-up

[![tuist-up](https://github.com/tuist/tuist-up/actions/workflows/tuist-up.yml/badge.svg)](https://github.com/tuist/tuist-up/actions/workflows/tuist-up.yml)

`tuist up` was originally a Tuist built-in command to provision environments by reading the requirements in a manifest file `Setup.swift`.
Although convenient for users,
it was removed in Tuist 2.0 because it was distant from the project's core domain.
Moreover,
errors bubbling up from underlying commands made users believe they were Tuist bugs,
and therefore they added up to the triaging and maintenance work.

This repository contains a Swift-powered CLI that provides the same functionality to ease the adoption of Tuist 2.0 for those users that were using `Setup.swift` with Tuist 1.x. Note that this tool uses a `tuist.json` instead of a manifest written in Swift.

### Plugins 2.0

Tuist's long-term plan is to evolve our [plugins](https://github.com/tuist/tuist/discussions/3411) architecture to be able to distribute and install CLI utilities like `tuist-up` directly from Tuist like [Cargo](https://crates.io/) does with [Crates](https://crates.io/).

```bash
# The CLI below is orientative and therefore is subject to change.
tuist install tuist/tuist-up
tuist up
```

## Run tuist-up

You can run `tuist-up` through [Mint](https://github.com/yonaskolb/Mint):

```bash
mint run tuist/tuist-up
```

## up.json specification

```json
[
  {
    "name": "Install Pods",
    "meet": [
      "bundle",
      "exec",
      "pod",
      "install"
    ],
    "is_met": [
      "diff",
      "Podfile.lock", 
      "Pods/Manifest.lock"
    ]
  },
  {
    "name": "Ensure the right version of Xcode is used",
    "meet": [
      "echo", 
      "'Install it through the App Store'"
    ],
    "is_met": [
      "scripts/check_xcode_version.sh"
    ]
  }
]
```