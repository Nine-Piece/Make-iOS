#!/bin/bash

# Test script to verify scheme generation

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Test directory
TEST_DIR="/tmp/ios-template-test-scheme-$$"
PROJECT_NAME="TestApp"
BUNDLE_ID="com.test.app"

# Clean up function
cleanup() {
    echo -e "\n${YELLOW}[정리]${NC} 테스트 파일 삭제 중..."
    rm -rf "$TEST_DIR"
}

# Set up trap for cleanup
trap cleanup EXIT

# Main test
echo -e "${BLUE}================================================${NC}"
echo -e "${BLUE}iOS 템플릿 스킴 테스트${NC}"
echo -e "${BLUE}================================================${NC}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Create test directory
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Test SwiftUI project
echo -e "\n${YELLOW}[테스트]${NC} SwiftUI 프로젝트 생성"
cat > test_input.txt << EOF
${PROJECT_NAME}
${BUNDLE_ID}
1
3

y
EOF

$SCRIPT_DIR/setup.sh < test_input.txt

# Check project was created
if [ -d "${PROJECT_NAME}" ]; then
    echo -e "${GREEN}✓ 프로젝트 생성 성공${NC}"
else
    echo -e "${RED}✗ 프로젝트 생성 실패${NC}"
    exit 1
fi

cd "${PROJECT_NAME}"

# Generate project
echo -e "\n${YELLOW}[테스트]${NC} Tuist 프로젝트 생성"
tuist generate

# Check schemes
echo -e "\n${YELLOW}[테스트]${NC} 스킴 확인"
if [ -d "${PROJECT_NAME}.xcworkspace" ]; then
    xcodebuild -list -workspace "${PROJECT_NAME}.xcworkspace" 2>/dev/null | grep -A 10 "Schemes:" || true
else
    xcodebuild -list -project "${PROJECT_NAME}.xcodeproj" 2>/dev/null | grep -A 10 "Schemes:" || true
fi

# Verify correct schemes exist
echo -e "\n${YELLOW}[검증]${NC} 스킴 이름 확인"
SCHEMES=$(xcodebuild -list -workspace "${PROJECT_NAME}.xcworkspace" 2>/dev/null | grep -A 10 "Schemes:" | grep -E "^\s+\S" | sed 's/^[[:space:]]*//' || true)

if echo "$SCHEMES" | grep -q "^${PROJECT_NAME}$"; then
    echo -e "${GREEN}✓ Release 스킴 확인: ${PROJECT_NAME}${NC}"
else
    echo -e "${RED}✗ Release 스킴 없음: ${PROJECT_NAME}${NC}"
fi

if echo "$SCHEMES" | grep -q "^${PROJECT_NAME}-Dev$"; then
    echo -e "${GREEN}✓ Dev 스킴 확인: ${PROJECT_NAME}-Dev${NC}"
else
    echo -e "${RED}✗ Dev 스킴 없음: ${PROJECT_NAME}-Dev${NC}"
fi

# Check that there are only 2 schemes
SCHEME_COUNT=$(echo "$SCHEMES" | wc -l | tr -d ' ')
if [ "$SCHEME_COUNT" -eq "2" ]; then
    echo -e "${GREEN}✓ 스킴 개수 정확: 2개${NC}"
else
    echo -e "${RED}✗ 스킴 개수 오류: ${SCHEME_COUNT}개 (2개여야 함)${NC}"
    echo -e "${YELLOW}발견된 스킴:${NC}"
    echo "$SCHEMES"
fi

echo -e "\n${GREEN}================================================${NC}"
echo -e "${GREEN}테스트 완료!${NC}"
echo -e "${GREEN}================================================${NC}"