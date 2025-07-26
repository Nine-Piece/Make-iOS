#!/bin/bash

# Automated test script for iOS Template Generator

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test directory
TEST_DIR="/tmp/ios-template-test-$$"
PROJECT_NAME="TestApp"
BUNDLE_ID="com.test.app"

# Clean up function
cleanup() {
    echo -e "\n${YELLOW}[정리]${NC} 테스트 파일 삭제 중..."
    rm -rf "$TEST_DIR"
}

# Set up trap for cleanup
trap cleanup EXIT

# Print colored message
print_color() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Test function
test_case() {
    local test_name=$1
    local command=$2
    echo -e "\n${BLUE}[테스트]${NC} $test_name"
    echo -e "${YELLOW}[명령어]${NC} $command"
    if eval "$command"; then
        print_color "$GREEN" "✓ 성공"
        return 0
    else
        print_color "$RED" "✗ 실패"
        return 1
    fi
}

# Build test function
test_build() {
    local project_dir=$1
    local scheme=$2
    echo -e "\n${BLUE}[빌드 테스트]${NC} 프로젝트: $project_dir, 스킴: $scheme"
    ((TOTAL_TESTS++))
    
    cd "$project_dir"
    
    # Find an available iPhone simulator
    local simulator_name=$(xcrun simctl list devices available | grep -E "(iPhone|iPad)" | grep -v "unavailable" | head -n 1 | sed 's/^[[:space:]]*//' | cut -d' ' -f1-4 | sed 's/ (.*$//' | sed 's/[[:space:]]*$//')
    
    if [ -z "$simulator_name" ]; then
        print_color "$RED" "✗ 사용 가능한 시뮬레이터를 찾을 수 없습니다"
        ((FAILED_TESTS++))
        cd ..
        return 1
    fi
    
    echo -e "${YELLOW}[시뮬레이터]${NC} $simulator_name"
    
    # Build for iOS Simulator
    local build_command
    if [ -f "*.xcworkspace" ] || [ -d "$(ls -d *.xcworkspace 2>/dev/null | head -n 1)" ]; then
        local workspace=$(ls -d *.xcworkspace | head -n 1)
        build_command="xcodebuild -workspace '$workspace' -scheme '$scheme' -destination 'platform=iOS Simulator,name=\"$simulator_name\"' -configuration Debug clean build CODE_SIGN_IDENTITY='' CODE_SIGNING_REQUIRED=NO"
    else
        local project=$(ls -d *.xcodeproj | head -n 1)
        build_command="xcodebuild -project '$project' -scheme '$scheme' -destination 'platform=iOS Simulator,name=\"$simulator_name\"' -configuration Debug clean build CODE_SIGN_IDENTITY='' CODE_SIGNING_REQUIRED=NO"
    fi
    echo -e "${YELLOW}[빌드 명령어]${NC} $build_command"
    echo -e "${YELLOW}[빌드 시작]${NC} $(date '+%H:%M:%S')"
    
    if eval "$build_command" > build.log 2>&1; then
        print_color "$GREEN" "✓ 빌드 성공: $scheme ($(date '+%H:%M:%S'))"
        ((PASSED_TESTS++))
        rm -f build.log
        cd ..
        return 0
    else
        print_color "$RED" "✗ 빌드 실패: $scheme ($(date '+%H:%M:%S'))"
        ((FAILED_TESTS++))
        echo -e "${RED}[에러 로그]${NC}"
        tail -n 50 build.log
        cd ..
        return 1
    fi
}

# Test counter
TOTAL_TESTS=0
PASSED_TESTS=0
FAILED_TESTS=0

# Update test function to count tests
test_case() {
    local test_name=$1
    local command=$2
    echo -e "\n${BLUE}[테스트]${NC} $test_name"
    echo -e "${YELLOW}[명령어]${NC} $command"
    ((TOTAL_TESTS++))
    if eval "$command"; then
        print_color "$GREEN" "✓ 성공"
        ((PASSED_TESTS++))
        return 0
    else
        print_color "$RED" "✗ 실패"
        ((FAILED_TESTS++))
        return 1
    fi
}

