#!/bin/bash

# iOS Template Generator
# Comprehensive iOS app template generator using Tuist

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
TEMPLATES_DIR="$SCRIPT_DIR/templates"
TUIST_DIR="$SCRIPT_DIR/tuist"

# Color output function
print_color() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

# Header output function
print_header() {
    echo ""
    print_color "$BLUE" "================================================"
    print_color "$BLUE" "$1"
    print_color "$BLUE" "================================================"
    echo ""
}

# Welcome message
clear
print_header "iOS Template Generator by Nine Piece"
print_color "$GREEN" "This tool helps you create new iOS apps using Tuist."
echo ""

# Check if Tuist is installed
print_color "$YELLOW" "Checking prerequisites..."
if ! command -v tuist &> /dev/null; then
    print_color "$RED" "❌ Tuist is not installed!"
    echo ""
    print_color "$BLUE" "📱 Don't worry! Your iOS project will be created successfully."
    print_color "$BLUE" "   You just need to install Tuist afterwards to open it in Xcode."
    echo ""
    print_color "$YELLOW" "Would you like to install Tuist automatically? (recommended)"
    read -p "Install Tuist now? (y/n): " INSTALL_TUIST
    
    if [[ "$INSTALL_TUIST" == "y" || "$INSTALL_TUIST" == "Y" ]]; then
        # Run the dedicated Tuist installer script
        if "$SCRIPT_DIR/scripts/install_tuist.sh"; then
            # Check if tuist is now available
            if command -v tuist &> /dev/null; then
                print_color "$GREEN" "🎉 Tuist is ready! Will generate Xcode project."
                SKIP_TUIST_GENERATE=false
            else
                print_color "$YELLOW" "⚠️  Tuist installed but needs terminal restart."
                print_color "$YELLOW" "   Project files will be created. Run 'tuist generate' after restart."
                SKIP_TUIST_GENERATE=true
            fi
        else
            print_color "$RED" "❌ Tuist installation failed."
            print_color "$YELLOW" "Will create project files. You can install Tuist manually later."
            SKIP_TUIST_GENERATE=true
        fi
    else
        print_color "$BLUE" "📁 Creating project files only. You can install Tuist later."
        SKIP_TUIST_GENERATE=true
    fi
else
    print_color "$GREEN" "✅ Tuist is installed"
    SKIP_TUIST_GENERATE=false
fi
echo ""

# App name input
if [[ -n "$AUTO_PROJECT_NAME" ]]; then
    APP_NAME="$AUTO_PROJECT_NAME"
    print_color "$GREEN" "App Name: $APP_NAME"
else
    while true; do
        read -p "Enter app name: " APP_NAME
        if [[ -z "$APP_NAME" ]]; then
            print_color "$RED" "App name cannot be empty!"
        elif [[ ! "$APP_NAME" =~ ^[a-zA-Z][a-zA-Z0-9]*$ ]]; then
            print_color "$RED" "App name must start with a letter and contain only letters and numbers!"
        else
            break
        fi
    done
fi

# Bundle identifier input
while true; do
    read -p "Enter bundle identifier (e.g., com.company.app): " BUNDLE_ID
    if [[ -z "$BUNDLE_ID" ]]; then
        print_color "$RED" "Bundle identifier cannot be empty!"
    elif [[ ! "$BUNDLE_ID" =~ ^[a-zA-Z][a-zA-Z0-9]*(\.[a-zA-Z][a-zA-Z0-9]*)+$ ]]; then
        print_color "$RED" "Invalid bundle identifier format!"
    else
        break
    fi
done

# UI framework selection
print_header "UI Framework Selection"
echo "1) SwiftUI"
echo "2) UIKit"
while true; do
    read -p "Choose UI framework (1 or 2): " UI_CHOICE
    case $UI_CHOICE in
        1)
            UI_FRAMEWORK="SwiftUI"
            break
            ;;
        2)
            UI_FRAMEWORK="UIKit"
            break
            ;;
        *)
            print_color "$RED" "Please select 1 or 2!"
            ;;
    esac
