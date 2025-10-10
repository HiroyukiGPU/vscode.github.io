// Swift macOS App - HTML Wallpaper Typing Animation
// macOSのデスクトップ背景としてHTMLを表示するアプリ

import Cocoa
import WebKit

// メインのアプリケーションデリゲート
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var window: NSWindow!
    var webView: WKWebView!
    
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
        window.ignoresMouseEvents = false  // マウス操作を受け付ける
        
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
        // アプリと同じディレクトリのindex.htmlを探す
        let executablePath = Bundle.main.executablePath ?? ""
        let appDirectory = (executablePath as NSString).deletingLastPathComponent
        let htmlPath = (appDirectory as NSString).appendingPathComponent("index.html")
        
        if FileManager.default.fileExists(atPath: htmlPath) {
            return "file://\(htmlPath)"
        }
        
        // 見つからない場合はデフォルトのパス
        let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first ?? ""
        let fallbackPath = (desktopPath as NSString).appendingPathComponent("web/test/index.html")
        return "file://\(fallbackPath)"
    }
    
    var statusItem: NSStatusItem?
    
    // メニューバーにステータスアイテムを作成
    func createStatusBarItem() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "play.rectangle.fill", accessibilityDescription: "Typing Animation")
            button.action = #selector(statusBarButtonClicked(_:))
        }
        
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Show/Hide", action: #selector(toggleVisibility), keyEquivalent: "h"))
        menu.addItem(NSMenuItem(title: "Reload", action: #selector(reloadWebView), keyEquivalent: "r"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "q"))
        
        statusItem?.menu = menu
    }
    
    @objc func statusBarButtonClicked(_ sender: Any?) {
        // メニューを表示
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

// MARK: - SwiftUI版（macOS 11.0以降）

import SwiftUI

@available(macOS 11.0, *)
struct WallpaperView: View {
    @State private var isVisible = true
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.001)
            
            WebView(url: getHTMLURL())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
        }
        .opacity(isVisible ? 1 : 0)
    }
    
    func getHTMLURL() -> URL {
        // index.htmlのURLを返す
        let desktopPath = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let htmlURL = desktopPath.appendingPathComponent("web/test/index.html")
        return htmlURL
    }
}

@available(macOS 11.0, *)
struct WebView: NSViewRepresentable {
    let url: URL
    
    func makeNSView(context: Context) -> WKWebView {
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.setValue(false, forKey: "drawsBackground")
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        return webView
    }
    
    func updateNSView(_ nsView: WKWebView, context: Context) {
        // 更新処理
    }
}

// MARK: - アプリのエントリーポイント（SwiftUI版）

@available(macOS 11.0, *)
@main
struct WallpaperTypingApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            WallpaperView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
    }
}

