#!/bin/bash

# iOS Template Installer
# One-line installation script

set -e

# Configuration
REPO_URL="https://github.com/nine-piece/make-ios.git"
TEMP_DIR="/tmp/ios-template-$$"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# 색상 메시지 출력
print_message() {
    echo -e "${GREEN}[iOS 템플릿]${NC} $1"
}

# 오류 메시지 출력
print_error() {
    echo -e "${RED}[오류]${NC} $1"
}

# 필수 도구 확인
check_requirements() {
    print_message "필수 요구사항 확인 중..."
    
    # git 확인
    if ! command -v git &> /dev/null; then
        print_error "git이 설치되어 있지 않습니다. 먼저 git을 설치해주세요."
        exit 1
    fi
    
    # Tuist 확인
    if ! command -v tuist &> /dev/null; then
        print_error "Tuist가 설치되어 있지 않습니다."
        echo "다음 명령으로 Tuist를 설치하세요: curl -Ls https://install.tuist.io | bash"
        exit 1
    fi
    
    print_message "모든 요구사항이 충족되었습니다 ✓"
}

# 저장소 복제
clone_template() {
    print_message "iOS 템플릿 다운로드 중..."
    git clone --quiet "$REPO_URL" "$TEMP_DIR"
    print_message "다운로드 완료 ✓"
}

# 설정 실행
run_setup() {
    cd "$TEMP_DIR"
    
    # setup.sh 파일 확인
    if [ ! -f "setup.sh" ]; then
        print_error "setup.sh 파일을 찾을 수 없습니다."
        print_error "다운로드한 위치: $TEMP_DIR"
        ls -la
        exit 1
    fi
    
    # 실행 권한 부여
    chmod +x setup.sh
    ./setup.sh
}

# 정리
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
    fi
}

# 메인 실행
main() {
    print_message "iOS 템플릿 설치 프로그램에 오신 것을 환영합니다"
    
    # 종료 시 정리
    trap cleanup EXIT
    
    # 요구사항 확인
    check_requirements
    
    # 복제 및 실행
    clone_template
    run_setup
}

# 메인 함수 실행
main