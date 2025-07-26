# npm 패키지 배포 가이드

이 문서는 iOS Template Generator를 npm에 배포하는 방법을 설명합니다.

## 배포 전 준비사항

### 1. npm 계정 생성
- https://www.npmjs.com 에서 계정 생성
- 이메일 인증 완료

### 2. 패키지 이름 확인
```bash
npm search make-ios
```
- 패키지 이름이 이미 사용 중인지 확인
- 필요시 `package.json`의 `name` 필드 수정

### 3. GitHub URL 업데이트
`package.json`에서 실제 GitHub 저장소 URL로 변경:
```json
{
  "homepage": "https://github.com/nine-piece/make-ios",
  "bugs": {
    "url": "https://github.com/nine-piece/make-ios/issues"
  },
  "repository": {
    "type": "git",
    "url": "git+https://github.com/nine-piece/make-ios.git"
  }
}
```

## 배포 과정

### 1. 로컬 테스트
```bash
# 의존성 설치
npm install

# 배포 준비 스크립트 실행
npm run prepublishOnly

# 로컬 테스트
npm link
npx make-ios test-app

# 테스트 후 언링크
npm unlink
```

### 2. npm 로그인
```bash
npm login
# Username, Password, Email 입력
```

### 3. 첫 배포
```bash
# Dry run으로 먼저 확인
npm publish --dry-run

# 실제 배포
npm publish
```

### 4. 배포 확인
```bash
# npm 페이지에서 확인
open https://www.npmjs.com/package/make-ios

# 설치 테스트
npx make-ios@latest my-test-app
```

## 버전 업데이트

### 1. 버전 변경
```bash
# 패치 버전 업 (1.0.0 -> 1.0.1)
npm version patch

# 마이너 버전 업 (1.0.0 -> 1.1.0)
npm version minor

# 메이저 버전 업 (1.0.0 -> 2.0.0)
npm version major
```

### 2. 변경사항 커밋 & 푸시
```bash
git add .
git commit -m "chore: bump version to x.x.x"
git push origin main
git push --tags
```

### 3. 재배포
```bash
npm publish
```

## 배포 후 사용 방법

사용자들은 다음과 같이 사용할 수 있습니다:

```bash
# npx 사용 (권장)
npx make-ios my-app

# npm init 사용
npm init ios-app my-app

# 전역 설치 후 사용
npm install -g make-ios
make-ios my-app

# yarn 사용
yarn create ios-app my-app

# pnpm 사용
pnpm create ios-app my-app
```

## 주의사항

1. **패키지 이름**: 한번 배포하면 패키지 이름을 변경하기 어려움
2. **버전 관리**: Semantic Versioning 준수 (MAJOR.MINOR.PATCH)
3. **README 업데이트**: 배포 후 README의 설치 명령어 업데이트
4. **.npmignore**: 불필요한 파일이 패키지에 포함되지 않도록 확인
5. **테스트**: 항상 배포 전 로컬에서 충분히 테스트

## 문제 해결

### 권한 오류
```bash
npm ERR! 403 Forbidden
```
- npm 로그인 확인: `npm whoami`
- 패키지 이름이 이미 사용 중인지 확인

### 파일 누락
```bash
npm ERR! ENOENT: no such file or directory
```
- `files` 필드 확인
- `.npmignore` 확인
- 필요한 파일이 모두 있는지 확인

### 버전 충돌
```bash
npm ERR! 402 Payment Required
```
- 이미 배포된 버전인지 확인
- `npm version` 명령어로 버전 업데이트

---

이 가이드를 따라 npm에 성공적으로 배포하면, 전 세계 개발자들이 `npx make-ios`로 iOS 프로젝트를 생성할 수 있습니다!