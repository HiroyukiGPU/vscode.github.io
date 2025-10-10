# 🖥️ Wallpaper Typing Animation for macOS

タイピングアニメーションをmacOSのデスクトップ背景として表示するSwiftアプリケーション。

## ✨ 機能

- 🎨 **デスクトップ背景表示** - HTMLアニメーションを壁紙として表示
- 🔄 **自動更新** - ファイル変更時に自動リロード
- 📱 **メニューバー統合** - メニューバーから簡単に操作
- 🎯 **全画面対応** - すべてのディスプレイサイズに対応
- 🚀 **軽量** - ネイティブSwift実装で高速動作

## 🔨 ビルド方法

### 方法1: 自動ビルドスクリプト（推奨）

```bash
# ビルドスクリプトを実行
./build-wallpaper-app.sh

# アプリを起動
open build/WallpaperTyping.app

# アプリをインストール（オプション）
cp -r build/WallpaperTyping.app /Applications/
```

### 方法2: Xcodeでビルド

1. **新しいXcodeプロジェクトを作成**
   ```
   - macOS App
   - Product Name: WallpaperTyping
   - Interface: SwiftUI
   - Language: Swift
   ```

2. **WallpaperTyping.swiftの内容をコピー**
   - ContentView.swiftを削除
   - WallpaperTyping.swiftをプロジェクトに追加

3. **Info.plistを編集**
   ```xml
   <key>LSUIElement</key>
   <true/>
   ```
   これでDockにアイコンが表示されなくなります。

4. **ビルド＆実行**
   - ⌘R でビルド＆実行

### 方法3: コマンドラインでビルド

```bash
# Swiftファイルをコンパイル
swiftc WallpaperTyping.swift \
    -framework Cocoa \
    -framework WebKit \
    -o WallpaperTyping

# 実行
./WallpaperTyping
```

## 📖 使い方

### 起動方法

```bash
# アプリを起動
open build/WallpaperTyping.app
```

または、Applicationsフォルダから起動。

### メニューバー操作

アプリ起動後、メニューバーに▶️アイコンが表示されます：

- **Show/Hide** (⌘H) - アニメーションの表示/非表示
- **Reload** (⌘R) - HTMLを再読み込み
- **Quit** (⌘Q) - アプリを終了

### HTMLファイルの配置

アプリは以下の順序でHTMLファイルを探します：

1. アプリと同じディレクトリの `index.html`
2. `~/Desktop/web/test/index.html`（デフォルト）

カスタムHTMLを使用する場合：

```bash
# アプリバンドルにHTMLをコピー
cp index.html build/WallpaperTyping.app/Contents/Resources/

# すべてのコードファイルもコピー
cp *.{js,py,java,c,cpp,nako,m} build/WallpaperTyping.app/Contents/Resources/
```

## ⚙️ カスタマイズ

### ウィンドウレベルの変更

WallpaperTyping.swiftの以下の行を編集：

```swift
// デスクトップ背景として表示
window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))

// または、通常のウィンドウとして表示
window.level = .normal
```

### 透明度の調整

```swift
window.backgroundColor = .black.withAlphaComponent(0.5)  // 半透明
```

### マウス操作の制御

```swift
// マウスクリックを無視（壁紙として完全に背景化）
window.ignoresMouseEvents = true

// マウス操作を受け付ける
window.ignoresMouseEvents = false
```

## 🚀 自動起動の設定

macOS起動時に自動的にアプリを開始する方法：

1. **システム設定を開く**
2. **「一般」→「ログイン項目」**
3. **「+」ボタンをクリック**
4. **WallpaperTyping.appを選択**

または、コマンドラインで：

```bash
# LaunchAgentを作成
cat > ~/Library/LaunchAgents/com.wallpaper.typing.plist << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.wallpaper.typing</string>
    <key>ProgramArguments</key>
    <array>
        <string>/Applications/WallpaperTyping.app/Contents/MacOS/WallpaperTyping</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

# LaunchAgentを読み込み
launchctl load ~/Library/LaunchAgents/com.wallpaper.typing.plist
```

## 🐛 トラブルシューティング

### HTMLが表示されない

1. **パスを確認**
   ```bash
   # 正しい場所にHTMLファイルがあるか確認
   ls ~/Desktop/web/test/index.html
   ```

2. **アプリバンドル内を確認**
   ```bash
   # アプリバンドル内のリソースを確認
   ls build/WallpaperTyping.app/Contents/Resources/
   ```

3. **コンソールログを確認**
   ```bash
   # アプリのログを確認
   log stream --predicate 'process == "WallpaperTyping"'
   ```

### アプリが起動しない

```bash
# ターミナルから直接実行してエラーを確認
./build/WallpaperTyping.app/Contents/MacOS/WallpaperTyping
```

### 権限エラー

```bash
# アプリに実行権限を付与
chmod +x build/WallpaperTyping.app/Contents/MacOS/WallpaperTyping

# セキュリティ設定を確認
xattr -d com.apple.quarantine build/WallpaperTyping.app
```

## 📝 システム要件

- macOS 10.15 (Catalina) 以降
- Xcode Command Line Tools（ビルド時のみ）

## 🔧 開発者向け

### デバッグモード

```swift
// WallpaperTyping.swift内で以下を有効化
window.level = .normal  // 通常ウィンドウとして表示
window.ignoresMouseEvents = false  // マウス操作可能
```

### ホットリロード

ファイル変更を監視して自動リロード：

```bash
# fswatch（Homebrewでインストール）を使用
brew install fswatch

# ファイル変更を監視
fswatch -o index.html | while read; do
    osascript -e 'tell application "WallpaperTyping" to reload'
done
```

## 📄 ライセンス

MIT License - 自由に使用、変更、配布できます。

---

Made with ❤️ for macOS

