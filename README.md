# LayoutShowcaseApp

Production-style SwiftUI template that uses:
- `XcodeGen` for project generation
- Swift Package Manager for modularization and dependencies
- Modern SwiftUI layout demos with `#Preview`

## Folder Tree

```text
.
├── LayoutShowcaseApp.xcodeproj
│   ├── project.pbxproj
│   └── xcshareddata
│       └── xcschemes
│           └── LayoutShowcaseApp.xcscheme
├── LayoutShowcaseApp
│   ├── App
│   │   ├── LayoutShowcaseApp.swift
│   │   └── LayoutShowcaseRootView.swift
│   └── Resources
│       └── Assets.xcassets
│           ├── AccentColor.colorset
│           │   └── Contents.json
│           ├── AppIcon.appiconset
│           │   └── Contents.json
│           └── Contents.json
├── Packages
│   ├── LayoutExamplesFeature
│   │   ├── Package.swift
│   │   ├── Sources
│   │   │   └── LayoutExamplesFeature
│   │   │       ├── Demos
│   │   │       │   ├── AnchorPreferenceLayoutDemoView.swift
│   │   │       │   ├── AnyLayoutAdaptationDemoView.swift
│   │   │       │   ├── FlowLayoutDemoView.swift
│   │   │       │   └── ViewThatFitsDashboardDemoView.swift
│   │   │       ├── LayoutExamplesHomeView.swift
│   │   │       └── Layouts
│   │   │           └── ChipFlowLayout.swift
│   │   └── Tests
│   │       └── LayoutExamplesFeatureTests
│   │           └── LayoutExamplesFeatureTests.swift
│   └── SharedUI
│       ├── Package.swift
│       ├── Sources
│       │   └── SharedUI
│       │       ├── DemoCard.swift
│       │       ├── DemoScreen.swift
│       │       └── SelectionChip.swift
│       └── Tests
│           └── SharedUITests
│               └── SharedUITests.swift
├── project.yml
├── LICENSE
└── README.md
```

## Generate and Run

```bash
# 1) Install XcodeGen
brew install xcodegen

# 2) Generate the Xcode project
xcodegen generate

# 3) Open in Xcode
open LayoutShowcaseApp.xcodeproj

# 4) Run from CLI (build verification)
xcodebuild -scheme LayoutShowcaseApp -project LayoutShowcaseApp.xcodeproj -destination 'generic/platform=iOS Simulator' build
```

Then in Xcode, pick an iOS simulator and press `Cmd+R` to launch the app.

## GitHub Actions Screenshot Artifact

- Workflow file: `.github/workflows/ios-screenshots.yml`
- It runs UI tests that open every demo screen and capture PNGs.
- It copies screenshots from the UI test runner container, zips them to `artifacts/layout-screenshots.zip`, and uploads a downloadable artifact named `layout-screenshots`.

## Architecture Notes

- App target: `LayoutShowcaseApp` (SwiftUI app lifecycle)
- Feature module: `LayoutExamplesFeature` (all layout demos + container list)
- Shared module: `SharedUI` (reusable demo scaffolding components)
- Dependencies are managed only via Swift Package Manager (local packages in `Packages/`)
