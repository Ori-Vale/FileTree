import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }

  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller = mainFlutterWindow?.contentViewController as! FlutterViewController
    registerAboutChannel(with: controller.registrar(forPlugin: "AboutChannel"))

    // 强制使用系统语言
    let language = Locale.preferredLanguages.first ?? "en"
    UserDefaults.standard.set([language], forKey: "AppleLanguages")
    UserDefaults.standard.synchronize()
  }

  private func registerAboutChannel(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "filetree/about", binaryMessenger: registrar.messenger)

    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "setAboutInfo" {
        guard let args = call.arguments as? [String: Any] else {
          result(FlutterError(code: "INVALID_ARGS", message: "Invalid arguments", details: nil))
          return
        }

        let credits = NSMutableAttributedString()

        if let description = args["description"] as? String {
          let paragraphStyle = NSMutableParagraphStyle()
          paragraphStyle.alignment = .left
          paragraphStyle.lineSpacing = 2

          let attributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11),
            .foregroundColor: NSColor.labelColor,
            .paragraphStyle: paragraphStyle,
            .kern: 0.5
          ]

          credits.append(NSAttributedString(string: description, attributes: attributes))
        }

        if let email = args["email"] as? String {
          let linkAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11),
            .foregroundColor: NSColor.linkColor,
            .link: "mailto:\(email)",
            .kern: 0.5
          ]

          let linkText = NSAttributedString(
            string: "反馈 & 建议: \(email)",
            attributes: linkAttributes
          )

          credits.append(NSAttributedString(string: "\n\n"))
          credits.append(linkText)
        }

        var options: [NSApplication.AboutPanelOptionKey: Any] = [
          .credits: credits
        ]

        if let version = args["version"] as? String {
          options[.version] = version
        }

        if let applicationName = args["applicationName"] as? String {
          options[.applicationName] = applicationName
        }

        NSApp.orderFrontStandardAboutPanel(options: options)
        result(nil)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
