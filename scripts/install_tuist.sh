#!/bin/bash

# Tuist Auto-installer
# Official installation methods from https://docs.tuist.dev/en/guides/quick-start/install-tuist

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_color() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

print_header() {
    echo ""
    print_color "$BLUE" "================================================"
    print_color "$BLUE" "$1"
    print_color "$BLUE" "================================================"
    echo ""
}

# Check if Tuist is already installed
if command -v tuist &> /dev/null; then
    TUIST_VERSION=$(tuist --version 2>/dev/null || echo "unknown")
    print_color "$GREEN" "✅ Tuist is already installed (version: $TUIST_VERSION)"
    exit 0
fi

print_header "Tuist Installation"
print_color "$BLUE" "This script will install Tuist using the recommended method."
echo ""

# Detect package manager availability
HOMEBREW_AVAILABLE=false
MISE_AVAILABLE=false

if command -v brew &> /dev/null; then
    HOMEBREW_AVAILABLE=true
fi

if command -v mise &> /dev/null; then
    MISE_AVAILABLE=true
fi

# Show available installation methods
print_color "$YELLOW" "Available installation methods:"
echo ""

if [[ "$MISE_AVAILABLE" == "true" ]]; then
    print_color "$GREEN" "1. Mise (Recommended by Tuist team)"
    echo "   - Deterministic tool versions"
    echo "   - Team-friendly version management"
else
    print_color "$YELLOW" "1. Mise (Recommended by Tuist team) - Not installed"
    echo "   - Deterministic tool versions"
    echo "   - Team-friendly version management"
    print_color "$BLUE" "   💡 To install Mise first, Visit: https://mise.jdx.dev/getting-started"
fi

if [[ "$HOMEBREW_AVAILABLE" == "true" ]]; then
    print_color "$GREEN" "2. Homebrew"
    echo "   - Simple and widely used"
    echo "   - System-wide installation"
else
    print_color "$YELLOW" "2. Homebrew - Not installed"
    echo "   - Simple and widely used"
    echo "   - System-wide installation"
    print_color "$BLUE" "   💡 To install Homebrew first, Visit: https://brew.sh/"
fi

print_color "$GREEN" "3. Official installer script"
echo "   - Direct from Tuist team"
echo "   - Works on all systems"

echo ""

# Let user choose installation method
if [[ "$MISE_AVAILABLE" == "true" ]]; then
    DEFAULT_CHOICE="1"
    print_color "$YELLOW" "Recommended: Use Mise (1)"
elif [[ "$HOMEBREW_AVAILABLE" == "true" ]]; then
    DEFAULT_CHOICE="2"
    print_color "$YELLOW" "Recommended: Use Homebrew (2)"
else
    DEFAULT_CHOICE="3"
    print_color "$YELLOW" "Available: Official installer (3)"
fi

read -p "Choose installation method (1-3, default: $DEFAULT_CHOICE): " INSTALL_METHOD
INSTALL_METHOD=${INSTALL_METHOD:-$DEFAULT_CHOICE}

case $INSTALL_METHOD in
    1)
        if [[ "$MISE_AVAILABLE" != "true" ]]; then
            print_color "$RED" "❌ Mise is not installed. Please install mise first or choose another method."
            print_color "$BLUE" "To install mise: curl https://mise.run | sh"
            exit 1
        fi
        
        print_color "$GREEN" "Installing Tuist with Mise..."
        
        # Install latest version
        if mise install tuist@latest; then
            # Set as global default
            if mise use -g tuist@latest; then
                print_color "$GREEN" "✅ Tuist installed successfully with Mise!"
                
                # Add mise to shell profile if not already there
                SHELL_RC=""
                if [[ "$SHELL" == *"zsh"* ]] || [[ -n "$ZSH_VERSION" ]]; then
                    SHELL_RC="$HOME/.zshrc"
                elif [[ "$SHELL" == *"bash"* ]] || [[ -n "$BASH_VERSION" ]]; then
                    SHELL_RC="$HOME/.bashrc"
                fi
                
                if [[ -n "$SHELL_RC" ]] && [[ -f "$SHELL_RC" ]]; then
                    if ! grep -q 'mise activate' "$SHELL_RC"; then
                        echo 'eval "$(mise activate bash)"' >> "$SHELL_RC"
                        print_color "$YELLOW" "Added mise activation to $SHELL_RC"
                    fi
                fi
                
                print_color "$YELLOW" "Please restart your terminal or run: source $SHELL_RC"
            else
                print_color "$RED" "❌ Failed to set Tuist as global default"
                exit 1
            fi
        else
            print_color "$RED" "❌ Failed to install Tuist with Mise"
            exit 1
        fi
        ;;
        
    2)
        if [[ "$HOMEBREW_AVAILABLE" != "true" ]]; then
            print_color "$RED" "❌ Homebrew is not installed. Please install Homebrew first or choose another method."
            print_color "$BLUE" "To install Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
        
        print_color "$GREEN" "Installing Tuist with Homebrew..."
        
        # Add tap and install
        if brew tap tuist/tuist && brew install --formula tuist; then
            print_color "$GREEN" "✅ Tuist installed successfully with Homebrew!"
        else
            print_color "$RED" "❌ Failed to install Tuist with Homebrew"
            exit 1
        fi
        ;;
        
    3)
        print_color "$GREEN" "Installing Tuist with official installer..."
        
        # Use the official installation method
        if curl -Ls https://install.tuist.io | bash; then
            print_color "$GREEN" "✅ Tuist installed successfully!"
            
            # The installer typically adds to PATH, but let's remind user
            print_color "$YELLOW" "If 'tuist' command is not found, please restart your terminal."
        else
            print_color "$RED" "❌ Failed to install Tuist with official installer"
            exit 1
        fi
        ;;
        
    *)
        print_color "$RED" "❌ Invalid choice. Please run the script again."
        exit 1
        ;;
esac

echo ""
print_color "$BLUE" "🔍 Verifying installation..."

# Wait a moment for PATH to update
sleep 2

# Verify installation
if command -v tuist &> /dev/null; then
    TUIST_VERSION=$(tuist --version 2>/dev/null || echo "installed")
    print_color "$GREEN" "✅ Verification successful! Tuist version: $TUIST_VERSION"
    echo ""
    print_color "$BLUE" "🎯 You can now use Tuist commands:"
    echo "   • tuist generate  - Generate Xcode project"
    echo "   • tuist clean     - Clean build artifacts"  
    echo "   • tuist --help    - Show all available commands"
else
    print_color "$YELLOW" "⚠️  Tuist installed but not immediately available in PATH"
    print_color "$YELLOW" "   Please restart your terminal and try running 'tuist --version'"
fi

echo ""
print_color "$GREEN" "🚀 Tuist installation completed!"