import 'generator_base.dart';
import '../models/file_node.dart';
import '../common/app_strings.dart';

/// Text 格式生成器
///
/// 生成纯文本树形结构，使用 box-drawing 字符绘制连接线
class TextGenerator extends BaseGenerator {
  @override
  String get extension => 'txt';

  @override
  String get formatName => 'Text';

  @override
  Future<String> generate(FileNode root, String sourcePath) async {
    final buffer = StringBuffer();

    buffer.writeln('${AppStrings.appTitle} - ${root.name}');
    buffer.writeln('${AppStrings.sourcePath}: $sourcePath');
    buffer.writeln(
        '${AppStrings.dateTime}: ${DateTime.now().toString().substring(0, 19)}');
    buffer.writeln(
        '${AppStrings.statisticsInfo}: ${root.folderCount} ${AppStrings.rootFolderCount} | ${root.fileCount} ${AppStrings.rootFileCount}');
    buffer.writeln('');
    buffer.writeln('─' * 80);
    buffer.writeln('');
    buffer.writeln('▸ ${root.name}/');
    buffer.writeln('');

    if (root.children != null && root.children!.isNotEmpty) {
      _buildNode(buffer, root.children!, '');
    }

    return buffer.toString();
  }

  /// 递归构建文本节点，使用 box-drawing 字符绘制树形连接线
  void _buildNode(StringBuffer buffer, List<FileNode> children, String prefix) {
    for (int i = 0; i < children.length; i++) {
      final node = children[i];
      final isLast = i == children.length - 1;
      final connector = prefix + (isLast ? '└── ' : '├── ');

      if (node.isDirectory) {
        buffer.writeln('$connector▸ ${node.name}/');
        if (node.children != null && node.children!.isNotEmpty) {
          final newPrefix = prefix + (isLast ? '    ' : '│   ');
          _buildNode(buffer, node.children!, newPrefix);
        }
      } else {
        buffer.writeln('$connector• ${node.name} (${node.formattedSize})');
      }
    }
  }
}
