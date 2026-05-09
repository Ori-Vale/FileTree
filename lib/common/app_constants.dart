// 应用常量配置
class AppConstants {
  // 默认忽略的文件夹/文件列表（扫描时自动跳过）
  static const List<String> kDefaultIgnoreList = [
    '.git', // Git 版本控制目录
    '.DS_Store', // macOS 系统隐藏文件
    'node_modules', // Node.js 依赖目录
    '.dart_tool', // Dart 工具缓存目录
    '.idea', // IntelliJ IDEA 项目配置
    'build', // Flutter 构建输出目录
  ];

  // 扫描进度动画延迟毫秒数，用于提升仪式感
  static const int kScanAnimationDelayMs = 300;
}
