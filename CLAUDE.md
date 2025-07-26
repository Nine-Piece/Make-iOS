# CLAUDE.md - iOS Template Generator Project Guide

This document serves as a comprehensive guide for future Claude instances working with this iOS Template Generator repository.

## Project Overview

This is an iOS app template generator that creates new iOS projects using Tuist with support for both SwiftUI and UIKit. The generator can be installed and used via npm/npx, similar to popular frameworks like Next.js.

### Key Features
- **Tuist-based**: Uses Tuist for modern iOS project generation and management
- **Dual UI Framework Support**: SwiftUI or UIKit with simplified structure
- **SPM Integration**: Pre-configured Swift Package Manager support with popular packages
- **npm Distribution**: Can be installed globally or used via npx
- **Korean Language Support**: All prompts and interactions are in Korean
- **Automatic Configuration**: DEBUG/RELEASE schemes with `.dev` suffix for debug builds

## Installation Methods

### 1. npm/npx (Primary Method)
```bash
npx make-ios my-app
npm init ios-app my-app
yarn create ios-app my-app
pnpm create ios-app my-app
```

### 2. Shell Script Installation
```bash
curl -Ls https://raw.githubusercontent.com/nine-piece/make-ios/main/install.sh | bash
```

### 3. Manual Installation
```bash
git clone https://github.com/nine-piece/make-ios.git
cd make-ios
./setup.sh
```

## Project Structure

```
iOS-Template/
├── bin/
│   └── make-ios.js            # npm/npx CLI entry point
├── scripts/
│   ├── generate_project.sh    # Core project generation script
│   ├── update_dependencies.sh # SPM dependency configuration
│   └── prepare-publish.js     # npm publish preparation
├── templates/
│   ├── common/               # Shared assets (Assets.xcassets)
│   ├── plist/                # Info.plist templates
│   ├── storyboard/           # LaunchScreen.storyboard
│   ├── SwiftUI/              # SwiftUI app template
│   └── UIKit/                # UIKit app template
├── tuist/
│   ├── Project.swift         # Tuist project template
│   └── Config.swift          # Tuist configuration
├── setup.sh                  # Interactive setup script (Korean)
├── install.sh               # GitHub installation script
├── package.json             # npm package configuration
├── README.md                # English documentation
└── README_ko.md             # Korean documentation
```

## Architecture Patterns

### SwiftUI Template
- Standard Apple-recommended SwiftUI architecture
- AppDelegate + SceneDelegate
- ContentView as entry point
- Supports iOS 15.0+

### UIKit Template
- Simple structure with ViewControllers
- TabBarController with Home/More tabs
- Dynamic settings screen using UICollectionView
- Supports iOS 15.0+
- Scene-based app lifecycle

Structure:
```
Sources/
├── AppDelegate.swift
├── SceneDelegate.swift
└── ViewControllers/
    ├── HomeViewController.swift
    └── MoreViewController.swift
```

## Key Commands

### For Development
```bash
# Generate Tuist project
tuist generate

# Open in Xcode
tuist open

# Clean build artifacts
tuist clean

# Edit Tuist configuration
tuist edit
```

### For npm Package Maintenance
```bash
# Prepare for publishing
npm run prepublishOnly

# Publish to npm
npm publish

# Test locally
npm link
npx make-ios test-app
```

## Configuration Options

### 1. App Name (앱 이름)
- Must start with a letter
- Alphanumeric characters only
- Example: `MyAwesomeApp`

### 2. Bundle Identifier (번들 아이디)
- Reverse domain notation
- Example: `com.company.app`
- Debug builds: automatically appends `.dev`

### 3. UI Framework (UI 프레임워크)
- SwiftUI: Modern declarative UI
- UIKit: Traditional with simplified structure

### 4. iOS Minimum Version (최소 iOS 버전)
- iOS 15.0, 16.0, 17.0, 18.0

### 5. SPM Dependencies
Available packages:
- SnapKit (Auto Layout DSL)
- RxSwift (Reactive programming)
- TCA (The Composable Architecture)
- FlexLayout (Flexbox layout)
- PinLayout (Manual layout)
- Firebase (Backend services)
- Admob (Google AdMob)
- Alamofire (Networking)
- Kingfisher (Image loading)
- SwiftyJSON (JSON parsing)
- Realm (Database)
- Lottie (Animations)

## Language Considerations

All user-facing prompts are in Korean. Key Korean terms used:
- 앱 이름 (App Name)
- 번들 아이디 (Bundle ID)
- UI 프레임워크 (UI Framework)
- 최소 iOS 버전 (Minimum iOS Version)
- 의존성 (Dependencies)

## Common Tasks

### Adding a New SPM Package
1. Edit `scripts/update_dependencies.sh`
2. Add new case in the switch statement
3. Update package selection in `setup.sh`

### Modifying Templates
- SwiftUI: Edit files in `templates/SwiftUI/`
- UIKit: Edit files in `templates/UIKit/`

### Updating Tuist Configuration
- Edit `tuist/Project.swift` for project structure
- Edit `tuist/Config.swift` for Tuist settings

## Debugging Tips

### Common Issues
1. **Tuist not found**: Install with `curl -Ls https://install.tuist.io | bash`
2. **npm permissions**: Use `sudo npm install -g create-ios-app` or fix npm permissions
3. **Template generation fails**: Check if all template files exist

### Testing Changes
```bash
# Test shell script
./setup.sh

# Test npm package locally
npm link
npx create-ios-app test-app

# Check generated project
cd test-app
tuist generate
```

## Future Enhancements

The README.md mentions several potential features:
1. Network Layer Template
2. Dependency Injection setup
3. CI/CD Configuration (GitHub Actions, Fastlane)
4. Localization Support
5. Analytics Integration
6. Deep Linking setup
7. Push Notifications
8. App Themes (Dark/Light mode)
9. Code Quality Tools (SwiftLint)
10. Testing Templates

## Important Implementation Details

### UIKit Implementation
- TabBarController-based navigation with Home/More tabs
- UICollectionView with Compositional Layout for settings screen
- Dynamic action system with enum-based routing
- Scene-based app lifecycle with proper UIScene configuration
- Simplified structure without architectural overhead

### Configuration Management
- DEBUG: `.dev` suffix, optimizations off, testability on
- RELEASE: Production bundle ID, optimizations on, dSYM symbols

### npm Package Details
- Entry point: `bin/make-ios.js`
- Uses commander.js for CLI
- Interactive prompts with inquirer.js
- Supports command-line flags for automation
- Cross-platform with Node.js 16+

## Maintenance Notes

1. Keep Tuist version updated in documentation
2. Test with latest Xcode versions
3. Update SPM package versions periodically
4. Ensure Korean translations remain accurate
5. Test npm package on different Node.js versions

---

*This document should be updated whenever significant changes are made to the project structure or functionality.*