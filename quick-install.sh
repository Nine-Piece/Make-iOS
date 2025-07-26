#!/bin/bash

# GitHub용 빠른 설치 스크립트
# 다음 명령으로 실행할 수 있습니다: bash <(curl -s https://raw.githubusercontent.com/nine-piece/make-ios/main/quick-install.sh)

set -e

echo "🚀 iOS 템플릿 생성기 설치 중..."

# 임시 디렉토리에 복제
TEMP_DIR=$(mktemp -d)
git clone --quiet https://github.com/nine-piece/make-ios.git "$TEMP_DIR/make-ios"

# 설정 실행
cd "$TEMP_DIR/make-ios"
./setup.sh

# 정리는 setup.sh에서 처리됩니다