done

# iOS minimum version selection
print_header "iOS Minimum Version"
echo "Available versions:"
echo "1) iOS 14.0"
echo "2) iOS 15.0"
echo "3) iOS 16.0"
echo "4) iOS 17.0"
echo "5) iOS 18.0"
echo "6) iOS 26.0"
while true; do
    read -p "Choose iOS minimum version (1-6, default: 3): " IOS_CHOICE
    IOS_CHOICE=${IOS_CHOICE:-3}
    case $IOS_CHOICE in
        1)
            IOS_MIN_VERSION="14.0"
            break
            ;;
        2)
            IOS_MIN_VERSION="15.0"
            break
            ;;
        3)
            IOS_MIN_VERSION="16.0"
            break
            ;;
        4)
            IOS_MIN_VERSION="17.0"
            break
            ;;
        5)
            IOS_MIN_VERSION="18.0"
            break
            ;;
        6)
            IOS_MIN_VERSION="26.0"
            break
            ;;
        *)
            print_color "$RED" "Please select between 1-6!"
            ;;
    esac
done

# SPM package selection
print_header "SPM Package Selection"
echo "Available packages (for multiple selections, separate with spaces):"
echo "1) SnapKit - Auto Layout DSL"
echo "2) RxSwift - Reactive Programming"
echo "3) TCA (The Composable Architecture)"
echo "4) FlexLayout - Flexbox Layout"
echo "5) PinLayout - Manual Layout"
echo "6) Firebase - Backend Services"
echo "7) AdMob - Google AdMob"
echo "8) Alamofire - Networking"
echo "9) Kingfisher - Image Loading & Caching"
echo "10) SwiftyJSON - JSON Parsing"
echo "11) Realm - Database"
echo "12) Lottie - Animations"
echo ""
read -p "Select packages (e.g., '1 3 6' or press Enter to skip): " PACKAGE_CHOICES

# Parse selected packages
SELECTED_PACKAGES=()
if [[ ! -z "$PACKAGE_CHOICES" ]]; then
    for choice in $PACKAGE_CHOICES; do
        case $choice in
            1) SELECTED_PACKAGES+=("SnapKit") ;;
            2) SELECTED_PACKAGES+=("RxSwift") ;;
            3) SELECTED_PACKAGES+=("TCA") ;;
            4) SELECTED_PACKAGES+=("FlexLayout") ;;
            5) SELECTED_PACKAGES+=("PinLayout") ;;
            6) SELECTED_PACKAGES+=("Firebase") ;;
            7) SELECTED_PACKAGES+=("AdMob") ;;
            8) SELECTED_PACKAGES+=("Alamofire") ;;
            9) SELECTED_PACKAGES+=("Kingfisher") ;;
            10) SELECTED_PACKAGES+=("SwiftyJSON") ;;
            11) SELECTED_PACKAGES+=("Realm") ;;
            12) SELECTED_PACKAGES+=("Lottie") ;;
        esac
    done
fi

# Summary
print_header "Configuration Summary"
echo "App Name: $APP_NAME"
echo "Bundle ID: $BUNDLE_ID"
echo "Bundle ID (Debug): ${BUNDLE_ID}.dev"
echo "UI Framework: $UI_FRAMEWORK"
echo "iOS Minimum Version: $IOS_MIN_VERSION"
echo "Selected Packages: ${SELECTED_PACKAGES[@]:-None}"
echo ""
read -p "Do you want to proceed with these settings? (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    print_color "$YELLOW" "Setup cancelled."
    exit 0
fi

# Create project directory
if [[ -n "$TARGET_DIR" ]]; then
    # When called from npx, create project in the directory where user executed the command
    PROJECT_DIR="$TARGET_DIR/$APP_NAME"
else
    # When called directly, create in current directory
    PROJECT_DIR="$APP_NAME"
fi

if [[ -d "$PROJECT_DIR" ]]; then
    print_color "$RED" "$APP_NAME directory already exists!"
    exit 1
