# iOS Template Generator 🚀

> [한국어](README_ko.md)

A powerful iOS app template generator built with Tuist that helps you quickly scaffold new iOS projects with your preferred configuration.

## Features ✨

- **🎯 Tuist Integration**: Modern project generation and management
- **📱 UI Framework Choice**: SwiftUI or UIKit templates
- **📦 SPM Support**: Easy integration of popular Swift packages
- **🔧 Configuration Management**: Separate DEBUG and RELEASE configurations
- **🏗️ Simple Structure**: Clean, maintainable project structure
- **🚄 Quick Setup**: One-line installation and interactive setup
- **♻️ Extensible**: Easy to add new packages and configurations

## Quick Start 🏃‍♂️

### Using npm/npx (Recommended)

```bash
# Using npx (no installation required)
npx make-ios my-app

# Using npm init
npm init ios-app my-app

# Using yarn
yarn create ios-app my-app

# Using pnpm
pnpm create ios-app my-app
```

### Command Line Options

```bash
npx make-ios my-app --template uikit --bundle-id com.company.myapp
```

Options:
- `-t, --template <type>` - UI framework (swiftui/uikit) 
- `-b, --bundle-id <id>` - Bundle identifier
- `--ios-version <version>` - Minimum iOS version
- `--use-npm` - Use npm for packages
- `--use-yarn` - Use yarn for packages
- `--use-pnpm` - Use pnpm for packages

### One-Line Installation (Alternative)

```bash
curl -Ls https://raw.githubusercontent.com/nine-piece/make-ios/main/install.sh | bash
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/nine-piece/make-ios.git
cd make-ios
```

2. Run the setup script:
```bash
./setup.sh
```

## Prerequisites 📋

- **macOS**: 12.0 or later
- **Xcode**: 14.0 or later
- **Tuist**: 3.0 or later

### Installing Tuist

```bash
curl -Ls https://install.tuist.io | bash
```

## Usage 🛠️

The setup script will guide you through the following configuration options:

### 1. App Name
- Must start with a letter
- Can contain only alphanumeric characters
- Example: `MyAwesomeApp`

### 2. Bundle Identifier
- Standard reverse domain notation
- Example: `com.company.app`
- Debug builds will automatically append `.dev`

### 3. UI Framework
- **SwiftUI**: Modern declarative UI framework
- **UIKit**: Traditional UI with TabBar navigation and settings screen

### 4. iOS Minimum Version
- iOS 14.0
- iOS 15.0
- iOS 16.0 (Default)
- iOS 17.0
- iOS 18.0
- iOS 26.0

### 5. Swift Package Manager Dependencies

Available packages:

| Package | Description | Use Case |
|---------|-------------|----------|
| **SnapKit** | Auto Layout DSL | Simplified constraint-based layouts |
| **RxSwift** | Reactive Programming | Reactive data flows and event handling |
| **TCA** | The Composable Architecture | State management and app architecture |
| **FlexLayout** | Flexbox layout | CSS-like flexible layouts |
| **PinLayout** | Manual layout | Performance-focused manual layouts |
| **Firebase** | Backend services | Analytics, auth, database, etc. |
| **Admob** | Google AdMob | Mobile advertising |
| **Alamofire** | Networking | HTTP networking library |
| **Kingfisher** | Image downloading | Async image loading and caching |
| **SwiftyJSON** | JSON parsing | Simplified JSON handling |
| **Realm** | Database | Local database solution |
| **Lottie** | Animations | Vector animation library |

## Project Structure 📁

```
YourApp/
├── Project.swift                 # Tuist configuration
├── Tuist/
│   └── Config.swift             # Tuist settings
├── Configurations/
│   ├── Debug.xcconfig           # Debug configuration
│   └── Release.xcconfig         # Release configuration
├── Targets/
│   ├── YourApp/
│   │   ├── Sources/
│   │   │   ├── AppDelegate.swift
│   │   │   ├── SceneDelegate.swift
│   │   │   └── ContentView.swift (SwiftUI) or ViewControllers/ (UIKit)
│   │   └── Resources/
│   │       ├── Info.plist
│   │       └── LaunchScreen.storyboard
│   ├── YourAppTests/
│   └── YourAppUITests/
└── .gitignore
```

## Build Configurations 🔨

The template automatically creates two schemes:

### DEBUG Configuration
- **Scheme Name**: `{AppName}-Dev`
- **Bundle ID**: `{bundle.id}.dev`
- **Optimizations**: Disabled
- **Testability**: Enabled
- **Debug Symbols**: Full

### RELEASE Configuration
- **Scheme Name**: `{AppName}`
- **Bundle ID**: `{bundle.id}`
- **Optimizations**: Enabled
- **Testability**: Disabled
- **Debug Symbols**: dSYM

## Advanced Features 🎯

### Adding New SPM Packages

To add new packages to the template:

1. Edit `scripts/update_dependencies.sh`
2. Add a new case for your package:

```bash
"YourPackage")
    PACKAGE_ENTRIES="${PACKAGE_ENTRIES}        .package(url: \"https://github.com/owner/repo.git\", from: \"1.0.0\"),\n"
    DEPENDENCY_ENTRIES="${DEPENDENCY_ENTRIES}                .package(product: \"YourPackage\"),\n"
    ;;
```

3. Update the package selection menu in `setup.sh`

### Customizing Templates

Templates are located in:
- `templates/common/` - Shared assets (Assets.xcassets)
- `templates/plist/` - Info.plist templates for Debug/Release
- `templates/storyboard/` - LaunchScreen.storyboard
- `templates/SwiftUI/` - SwiftUI app template files
- `templates/UIKit/` - UIKit app template files

You can modify these files to match your preferred project structure.

### Tuist Commands

After project generation:

```bash
# Generate Xcode project
tuist generate

# Open in Xcode
tuist open

# Clean
tuist clean

# Edit project configuration
tuist edit
```

## Additional Features to Consider 🤔

### 1. Network Layer Template
- Pre-configured networking layer with Alamofire/URLSession
- API client structure with environment management
- Request/Response models and error handling

### 2. Dependency Injection
- Swinject or native DI container setup
- Service protocol definitions
- Mock implementations for testing

### 3. CI/CD Configuration
- GitHub Actions workflow templates
- Fastlane configuration
- Code signing automation setup

### 4. Localization Support
- Multi-language structure
- Localization helper utilities
- RTL support configuration

### 5. Analytics Integration
- Analytics abstraction layer
- Event tracking templates
- Debug logging configuration

### 6. Deep Linking
- URL scheme configuration
- Universal Links setup
- Navigation routing system

### 7. Push Notifications
- APNs configuration
- Notification service extension template
- Rich notification support

### 8. App Themes
- Dark/Light mode support
- Dynamic color system
- Typography management

### 9. Code Quality Tools
- SwiftLint configuration
- Pre-commit hooks
- Code formatting rules

### 10. Testing Templates
- Unit test templates
- UI test helpers
- Mock data generators

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments 👏

- [Tuist](https://tuist.io) - For amazing project generation tools
- All the amazing Swift package authors

---

Made with ❤️ for the iOS community