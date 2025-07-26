# iOS 템플릿 생성기 🚀

> [English](README.md)

Tuist를 사용하여 원하는 설정으로 새로운 iOS 프로젝트를 빠르게 생성할 수 있도록 도와주는 강력한 iOS 앱 템플릿 생성기입니다.

## 주요 기능 ✨

- **🎯 Tuist 통합**: 현대적인 프로젝트 생성 및 관리
- **📱 UI 프레임워크 선택**: SwiftUI 또는 UIKit 템플릿
- **📦 SPM 지원**: 인기 있는 Swift 패키지의 쉬운 통합
- **🔧 구성 관리**: 별도의 DEBUG 및 RELEASE 구성
- **🏗️ 간단한 구조**: 깔끔하고 유지보수하기 쉬운 프로젝트 구조
- **🚄 빠른 설정**: 한 줄 설치 및 대화형 설정
- **♻️ 확장 가능**: 새로운 패키지 및 구성을 쉽게 추가

## 빠른 시작 🏃‍♂️

### npm/npx 사용하기 (권장)

```bash
# npx 사용 (설치 불필요)
npx make-ios my-app

# npm init 사용
npm init ios-app my-app

# yarn 사용
yarn create ios-app my-app

# pnpm 사용
pnpm create ios-app my-app
```

### 명령줄 옵션

```bash
npx make-ios my-app --template uikit --bundle-id com.company.myapp
```

옵션:
- `-t, --template <type>` - UI 프레임워크 (swiftui/uikit) 
- `-b, --bundle-id <id>` - 번들 식별자
- `--ios-version <version>` - 최소 iOS 버전
- `--use-npm` - 패키지에 npm 사용
- `--use-yarn` - 패키지에 yarn 사용
- `--use-pnpm` - 패키지에 pnpm 사용

### 한 줄 설치 (대체 방법)

```bash
curl -Ls https://raw.githubusercontent.com/nine-piece/make-ios/main/install.sh | bash
```

### 수동 설치

1. 저장소 복제:
```bash
git clone https://github.com/nine-piece/make-ios.git
cd make-ios
```

2. 설정 스크립트 실행:
```bash
./setup.sh
```

## 필수 요구사항 📋

- **macOS**: 12.0 이상
- **Xcode**: 14.0 이상
- **Tuist**: 3.0 이상

### Tuist 설치

```bash
curl -Ls https://install.tuist.io | bash
```

## 사용법 🛠️

설정 스크립트가 다음 구성 옵션을 안내합니다:

### 1. 앱 이름
- 영문자로 시작해야 함
- 영문자와 숫자만 포함 가능
- 예: `MyAwesomeApp`

### 2. 번들 식별자
- 표준 역방향 도메인 표기법
- 예: `com.company.app`
- Debug 빌드는 자동으로 `.dev` 추가

### 3. UI 프레임워크
- **SwiftUI**: 현대적인 선언형 UI 프레임워크
- **UIKit**: TabBar 네비게이션과 설정 화면이 포함된 전통적인 UI 프레임워크

### 4. iOS 최소 버전
- iOS 14.0
- iOS 15.0
- iOS 16.0 (기본값)
- iOS 17.0
- iOS 18.0
- iOS 26.0

### 5. Swift Package Manager 의존성

사용 가능한 패키지:

| 패키지 | 설명 | 사용 사례 |
|---------|-------------|----------|
| **SnapKit** | Auto Layout DSL | 간소화된 제약 기반 레이아웃 |
| **RxSwift** | 반응형 프로그래밍 | 반응형 데이터 흐름 및 이벤트 처리 |
| **TCA** | The Composable Architecture | 상태 관리 및 앱 아키텍처 |
| **FlexLayout** | Flexbox 레이아웃 | CSS 스타일의 유연한 레이아웃 |
| **PinLayout** | 수동 레이아웃 | 성능 중심의 수동 레이아웃 |
| **Firebase** | 백엔드 서비스 | 분석, 인증, 데이터베이스 등 |
| **Admob** | Google AdMob | 모바일 광고 |
| **Alamofire** | 네트워킹 | HTTP 네트워킹 라이브러리 |
| **Kingfisher** | 이미지 다운로드 | 비동기 이미지 로딩 및 캐싱 |
| **SwiftyJSON** | JSON 파싱 | 간소화된 JSON 처리 |
| **Realm** | 데이터베이스 | 로컬 데이터베이스 솔루션 |
| **Lottie** | 애니메이션 | 벡터 애니메이션 라이브러리 |

