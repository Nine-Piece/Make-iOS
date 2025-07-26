#!/bin/bash

# Project generation script
# This script generates the Tuist configuration based on user inputs

set -e

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATES_DIR="$(dirname "$SCRIPT_DIR")/templates"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --app-name)
            APP_NAME="$2"
            shift 2
            ;;
        --bundle-id)
            BUNDLE_ID="$2"
            shift 2
            ;;
        --ui-framework)
            UI_FRAMEWORK="$2"
            shift 2
            ;;
        --ios-version)
            IOS_VERSION="$2"
            shift 2
            ;;
        --packages)
            shift
            PACKAGES=("$@")
            break
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Generate Package.swift for SPM dependencies
cat > "Package.swift" << EOF
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "${APP_NAME}Dependencies",
    platforms: [
        .iOS(.v${IOS_VERSION/./})
    ],
    dependencies: [
EOF

# Add selected packages
for package in "${PACKAGES[@]}"; do
    case $package in
        "SnapKit")
            echo '        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0"),' >> Package.swift
            ;;
        "RxSwift")
            echo '        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0"),' >> Package.swift
            ;;
        "TCA")
            echo '        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.7.0"),' >> Package.swift
            ;;
        "FlexLayout")
            echo '        .package(url: "https://github.com/layoutBox/FlexLayout.git", from: "2.0.0"),' >> Package.swift
            ;;
        "PinLayout")
            echo '        .package(url: "https://github.com/layoutBox/PinLayout.git", from: "1.10.0"),' >> Package.swift
            ;;
        "Firebase")
            echo '        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.19.0"),' >> Package.swift
            ;;
        "Admob")
            echo '        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "10.14.0"),' >> Package.swift
            ;;
        "Alamofire")
            echo '        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),' >> Package.swift
            ;;
        "Kingfisher")
            echo '        .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),' >> Package.swift
            ;;
        "SwiftyJSON")
            echo '        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0"),' >> Package.swift
            ;;
        "Realm")
            echo '        .package(url: "https://github.com/realm/realm-swift.git", from: "10.45.0"),' >> Package.swift
            ;;
        "Lottie")
            echo '        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.0"),' >> Package.swift
            ;;
    esac
done

cat >> "Package.swift" << EOF
    ],
    targets: [
        .target(
            name: "${APP_NAME}Dependencies",
            dependencies: []
        )
    ]
)
EOF

# Update Project.swift with user configuration
sed -i '' "s/APP_NAME_PLACEHOLDER/$APP_NAME/g" Project.swift
sed -i '' "s/BUNDLE_ID_PLACEHOLDER/$BUNDLE_ID/g" Project.swift
sed -i '' "s/IOS_VERSION_PLACEHOLDER/$IOS_VERSION/g" Project.swift

# Update dependencies if packages are selected
if [ ${#PACKAGES[@]} -gt 0 ]; then
    "$SCRIPT_DIR/update_dependencies.sh" "$APP_NAME" "${PACKAGES[@]}"
fi

# Create targets directory structure
mkdir -p "Targets/$APP_NAME/Sources"
mkdir -p "Targets/$APP_NAME/Resources"
mkdir -p "Targets/${APP_NAME}Tests/Sources"
mkdir -p "Targets/${APP_NAME}UITests/Sources"

# Copy Assets catalog from common folder
cp -r "$TEMPLATES_DIR/common/Assets.xcassets" "Targets/$APP_NAME/Resources/"

# Copy UI framework templates
if [ "$UI_FRAMEWORK" == "UIKit" ]; then
    # Copy entire UIKit template structure
    cp -r "$TEMPLATES_DIR/UIKit/"* "Targets/$APP_NAME/Sources/"
elif [ "$UI_FRAMEWORK" == "SwiftUI" ]; then
    # Copy SwiftUI template files
    cp -r "$TEMPLATES_DIR/SwiftUI/"* "Targets/$APP_NAME/Sources/"
fi

# Copy Info.plist files from templates
cp "$TEMPLATES_DIR/plist/Info-Debug.plist" "Targets/$APP_NAME/Resources/"
cp "$TEMPLATES_DIR/plist/Info-Release.plist" "Targets/$APP_NAME/Resources/"

# Copy LaunchScreen.storyboard from template
cp "$TEMPLATES_DIR/storyboard/LaunchScreen.storyboard" "Targets/$APP_NAME/Resources/"

echo "Project generation completed successfully!"