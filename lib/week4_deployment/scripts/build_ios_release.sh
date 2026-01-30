#!/bin/bash

# 4주차: iOS 앱 배포 - Release 빌드 스크립트
#
# 사용법: ./build_ios_release.sh [build|archive|upload]
#   build: Flutter iOS 빌드만 수행
#   archive: Xcode Archive 생성
#   upload: Archive 생성 후 App Store Connect 업로드 (선택사항)

set -e

echo "🍎 iOS Release Build Script"
echo "============================"

# 현재 버전 확인
VERSION=$(grep "version:" pubspec.yaml | head -1 | awk '{print $2}')
echo "📦 Current version: $VERSION"

# 클린 빌드
echo "🧹 Cleaning previous builds..."
flutter clean
flutter pub get

# 분석 실행
echo "🔍 Running analysis..."
flutter analyze

# 테스트 실행
echo "🧪 Running tests..."
flutter test

# iOS 빌드
echo "📱 Building iOS..."
flutter build ios --release --no-codesign

BUILD_TYPE=${1:-build}

case $BUILD_TYPE in
  build)
    echo "✅ iOS build completed!"
    echo "   Output: build/ios/iphoneos/Runner.app"
    echo ""
    echo "💡 Next steps:"
    echo "   1. Open ios/Runner.xcworkspace in Xcode"
    echo "   2. Select 'Any iOS Device' as target"
    echo "   3. Product → Archive"
    echo "   4. Distribute App → App Store Connect"
    ;;
  
  archive)
    echo "📦 Creating Archive..."
    
    # Xcode가 설치되어 있는지 확인
    if ! command -v xcodebuild &> /dev/null; then
      echo "❌ Xcode is not installed or xcodebuild is not in PATH"
      exit 1
    fi
    
    # Archive 생성
    xcodebuild -workspace ios/Runner.xcworkspace \
      -scheme Runner \
      -configuration Release \
      -archivePath build/Runner.xcarchive \
      archive
    
    echo "✅ Archive created: build/Runner.xcarchive"
    echo ""
    echo "💡 Next steps:"
    echo "   1. Open Xcode → Window → Organizer"
    echo "   2. Select the archive"
    echo "   3. Distribute App → App Store Connect"
    ;;
  
  upload)
    echo "📤 Uploading to App Store Connect..."
    
    # Archive 먼저 생성
    $0 archive
    
    # App Store Connect API 키 확인 필요
    if [ -z "$APP_STORE_API_KEY" ] || [ -z "$APP_STORE_ISSUER_ID" ]; then
      echo "⚠️  App Store Connect API credentials not set"
      echo "   Set APP_STORE_API_KEY and APP_STORE_ISSUER_ID environment variables"
      echo "   Or use Xcode Organizer to upload manually"
      exit 1
    fi
    
    # IPA 내보내기 및 업로드
    xcodebuild -exportArchive \
      -archivePath build/Runner.xcarchive \
      -exportPath build/ios/ipa \
      -exportOptionsPlist ios/ExportOptions.plist
    
    echo "✅ Upload completed!"
    ;;
  
  *)
    echo "❌ Unknown build type: $BUILD_TYPE"
    echo "Usage: $0 [build|archive|upload]"
    exit 1
    ;;
esac

echo ""
echo "🎉 Done! Version $VERSION is ready for deployment."

