# 🎬 Multi-Language Code Typing Animation

リアルタイムコードエディタ風のタイピングアニメーションを表示するWebアプリケーション。
24種類のプログラミング言語に対応し、VS Codeのような自動補完機能とシンタックスハイライトを備えています。

![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Languages](https://img.shields.io/badge/languages-24-orange.svg)

## ✨ 特徴

- 🌈 **24言語対応** - Python, Java, JavaScript, C, C++, C#, PHP, Kotlin, Ruby, Go, SQL, TypeScript, Shell, Rust, Dart, Assembly, Swift, R, Visual Basic, HTML, CSS, Perl, D
- 🎨 **リアルタイムシンタックスハイライト** - 各言語のキーワード、文字列、コメントを自動で色分け
- 🔄 **自動ファイル切り替え** - ファイルが終わると自動的に次のファイルへ移動し、無限ループ
- 💡 **VS Code風の自動補完** - `(`, `{`, `[` を入力すると自動的に対応する閉じ括弧を表示
- 📏 **行番号表示** - エディタ風の行番号とスクロール同期
- ⚡ **高速タイピング** - 50文字/秒のスムーズなアニメーション
- 🎯 **TAB対応** - インデントをTAB文字として正しく表示

## 🎥 デモ

```
// ホワイトボード機能の実装
class Whiteboard {
    constructor() {
      this.canvas = document.getElementById('whiteboard-canvas');
      this.ctx = this.canvas.getContext('2d');|  ← カーソル
    }
}
```

## 🚀 使い方

### 基本的な使い方

1. リポジトリをクローン
```bash
git clone https://github.com/yourusername/code-typing-animation.git
cd code-typing-animation
```

2. 表示したいコードファイルを配置
```
project/
├── typing-animation.html
├── 1.py
├── 2.java
├── 3.js
├── 4.c
├── ... (24.jsまで)
└── README.md
```

3. ブラウザで開く
```bash
open typing-animation.html
```

### ファイルリストのカスタマイズ

`typing-animation.html` の98行目を編集：

```javascript
// 表示したいファイルを追加
const codeFiles = ['1.js', '2.js', '3.js', 'main.js'];
```

### 複数言語の例

```javascript
const codeFiles = [
    '1.py',       // Python
    '2.java',     // Java
    '3.js',       // JavaScript
    '4.c',        // C
    '5.cpp',      // C++
    '6.cs',       // C#
    '7.php',      // PHP
    '8.kt',       // Kotlin
    '9.rb',       // Ruby
    '10.go',      // Go
    '11.sql',     // SQL
    '12.ts',      // TypeScript
    '13.sh',      // Shell
    '14.rs',      // Rust
    '15.dart',    // Dart
    '16.asm',     // Assembly
    '17.swift',   // Swift
    '18.r',       // R
    '19.vb',      // Visual Basic
    '20.html',    // HTML
    '21.css',     // CSS
    '22.pl',      // Perl
    '23.d',       // D
    '24.js'       // JavaScript (eCommerce)
];
```

## 📚 対応言語と拡張子

| 言語 | 拡張子 | コメント構文 | 主なキーワード |
|------|--------|-------------|---------------|
| **Python** | `.py` | `#`, `'''` | `def`, `class`, `if`, `for`, `import` |
| **Java** | `.java` | `//`, `/* */` | `class`, `public`, `void`, `static` |
| **JavaScript** | `.js` | `//`, `/* */` | `function`, `const`, `let`, `async` |
| **C** | `.c` | `//`, `/* */` | `int`, `struct`, `if`, `for` |
| **C++** | `.cpp`, `.cc` | `//`, `/* */` | `class`, `namespace`, `template` |
| **C#** | `.cs` | `//`, `/* */` | `class`, `namespace`, `async`, `await` |
| **PHP** | `.php` | `//`, `/* */` | `class`, `function`, `echo`, `namespace` |
| **Kotlin** | `.kt` | `//`, `/* */` | `fun`, `val`, `var`, `when` |
| **Ruby** | `.rb` | `#` | `def`, `class`, `if`, `do`, `end` |
| **Go** | `.go` | `//`, `/* */` | `func`, `package`, `import`, `defer` |
| **SQL** | `.sql` | `--`, `/* */` | `SELECT`, `FROM`, `WHERE`, `JOIN` |
| **TypeScript** | `.ts` | `//`, `/* */` | `interface`, `type`, `enum`, `async` |
| **Shell** | `.sh`, `.bash` | `#` | `if`, `then`, `for`, `echo` |
| **Rust** | `.rs` | `//`, `/* */` | `fn`, `let`, `mut`, `impl`, `trait` |
| **Dart** | `.dart` | `//`, `/* */` | `class`, `void`, `async`, `await` |
| **Assembly** | `.asm`, `.s` | `;` | `mov`, `push`, `pop`, `jmp` |
| **Swift** | `.swift` | `//`, `/* */` | `func`, `var`, `let`, `class` |
| **R** | `.r` | `#` | `function`, `if`, `for`, `library` |
| **Visual Basic** | `.vb` | `'` | `Class`, `Function`, `Sub`, `If` |
| **HTML** | `.html` | `<!-- -->` | `div`, `span`, `class`, `id`, `form` |
| **CSS** | `.css` | `/* */` | `color`, `background`, `display`, `flex` |
| **Perl** | `.pl` | `#`, `=begin/=cut` | `sub`, `my`, `if`, `foreach` |
| **D** | `.d` | `//`, `/* */` | `class`, `struct`, `import`, `auto` |

## ⚙️ カスタマイズ

### タイピング速度の変更

104行目を編集：
```javascript
let typingSpeed = 20; // ミリ秒 (デフォルト: 20ms = 50文字/秒)
```

例：
```javascript
let typingSpeed = 10;  // 高速: 100文字/秒
let typingSpeed = 50;  // 低速: 20文字/秒
```

### インデント設定の変更

スペースをTABに変換する際の設定（128行目付近）：
```javascript
// 2スペースごとに1タブに変換
const tabs = '\t'.repeat(Math.floor(spaces / 2));
```

4スペースインデントの場合：
```javascript
// 4スペースごとに1タブに変換
const tabs = '\t'.repeat(Math.floor(spaces / 4));
```

### ファイル切り替え待機時間

195行目を編集：
```javascript
setTimeout(() => {
    loadCurrentFile();
}, 1000); // 1秒待機（ミリ秒）
```

### カラーテーマの変更

CSSを編集してお好みのカラーテーマに：
```css
/* VS Code Dark+ テーマ（デフォルト） */
.keyword { color: #569cd6; }      /* 青 */
.string { color: #ce9178; }       /* オレンジ */
.comment { color: #6a9955; }      /* 緑 */
.function { color: #dcdcaa; }     /* 黄色 */
.number { color: #b5cea8; }       /* 薄緑 */
.property { color: #9cdcfe; }     /* 水色 */
```

## 🎨 シンタックスハイライトの仕組み

1. **言語検出**: ファイル拡張子から自動的に言語を判定
2. **コメント処理**: 各言語のコメント構文（`//`, `#`, `;` など）を認識
3. **文字列保護**: 文字列内のキーワードをハイライトしないよう保護
4. **キーワード**: 各言語専用のキーワードリストを使用
5. **関数名**: 関数呼び出しを自動検出
6. **数値**: 10進数、16進数をサポート

## 🔧 技術スタック

- **HTML5** - 構造
- **CSS3** - スタイリング（VS Code風デザイン）
- **Vanilla JavaScript** - ロジック実装（依存ライブラリなし）
- **正規表現** - シンタックスハイライト処理

## 📝 ファイル構成

```
project/
├── typing-animation.html    # メインアプリケーション
├── 1.py                     # Pythonサンプル
├── 2.java                   # Javaサンプル
├── 3.js                     # JavaScriptサンプル
├── 4.c                      # Cサンプル
├── ... (5.cpp ~ 19.vb)
├── 20.html                  # HTMLサンプル
├── 21.css                   # CSSサンプル
├── 22.pl                    # Perlサンプル
├── 23.d                     # Dサンプル
├── 24.js                    # JavaScript (eCommerce)
└── README.md               # このファイル
```

## 🌟 使用例

### プレゼンテーションでの使用
コードの説明をする際に、実際に書いているような演出が可能

### プロモーション動画
ソフトウェアやライブラリの紹介動画の背景として

### ポートフォリオ
開発者のポートフォリオサイトのヒーローセクションとして

### 教育用途
プログラミング学習サイトでのコード解説

## 🐛 既知の制限事項

- ファイルは同じディレクトリに配置する必要があります
- ローカルファイルシステムからの読み込みには、ローカルサーバーが必要な場合があります
- 非常に大きなファイル（10,000行以上）では動作が遅くなる可能性があります

## 🔜 今後の予定

- [ ] タイピング速度の動的調整（UI追加）
- [ ] ファイル切り替えアニメーション
- [ ] テーマ切り替え機能（Light/Dark）
- [ ] 一時停止/再開ボタン
- [ ] ファイルドラッグ&ドロップ対応
- [ ] エクスポート機能（GIF/動画）

## 📄 ライセンス

MIT License - 自由に使用、変更、配布できます。

## 👤 作者

GitHub: [@yourusername](https://github.com/yourusername)

## 🤝 貢献

プルリクエストを歓迎します！大きな変更の場合は、まずissueを開いて変更内容について議論してください。

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## ⭐ Star History

このプロジェクトが役に立った場合は、ぜひスターをつけてください！

---

Made with ❤️ and ☕

