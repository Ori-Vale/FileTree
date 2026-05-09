import 'generator_base.dart';
import '../models/file_node.dart';
import '../common/app_strings.dart';

/// Markdown 格式生成器
///
/// 生成适合嵌入文档的 Markdown 树形结构
class MarkdownGenerator extends BaseGenerator {
  @override
  String get extension => 'md';

  @override
  String get formatName => 'Markdown';

  @override
  Future<String> generate(FileNode root, String sourcePath) async {
    final buffer = StringBuffer();

    buffer.writeln('# ${AppStrings.appTitle} - ${root.name}');
    buffer.writeln('${AppStrings.sourcePath}: $sourcePath');
    buffer.writeln(
        '${AppStrings.dateTime}: ${DateTime.now().toString().substring(0, 19)}');
    buffer.writeln(
        '${AppStrings.statisticsInfo}: ${root.folderCount} ${AppStrings.rootFolderCount} | ${root.fileCount} ${AppStrings.rootFileCount}');
    buffer.writeln('');
    buffer.writeln('---');
    buffer.writeln('');

    _buildNode(buffer, root, 0);

    return buffer.toString();
  }

  /// 递归构建 Markdown 节点
  void _buildNode(StringBuffer buffer, FileNode node, int depth) {
    final indent = '  ' * depth;
    final prefix = depth == 0 ? '' : '$indent- ';

    if (node.isDirectory) {
      buffer.writeln('$prefix▸ **${node.name}/**');
      if (node.children != null) {
        for (final child in node.children!) {
          _buildNode(buffer, child, depth + 1);
        }
      }
    } else {
      buffer.writeln('$prefix ${node.name} (${node.formattedSize})');
    }
  }
}
