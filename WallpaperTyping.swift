// Swift macOS App - HTML Wallpaper Typing Animation
// macOSのデスクトップ背景としてHTMLを表示するアプリ

import Cocoa
import WebKit

// メインのアプリケーションデリゲート
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    var webView: WKWebView!
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // 画面サイズを取得
        guard let screen = NSScreen.main else { return }
        let screenFrame = screen.frame
        
        // ウィンドウを作成（フルスクリーン、枠なし）
        window = NSWindow(
            contentRect: screenFrame,
            styleMask: [.borderless],
            backing: .buffered,
            defer: false
        )
        
        // ウィンドウの設定
        window.backgroundColor = .black
        window.isOpaque = false
        window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopWindow)))
        window.collectionBehavior = [.canJoinAllSpaces, .stationary]
        window.ignoresMouseEvents = false
        
        // WebViewの設定
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        webView = WKWebView(frame: screenFrame, configuration: webConfiguration)
        webView.setValue(false, forKey: "drawsBackground")
        
        // HTMLファイルのパスを取得
        let htmlPath = getHTMLPath()
        
        if let url = URL(string: htmlPath) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
        // ウィンドウにWebViewを追加
        window.contentView = webView
        window.makeKeyAndOrderFront(nil)
        
        // メニューバーにアイコンを追加
        createStatusBarItem()
        
        print("✓ Wallpaper Typing Animation started")
        print("📂 Loading: \(htmlPath)")
    }
    
    // HTMLファイルのパスを取得
    func getHTMLPath() -> String {
        // 実行ファイルのディレクトリを取得
        let executablePath = CommandLine.arguments[0]
        let executableDir = (executablePath as NSString).deletingLastPathComponent
        
        // 同じディレクトリのindex.htmlを探す
        let htmlPath = (executableDir as NSString).appendingPathComponent("index.html")
        
        if FileManager.default.fileExists(atPath: htmlPath) {
            return "file://\(htmlPath)"
        }
        
        // リソースディレクトリを探す
        if let bundlePath = Bundle.main.resourcePath {
            let bundleHtmlPath = (bundlePath as NSString).appendingPathComponent("index.html")
            if FileManager.default.fileExists(atPath: bundleHtmlPath) {
                return "file://\(bundleHtmlPath)"
            }
        }
        
        // デフォルトパス
        let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first ?? ""
        let fallbackPath = (desktopPath as NSString).appendingPathComponent("web/test/index.html")
        return "file://\(fallbackPath)"
    }
    
    // メニューバーにステータスアイテムを作成
    func createStatusBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "play.rectangle.fill", accessibilityDescription: "Typing Animation")
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Show/Hide", action: #selector(toggleVisibility), keyEquivalent: "h"))
        menu.addItem(NSMenuItem(title: "Reload", action: #selector(reloadWebView), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func toggleVisibility() {
        if window.isVisible {
            window.orderOut(nil)
            print("🙈 Hidden")
        } else {
            window.makeKeyAndOrderFront(nil)
            print("👀 Shown")
        }
    }
    
    @objc func reloadWebView() {
        webView.reload()
        print("🔄 Reloaded")
    }
    
    @objc func quitApp() {
        NSApplication.shared.terminate(nil)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("✓ Application terminated")
    }
}

// メイン実行
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()
