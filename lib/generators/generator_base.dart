import '../models/file_node.dart';

/// 文件树生成器抽象基类
///
/// 所有格式生成器（HTML、Markdown、Text）必须继承此类并实现 [generate] 方法
abstract class BaseGenerator {
  /// 文件扩展名（如 'html'、'md'、'txt'）
  String get extension;

  /// 格式名称（如 'HTML'、'Markdown'、'Text'）
  String get formatName;

  /// 默认输出文件名前缀
  String get defaultFileName => "FileTree";

  /// 生成文件树内容
  ///
  /// [root] 文件树根节点
  /// [sourcePath] 扫描的源路径
  /// 返回格式化后的字符串内容
  Future<String> generate(FileNode root, String sourcePath);

  /// 生成带时间戳的文件名
  ///
  /// 格式：{defaultFileName}_{YYYYMMDD_HHmm}
  String generateFileName() {
    final now = DateTime.now();
    final timestamp = '${now.year}'
        '${now.month.toString().padLeft(2, '0')}'
        '${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}'
        '${now.minute.toString().padLeft(2, '0')}';

    return '${defaultFileName}_$timestamp';
  }
}