fi

print_header "Creating Project Structure"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Copy and configure Tuist files
print_color "$GREEN" "Setting up Tuist configuration..."
# Exclude Tuist directory from copying (due to deprecated Config.swift)
find "$TUIST_DIR" -maxdepth 1 -type f -exec cp {} . \;
cp -r "$TUIST_DIR/Configurations" .

# Generate project configuration
print_color "$GREEN" "Generating project configuration..."
"$SCRIPT_DIR/scripts/generate_project.sh" \
    --app-name "$APP_NAME" \
    --bundle-id "$BUNDLE_ID" \
    --ui-framework "$UI_FRAMEWORK" \
    --ios-version "$IOS_MIN_VERSION" \
    --packages "${SELECTED_PACKAGES[@]}"

if [[ $? -ne 0 ]]; then
    print_color "$RED" "Project generation failed!"
    exit 1
fi

# Copy appropriate template
print_color "$GREEN" "Copying $UI_FRAMEWORK template..."
cp -r "$TEMPLATES_DIR/$UI_FRAMEWORK/." "Targets/$APP_NAME/Sources/"

# Initialize Git repository
print_color "$GREEN" "Initializing Git repository..."
git init
git add .
git commit -m "Initial commit: $APP_NAME iOS app"

# Generate Tuist project (if Tuist is available)
if [[ "$SKIP_TUIST_GENERATE" == "false" ]]; then
    print_color "$GREEN" "Generating Xcode project with Tuist..."
    tuist generate
else
    print_color "$YELLOW" "Skipping Xcode project generation (Tuist not available)"
fi

print_header "Setup Complete!"
print_color "$GREEN" "'$APP_NAME' iOS app has been successfully created!"
echo ""
echo "Project location: $(pwd)"
echo ""
if [[ "$SKIP_TUIST_GENERATE" == "true" ]]; then
    print_color "$BLUE" "📋 To open your project in Xcode, follow these steps:"
    echo ""
    echo "1. cd $(pwd)"
    print_color "$YELLOW" "2. Install Tuist (if not already done):"
    print_color "$BLUE" "   curl -Ls https://install.tuist.io | bash"
    print_color "$YELLOW" "3. Restart your terminal or run: source ~/.zshrc"
    print_color "$YELLOW" "4. Generate Xcode project:"
    print_color "$BLUE" "   tuist generate"
    print_color "$YELLOW" "5. Open in Xcode:"
    print_color "$BLUE" "   open ${APP_NAME}.xcworkspace"
    echo ""
    print_color "$GREEN" "🎯 Development Tips:"
    echo "   • Use ${APP_NAME}-Dev scheme for development (includes .dev suffix)"
    echo "   • Use ${APP_NAME} scheme for production builds"
    echo "   • Your SPM packages are already configured in Project.swift"
    echo ""
    print_color "$BLUE" "💡 Why Tuist?"
    echo "   • Manages complex iOS project configurations"
    echo "   • Handles SPM dependencies automatically"
    echo "   • Provides clean project structure"
    echo "   • Supports multiple build configurations"
else
    print_color "$BLUE" "📋 Your project is ready! Next steps:"
    echo ""
    echo "1. cd $(pwd)"
    print_color "$YELLOW" "2. Open in Xcode:"
    print_color "$BLUE" "   open ${APP_NAME}.xcworkspace"
    echo ""
    print_color "$GREEN" "🎯 Development Tips:"
    echo "   • Use ${APP_NAME}-Dev scheme for development (includes .dev suffix)"
    echo "   • Use ${APP_NAME} scheme for production builds"
    echo "   • Your SPM packages are already configured and ready to use"
    echo ""
    print_color "$BLUE" "🔧 Additional Tuist commands:"
    echo "   • tuist clean     - Clean build artifacts"
    echo "   • tuist generate  - Regenerate project if needed"
    echo "   • tuist edit      - Edit Tuist configuration"
fi
echo ""
print_color "$YELLOW" "Happy coding! 🚀"