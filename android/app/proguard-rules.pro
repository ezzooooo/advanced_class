# 7주차: 앱 보안 - ProGuard 설정
#
# Release 빌드 시 코드 난독화를 위한 규칙

# ===========================
# Flutter 기본 규칙
# ===========================
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.embedding.** { *; }

# ===========================
# Firebase 규칙
# ===========================
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Crashlytics
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# ===========================
# flutter_secure_storage 규칙
# ===========================
-keep class com.it_nomads.fluttersecurestorage.** { *; }

# ===========================
# 일반 규칙
# ===========================

# 열거형 유지
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Serializable 클래스 유지
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Parcelable 유지
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}

# ===========================
# 디버깅을 위한 설정
# ===========================

# 스택 트레이스 유지 (Crashlytics 분석용)
-keepattributes SourceFile,LineNumberTable

# 원본 소스 파일 이름 유지
-renamesourcefileattribute SourceFile

