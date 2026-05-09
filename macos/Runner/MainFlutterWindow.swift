// ===========================================================================
// MainFlutterWindow.swift
// ===========================================================================
// 固定窗口大小为 840x600，且不可调整（按用户要求）

import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {

    override func awakeFromNib() {
        let flutterViewController = FlutterViewController()

        // 固定窗口大小为 840x600
        let fixedFrame = NSRect(
            x: 0,
            y: 0,
            width: 840,
            height: 600
        )

        // 设置最小和最大尺寸相同，实现固定不可调整
        self.minSize = NSSize(width: 840, height: 600)
        self.maxSize = NSSize(width: 840, height: 600)

        self.setFrame(fixedFrame, display: true)

        // 记住窗口位置
        self.setFrameAutosaveName("MainWindow")

        // 首次启动居中，之后记住上次位置
        if UserDefaults.standard.string(forKey: "NSWindow Frame MainWindow") == nil {
            self.center()
        }

        // 标题栏透明
        self.titlebarAppearsTransparent = true
        self.styleMask.insert(.fullSizeContentView)
        self.title = ""
        self.titleVisibility = .hidden
        
        // 隐藏缩放按钮
        self.standardWindowButton(.zoomButton)?.isHidden = true

        self.contentViewController = flutterViewController
        RegisterGeneratedPlugins(registry: flutterViewController)

        super.awakeFromNib()
    }
}