## 프로젝트 구조 📁

### SwiftUI 구조
```
YourApp/
├── Project.swift
├── Tuist/
│   └── Config.swift
├── Configurations/
├── Targets/
│   └── YourApp/
│       ├── Sources/
│       │   ├── AppDelegate.swift
│       │   ├── SceneDelegate.swift
│       │   └── ContentView.swift
│       └── Resources/
└── .gitignore
```

### UIKit 구조
```
YourApp/
├── Project.swift
├── Tuist/
│   └── Config.swift
├── Configurations/
├── Targets/
│   └── YourApp/
│       ├── Sources/
│       │   ├── AppDelegate.swift
│       │   ├── SceneDelegate.swift
│       │   └── ViewControllers/
│       │       ├── HomeViewController.swift
│       │       └── MoreViewController.swift
│       └── Resources/
│           ├── Assets.xcassets
│           ├── Info.plist
│           └── LaunchScreen.storyboard
└── .gitignore
```

## 빌드 구성 🔨

템플릿은 자동으로 두 개의 스킴을 생성합니다:

### DEBUG 구성
- **스킴 이름**: `{앱이름}-Dev`
- **번들 ID**: `{bundle.id}.dev`
- **최적화**: 비활성화
- **테스트 가능**: 활성화
- **디버그 심볼**: 전체

### RELEASE 구성
- **스킴 이름**: `{앱이름}`
- **번들 ID**: `{bundle.id}`
- **최적화**: 활성화
- **테스트 가능**: 비활성화
- **디버그 심볼**: dSYM

## UIKit 구현 세부사항 🏛️

UIKit 템플릿의 주요 특징:

### 네비게이션 구조
- **TabBarController**: Home/More 탭으로 구성된 기본 네비게이션
- **HomeViewController**: 메인 화면
- **MoreViewController**: 설정 및 추가 기능 화면

### 설정 화면 특징
- **UICollectionView**: Compositional Layout을 사용한 동적 설정 화면
- **Dynamic Actions**: enum 기반 액션 시스템으로 확장 가능한 설정 항목
- **Scene-based Lifecycle**: 최신 iOS 앱 라이프사이클 지원

## 고급 기능 🎯

### 새로운 SPM 패키지 추가

템플릿에 새 패키지를 추가하려면:

1. `scripts/update_dependencies.sh` 편집
2. 패키지에 대한 새 케이스 추가:

```bash
"YourPackage")
    PACKAGE_ENTRIES="${PACKAGE_ENTRIES}        .package(url: \"https://github.com/owner/repo.git\", from: \"1.0.0\"),\n"
    DEPENDENCY_ENTRIES="${DEPENDENCY_ENTRIES}                .package(product: \"YourPackage\"),\n"
    ;;
```

3. `setup.sh`의 패키지 선택 메뉴 업데이트

### 템플릿 사용자 정의

템플릿 위치:
- `templates/SwiftUI/` - SwiftUI 앱 템플릿
- `templates/UIKit/` - UIKit 앱 템플릿

원하는 프로젝트 구조에 맞게 이 파일들을 수정할 수 있습니다.

### Tuist 명령어

프로젝트 생성 후:

```bash
# Xcode 프로젝트 생성
tuist generate

# Xcode에서 열기
tuist open

# 정리
tuist clean

# 프로젝트 구성 편집
tuist edit
```

## 기여하기 🤝

기여를 환영합니다! Pull Request를 자유롭게 제출해 주세요.

1. 저장소 포크
2. 기능 브랜치 생성 (`git checkout -b feature/AmazingFeature`)
3. 변경 사항 커밋 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시 (`git push origin feature/AmazingFeature`)
5. Pull Request 열기

## 라이선스 📄

이 프로젝트는 MIT 라이선스에 따라 라이선스가 부여됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 감사의 말 👏

- [Tuist](https://tuist.io) - 놀라운 프로젝트 생성 도구 제공
- 모든 훌륭한 Swift 패키지 작성자들

---

iOS 커뮤니티를 위해 ❤️로 만들었습니다