# Main test
main() {
    print_color "$BLUE" "================================================"
    print_color "$BLUE" "iOS 템플릿 생성기 자동 테스트"
    print_color "$BLUE" "================================================"
    echo -e "${YELLOW}[시작 시간]${NC} $(date '+%Y-%m-%d %H:%M:%S')"

    # Get script directory
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

    # Check prerequisites
    test_case "Tuist 설치 확인" "command -v tuist &> /dev/null"
    test_case "Python3 설치 확인" "command -v python3 &> /dev/null"
    
    # Create test directory
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    
    # Test 1: SwiftUI without dependencies
    print_color "$YELLOW" "\n[테스트 그룹 1] SwiftUI 템플릿 (의존성 없음)"
    cat > test_input.txt << EOF
${PROJECT_NAME}1
${BUNDLE_ID}.swiftui
1
3

y
EOF
    
    test_case "프로젝트 생성" "$SCRIPT_DIR/setup.sh < test_input.txt"
    test_case "프로젝트 디렉토리 확인" "[ -d '${PROJECT_NAME}1' ]"
    test_case "Project.swift 확인" "[ -f '${PROJECT_NAME}1/Project.swift' ]"
    test_case "SwiftUI 템플릿 확인" "[ -f '${PROJECT_NAME}1/Targets/${PROJECT_NAME}1/Sources/ContentView.swift' ]"
    test_case "패키지 배열 확인 (비어있음)" "grep -A 2 'packages: \\[' '${PROJECT_NAME}1/Project.swift' | grep -q '// SPM packages will be added here dynamically'"
    test_case "의존성 배열 확인 (비어있음)" "grep -A 2 'dependencies: \\[' '${PROJECT_NAME}1/Project.swift' | grep -q '// Dependencies will be added here dynamically'"
    
    # Test Tuist generation
    cd "${PROJECT_NAME}1"
    test_case "Tuist 프로젝트 생성" "tuist generate"
    test_case "Xcode 프로젝트 확인" "[ -d '${PROJECT_NAME}1.xcodeproj' ] || [ -d '${PROJECT_NAME}1.xcworkspace' ]"
    
    # Build tests for each scheme
    echo -e "\n${YELLOW}[빌드 테스트 시작]${NC} ${PROJECT_NAME}1"
    
    # List available schemes
    echo -e "${YELLOW}[스킴 확인]${NC}"
    if [ -d "${PROJECT_NAME}1.xcworkspace" ]; then
        xcodebuild -list -workspace "${PROJECT_NAME}1.xcworkspace" 2>/dev/null | grep -A 10 "Schemes:" || true
    else
        xcodebuild -list -project "${PROJECT_NAME}1.xcodeproj" 2>/dev/null | grep -A 10 "Schemes:" || true
    fi
    
    test_build "." "${PROJECT_NAME}1-Dev"
    test_build "." "${PROJECT_NAME}1"
    cd ..
    
    # Test 2: UIKit with dependencies
    print_color "$YELLOW" "\n[테스트 그룹 2] UIKit 템플릿 (의존성 포함)"
    cat > test_input2.txt << EOF
${PROJECT_NAME}2
${BUNDLE_ID}.uikit
2
3
1 2 8
y
EOF
    
    test_case "프로젝트 생성" "$SCRIPT_DIR/setup.sh < test_input2.txt"
    test_case "프로젝트 디렉토리 확인" "[ -d '${PROJECT_NAME}2' ]"
    test_case "ViewControllers 폴더 확인" "[ -d '${PROJECT_NAME}2/Targets/${PROJECT_NAME}2/Sources/ViewControllers' ]"
    test_case "의존성 추가 확인" "grep -q 'SnapKit' '${PROJECT_NAME}2/Project.swift'"
    test_case "의존성 추가 확인" "grep -q 'RxSwift' '${PROJECT_NAME}2/Project.swift'"
    test_case "의존성 추가 확인" "grep -q 'Alamofire' '${PROJECT_NAME}2/Project.swift'"
    
    # Test Tuist generation and build
    cd "${PROJECT_NAME}2"
    test_case "Tuist 프로젝트 생성" "tuist generate"
    echo -e "\n${YELLOW}[빌드 테스트 시작]${NC} ${PROJECT_NAME}2"
    
    # List available schemes
    echo -e "${YELLOW}[스킴 확인]${NC}"
    if [ -d "${PROJECT_NAME}2.xcworkspace" ]; then
        xcodebuild -list -workspace "${PROJECT_NAME}2.xcworkspace" 2>/dev/null | grep -A 10 "Schemes:" || true
    else
        xcodebuild -list -project "${PROJECT_NAME}2.xcodeproj" 2>/dev/null | grep -A 10 "Schemes:" || true
    fi
    
    test_build "." "${PROJECT_NAME}2-Dev"
    test_build "." "${PROJECT_NAME}2"
    cd ..
    
    # Test 3: SwiftUI with multiple dependencies
    print_color "$YELLOW" "\n[테스트 그룹 3] SwiftUI 템플릿 (여러 의존성)"
    cat > test_input3.txt << EOF
${PROJECT_NAME}3
${BUNDLE_ID}.swiftui.deps
1
4
4 8 9 10
y
EOF
    
    test_case "프로젝트 생성" "$SCRIPT_DIR/setup.sh < test_input3.txt"
    test_case "프로젝트 디렉토리 확인" "[ -d '${PROJECT_NAME}3' ]"
    test_case "패키지 확인: FlexLayout" "grep -q 'FlexLayout' '${PROJECT_NAME}3/Project.swift'"
    test_case "패키지 확인: Alamofire" "grep -q 'Alamofire' '${PROJECT_NAME}3/Project.swift'"
    test_case "패키지 확인: Kingfisher" "grep -q 'Kingfisher' '${PROJECT_NAME}3/Project.swift'"
    test_case "패키지 확인: SwiftyJSON" "grep -q 'SwiftyJSON' '${PROJECT_NAME}3/Project.swift'"
    
    # Test Tuist generation and build
    cd "${PROJECT_NAME}3"
    test_case "Tuist 프로젝트 생성" "tuist generate"
    echo -e "\n${YELLOW}[빌드 테스트 시작]${NC} ${PROJECT_NAME}3"
    
    # List available schemes
    echo -e "${YELLOW}[스킴 확인]${NC}"
    if [ -d "${PROJECT_NAME}3.xcworkspace" ]; then
        xcodebuild -list -workspace "${PROJECT_NAME}3.xcworkspace" 2>/dev/null | grep -A 10 "Schemes:" || true
    else
        xcodebuild -list -project "${PROJECT_NAME}3.xcodeproj" 2>/dev/null | grep -A 10 "Schemes:" || true
    fi
    
    test_build "." "${PROJECT_NAME}3-Dev"
    test_build "." "${PROJECT_NAME}3"
    cd ..
    
    # Test 4: iOS version edge cases
    print_color "$YELLOW" "\n[테스트 그룹 4] iOS 버전 엣지 케이스 테스트"
    
    # Test iOS 14.0
    cat > test_input4.txt << EOF
${PROJECT_NAME}4
${BUNDLE_ID}.ios14
1
1

y
EOF
    
    test_case "iOS 14.0 프로젝트 생성" "$SCRIPT_DIR/setup.sh < test_input4.txt"
    test_case "iOS 14.0 버전 확인" "grep -q '14.0' '${PROJECT_NAME}4/Project.swift'"
    
    # Test iOS 26.0
    cat > test_input5.txt << EOF
${PROJECT_NAME}5
${BUNDLE_ID}.ios26
1
6

y
EOF
    
    test_case "iOS 26.0 프로젝트 생성" "$SCRIPT_DIR/setup.sh < test_input5.txt"
    test_case "iOS 26.0 버전 확인" "grep -q '26.0' '${PROJECT_NAME}5/Project.swift'"
    
    # Test 5: npm/npx installation
    print_color "$YELLOW" "\n[테스트 그룹 5] npm 방식 테스트"
    cd "$TEST_DIR"
    
    # Link npm package
    cd "$SCRIPT_DIR"
    npm link &> /dev/null || true
    cd "$TEST_DIR"
    
    # Test npx with command line options
    test_case "npx 명령 실행" "npx make-ios ${PROJECT_NAME}6 --template swiftui --bundle-id ${BUNDLE_ID}.npx --ios-version 17.0 --skip-install"
    test_case "프로젝트 디렉토리 확인" "[ -d '${PROJECT_NAME}6' ]"
    test_case "iOS 버전 확인" "grep -q '17.0' '${PROJECT_NAME}6/Project.swift'"
    
    # Summary
    echo -e "\n${BLUE}================================================${NC}"
    echo -e "${BLUE}테스트 요약${NC}"
    echo -e "${BLUE}================================================${NC}"
    echo -e "${YELLOW}[종료 시간]${NC} $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${YELLOW}[전체 테스트]${NC} $TOTAL_TESTS"
    echo -e "${GREEN}[성공]${NC} $PASSED_TESTS"
    echo -e "${RED}[실패]${NC} $FAILED_TESTS"
    
    if [ $FAILED_TESTS -eq 0 ]; then
        print_color "$GREEN" "\n모든 테스트가 성공적으로 완료되었습니다! 🎉"
        print_color "$GREEN" "================================================"
        exit 0
    else
        print_color "$RED" "\n일부 테스트가 실패했습니다. 위의 로그를 확인하세요."
        print_color "$RED" "================================================"
        exit 1
    fi
}

# Run main function
main