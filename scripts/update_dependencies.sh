#!/bin/bash

# Script to update Project.swift with selected SPM dependencies

set -e

APP_NAME="$1"
shift
PACKAGES=("$@")

# No dependencies if empty
if [ ${#PACKAGES[@]} -eq 0 ]; then
    echo "No dependencies to update"
    exit 0
fi

# Create a Python script to safely update the Project.swift file
cat > /tmp/update_project.py << 'EOF'
import sys
import re

def update_project_swift(packages):
    with open('Project.swift', 'r') as f:
        content = f.read()
    
    # Package definitions
    package_map = {
        "SnapKit": '.package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.7.0")',
        "RxSwift": '.package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0")',
        "TCA": '.package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.7.0")',
        "FlexLayout": '.package(url: "https://github.com/layoutBox/FlexLayout.git", from: "2.0.0")',
        "PinLayout": '.package(url: "https://github.com/layoutBox/PinLayout.git", from: "1.10.0")',
        "Firebase": '.package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.19.0")',
        "Admob": '.package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", from: "10.14.0")',
        "Alamofire": '.package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0")',
        "Kingfisher": '.package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0")',
        "SwiftyJSON": '.package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "5.0.0")',
        "Realm": '.package(url: "https://github.com/realm/realm-swift.git", from: "10.45.0")',
        "Lottie": '.package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.0")'
    }
    
    # Dependency definitions
    dependency_map = {
        "SnapKit": ['.package(product: "SnapKit")'],
        "RxSwift": ['.package(product: "RxSwift")', '.package(product: "RxCocoa")'],
        "TCA": ['.package(product: "ComposableArchitecture")'],
        "FlexLayout": ['.package(product: "FlexLayout")'],
        "PinLayout": ['.package(product: "PinLayout")'],
        "Firebase": ['.package(product: "FirebaseAnalytics")', '.package(product: "FirebaseAuth")', '.package(product: "FirebaseFirestore")'],
        "Admob": ['.package(product: "GoogleMobileAds")'],
        "Alamofire": ['.package(product: "Alamofire")'],
        "Kingfisher": ['.package(product: "Kingfisher")'],
        "SwiftyJSON": ['.package(product: "SwiftyJSON")'],
        "Realm": ['.package(product: "Realm")', '.package(product: "RealmSwift")'],
        "Lottie": ['.package(product: "Lottie")']
    }
    
    # Build package list
    package_list = []
    dependency_list = []
    
    for package in packages:
        if package in package_map:
            package_list.append(package_map[package])
            for dep in dependency_map[package]:
                dependency_list.append(dep)
    
    # Update packages array
    if package_list:
        # Find the packages array in Project definition
        packages_pattern = r'(packages:\s*\[\s*\n)(\s*//[^\n]*\n)?(\s*\])'
        packages_replacement = r'\1' + '        ' + ',\n        '.join(package_list) + '\n    ]'
        content = re.sub(packages_pattern, packages_replacement, content)
    
    # Update dependencies array
    if dependency_list:
        # Find dependencies array in mainTarget
        deps_pattern = r'(dependencies:\s*\[\s*\n)(\s*//[^\n]*\n)?(\s*\])'
        deps_replacement = r'\1' + '                ' + ',\n                '.join(dependency_list) + '\n        ]'
        content = re.sub(deps_pattern, deps_replacement, content, count=1)
    
    with open('Project.swift', 'w') as f:
        f.write(content)

if __name__ == "__main__":
    packages = sys.argv[1:]
    update_project_swift(packages)
EOF

# Run the Python script with the selected packages
python3 /tmp/update_project.py "${PACKAGES[@]}"

# Clean up
rm -f /tmp/update_project.py

echo "Dependencies updated in Project.swift"