#!/bin/bash

# 4주차: 앱 배포 - Release 빌드 스크립트
#
# 사용법: ./build_release.sh [apk|appbundle|both]

set -e

echo "🚀 Flutter Release Build Script"
echo "================================"

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

# 빌드 타입 결정
BUILD_TYPE=${1:-both}

case $BUILD_TYPE in
  apk)
    echo "📱 Building APK..."
    flutter build apk --release
    echo "✅ APK built: build/app/outputs/flutter-apk/app-release.apk"
    ;;
  
  appbundle)
    echo "📦 Building App Bundle..."
    flutter build appbundle --release
    echo "✅ AAB built: build/app/outputs/bundle/release/app-release.aab"
    ;;
  
  both)
    echo "📱 Building APK..."
    flutter build apk --release
    
    echo "📦 Building App Bundle..."
    flutter build appbundle --release
    
    echo ""
    echo "✅ Build completed!"
    echo "   APK: build/app/outputs/flutter-apk/app-release.apk"
    echo "   AAB: build/app/outputs/bundle/release/app-release.aab"
    ;;
  
  *)
    echo "❌ Unknown build type: $BUILD_TYPE"
    echo "Usage: $0 [apk|appbundle|both]"
    exit 1
    ;;
esac

echo ""
echo "🎉 Done! Version $VERSION is ready for deployment."

