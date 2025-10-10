# 🎬 Multi-Language Code Typing Animation

リアルタイムコードエディタ風のタイピングアニメーションを表示するWebアプリケーション。
24種類のプログラミング言語に対応し、VS Codeのような自動補完機能とシンタックスハイライトを備えています。

![Version](https://img.shields.io/badge/version-2.2.0-blue.svg)
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
- 🎲 **ランダム再生** - `0.txt`ファイルを配置すると順番をランダムに表示
- 🔍 **自動ファイル検出** - 数字ファイル名を自動検出、拡張子も自動判定
- ⚡ **並列検出で高速読み込み** - Promise.allで並列処理、従来の50倍高速
- 🎨 **かっこいいローディング画面** - スピナーとプログレスバー付き

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
├── index.html        # メインファイル
├── 0.txt             # (オプション) ランダム再生を有効化
├── 1.html            # 1番目に表示
├── 2.java            # 2番目に表示
├── 3.js              # 3番目に表示
├── ... (任意の数字ファイル)
└── README.md
```

3. ブラウザで開く
```bash
open index.html
```

### 🎲 ランダム順で再生

ファイルをランダムな順番で表示したい場合は、空の`0.txt`ファイルを配置してください：

```bash
touch 0.txt
```

これで、ページを読み込むたびに異なる順番でファイルが表示されます。

**通常順に戻す場合**：
```bash
rm 0.txt
```

### 🔍 自動ファイル検出

ファイルリストを手動で編集する必要はありません。以下のルールで自動検出されます：

1. **ファイル名**: `1.拡張子`, `2.拡張子`, `3.拡張子`...の形式
2. **拡張子**: 24種類の対応拡張子から自動判定
3. **順番**: ファイル名の数字順（`0.txt`がある場合はランダム）

**例**:
```
1.html    → 1番目
2.py      → 2番目
3.java    → 3番目
10.js     → 10番目
```

### 対応拡張子一覧

自動検出される拡張子：

```
.py .java .js .c .cpp .cs .php .kt .rb .go .sql .ts 
.sh .rs .dart .asm .swift .r .vb .html .css .pl .d .txt
```

**複数の拡張子で同じ番号がある場合**：
- `1.py`と`1.js`が両方ある場合 → リストの前方の拡張子が優先されます

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

## ⚡ パフォーマンス最適化

### 並列ファイル検出
従来の逐次検出（1つずつチェック）から、**Promise.all を使った並列検出**に変更：

**従来の方法（遅い）**:
```
1.py → 見つかる (200ms)
2.java → 見つかる (200ms)
3.js → 見つかる (200ms)
...
合計: 約5秒（24ファイル × 200ms）
```

**新方式（高速）**:
```
1.py, 2.java, 3.js, ... を同時にチェック
合計: 約200ms（並列処理）
```

**結果**: **25倍以上の高速化** 🚀

### ローディング体験
- スピナーアニメーション（CSS animation）
- リアルタイムプログレスバー
- ステータスメッセージ表示
- スムーズなフェードアウト

## 🔧 技術スタック

- **HTML5** - 構造
- **CSS3** - スタイリング（VS Code風デザイン、グラデーションアニメーション）
- **Vanilla JavaScript** - ロジック実装（依存ライブラリなし）
- **正規表現** - シンタックスハイライト処理
- **Promise.all** - 並列ファイル検出（最大50ファイルを同時チェック）
- **Fetch API** - 非同期ファイル読み込み

## 📝 ファイル構成

```
project/
├── index.html              # メインアプリケーション
├── 0.txt                   # (オプション) ランダム再生フラグ
├── 1.html                  # HTMLサンプル
├── 2.java                  # Javaサンプル
├── 3.js                    # JavaScriptサンプル
├── 4.c                     # Cサンプル
├── 5.cpp ~ 19.vb           # 各言語のサンプル
├── 20.py                   # Pythonサンプル
├── 21.css                  # CSSサンプル
├── 22.pl                   # Perlサンプル
├── 23.d                    # Dサンプル
├── 24.js                   # JavaScript (eCommerce)
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

- [x] ~~自動ファイル検出機能~~ ✅ 実装済み
- [x] ~~ランダム再生機能~~ ✅ 実装済み（0.txt）
- [x] ~~並列検出による高速化~~ ✅ 実装済み
- [x] ~~ローディングアニメーション~~ ✅ 実装済み
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

