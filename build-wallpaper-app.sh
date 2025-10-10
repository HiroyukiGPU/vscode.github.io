#!/bin/bash
# Wallpaper Typing Animationアプリをビルドするスクリプト

echo "🔨 Building Wallpaper Typing Animation App..."

APP_NAME="WallpaperTyping"
BUILD_DIR="build"
APP_DIR="$BUILD_DIR/$APP_NAME.app"

# ビルドディレクトリを作成
mkdir -p "$BUILD_DIR"

# Swiftファイルをコンパイル
echo "📦 Compiling Swift code..."
swiftc WallpaperTyping.swift \
    -framework Cocoa \
    -framework WebKit \
    -o "$BUILD_DIR/$APP_NAME"

if [ $? -eq 0 ]; then
    echo "✓ Compilation successful"
else
    echo "✗ Compilation failed"
    exit 1
fi

# アプリバンドルを作成
echo "📱 Creating app bundle..."
mkdir -p "$APP_DIR/Contents/MacOS"
mkdir -p "$APP_DIR/Contents/Resources"

# 実行ファイルをコピー
cp "$BUILD_DIR/$APP_NAME" "$APP_DIR/Contents/MacOS/"

# Info.plistを作成
cat > "$APP_DIR/Contents/Info.plist" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>en</string>
    <key>CFBundleExecutable</key>
    <string>WallpaperTyping</string>
    <key>CFBundleIdentifier</key>
    <string>com.wallpaper.typing</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>WallpaperTyping</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>10.15</string>
    <key>NSMainStoryboardFile</key>
    <string>Main</string>
    <key>NSPrincipalClass</key>
    <string>NSApplication</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF

# index.htmlをアプリバンドルにコピー
if [ -f "index.html" ]; then
    cp index.html "$APP_DIR/Contents/Resources/"
    echo "✓ Copied index.html to app bundle"
fi

# 必要なファイルもコピー
for file in *.js *.py *.java *.c *.cpp *.cs *.php *.kt *.rb *.go *.sql *.ts *.sh *.rs *.dart *.asm *.swift *.r *.vb *.html *.css *.pl *.d *.nako *.m; do
    if [ -f "$file" ]; then
        cp "$file" "$APP_DIR/Contents/Resources/"
    fi
done

echo ""
echo "✓ Build complete!"
echo "📂 App location: $APP_DIR"
echo ""
echo "🚀 To run the app:"
echo "   open $APP_DIR"
echo ""
echo "📝 To install:"
echo "   cp -r $APP_DIR /Applications/"

