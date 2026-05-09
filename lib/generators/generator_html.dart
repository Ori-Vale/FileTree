import 'generator_base.dart';
import '../models/file_node.dart';
import '../common/app_strings.dart';

/// HTML 格式生成器
///
/// 生成带折叠功能的树形结构 HTML 页面，采用 Ori Vale 家族化视觉风格
class HtmlGenerator extends BaseGenerator {
  @override
  String get extension => 'html';

  @override
  String get formatName => 'HTML';

  @override
  Future<String> generate(FileNode root, String sourcePath) async {
    final buffer = StringBuffer();

    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html lang="zh-CN">');
    buffer.writeln('<head>');
    buffer.writeln('    <meta charset="UTF-8">');
    buffer.writeln('    <title> ${AppStrings.appTitle} - ${root.name}</title>');
    buffer.writeln('    <style>');
    buffer.writeln(
        '        * { margin: 0; padding: 0; box-sizing: border-box; }');
    buffer.writeln(
        '        body { font-family: -apple-system, BlinkMacSystemFont, "SF Pro Text", system-ui, sans-serif; padding: 30px; line-height: 1.6; background: #F6F6F8; color: #000000; }');
    buffer.writeln('');
    buffer.writeln('        .header-card {');
    buffer.writeln('            background: #FFFFFF;');
    buffer.writeln('            border-radius: 16px;');
    buffer.writeln('            padding: 24px 28px;');
    buffer.writeln('            margin-bottom: 20px;');
    buffer.writeln('            box-shadow: 0 10px 10px rgba(0,0,0,0.06);');
    buffer.writeln('        }');
    buffer.writeln('        .header-card h1 {');
    buffer.writeln('            font-size: 22px;');
    buffer.writeln('            font-weight: 700;');
    buffer.writeln('            color: #000000;');
    buffer.writeln('            letter-spacing: -0.5px;');
    buffer.writeln('            margin-bottom: 16px;');
    buffer.writeln('        }');
    buffer.writeln('        .meta {');
    buffer.writeln('            font-size: 13px;');
    buffer.writeln('            color: #6E6E73;');
    buffer.writeln('            line-height: 1.8;');
    buffer.writeln('        }');
    buffer.writeln('        .meta strong {');
    buffer.writeln('            color: #000000;');
    buffer.writeln('            font-weight: 500;');
    buffer.writeln('        }');
    buffer.writeln('');
    buffer.writeln('        .toolbar-card {');
    buffer.writeln('            background: #FFFFFF;');
    buffer.writeln('            border-radius: 12px;');
    buffer.writeln('            padding: 14px 20px;');
    buffer.writeln('            margin-bottom: 20px;');
    buffer.writeln('            box-shadow: 0 10px 10px rgba(0,0,0,0.06);');
    buffer.writeln('            display: flex;');
    buffer.writeln('            align-items: center;');
    buffer.writeln('            gap: 16px;');
    buffer.writeln('            font-size: 13px;');
    buffer.writeln('            color: #6E6E73;');
    buffer.writeln('        }');
    buffer.writeln(
        '        .stats-inline span { color: #000000; font-weight: 600; }');
    buffer.writeln('');
    buffer.writeln('        .tree-card {');
    buffer.writeln('            background: #FFFFFF;');
    buffer.writeln('            border-radius: 16px;');
    buffer.writeln('            padding: 20px 28px;');
    buffer.writeln('            margin-bottom: 20px;');
    buffer.writeln('            box-shadow: 0 10px 10px rgba(0,0,0,0.06);');
    buffer.writeln('        }');
    buffer.writeln('        .tree { margin-left: 24px; }');
    buffer.writeln(
        '        .folder { color: #007AFF; font-weight: 600; cursor: pointer; user-select: none; padding: 3px 0; }');
    buffer.writeln('        .file { color: #34C759; padding: 3px 0; }');
    buffer.writeln('        .info { color: #6E6E73; font-size: 0.92em; }');
    buffer.writeln('        .hidden { display: none; }');
    buffer.writeln('');
    buffer.writeln('        button {');
    buffer.writeln('            padding: 14px 24px;');
    buffer.writeln('            background: #007AFF;');
    buffer.writeln('            color: white;');
    buffer.writeln('            border: none;');
    buffer.writeln('            border-radius: 12px;');
    buffer.writeln('            cursor: pointer;');
    buffer.writeln('            font-size: 15px;');
    buffer.writeln('            font-weight: 600;');
    buffer.writeln('            box-shadow: 0 10px 10px rgba(0,0,0,0.06);');
    buffer.writeln('            transition: background 0.2s;');
    buffer.writeln('        }');
    buffer.writeln('        button:hover { background: #0066CC; }');
    buffer.writeln('    </style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');

    buffer.writeln('    <div class="header-card">');
    buffer.writeln('        <h1> ${AppStrings.appTitle} - ${root.name}</h1>');
    buffer.writeln('        <div class="meta">');
    buffer.writeln(
        '            <strong>${AppStrings.sourcePath}:</strong> $sourcePath<br>');
    buffer.writeln(
        '            <strong>${AppStrings.dateTime}:</strong> ${DateTime.now().toString().substring(0, 19)}');
    buffer.writeln('        </div>');
    buffer.writeln('    </div>');

    buffer.writeln('    <div class="toolbar-card">');
    buffer.writeln(
        '        <button onclick="toggleAll(this)">${AppStrings.collapseAll}</button>');
    buffer.writeln('        <span class="stats-inline">');
    buffer.writeln(
        '            <span>${root.folderCount}</span> ${AppStrings.rootFolderCount} &nbsp;|&nbsp; <span>${root.fileCount}</span> ${AppStrings.rootFileCount}');
    buffer.writeln('        </span>');
    buffer.writeln('    </div>');

    buffer.writeln('    <div class="tree-card">');
    buffer.writeln('        <div id="treeRoot">');

    if (root.children != null) {
      for (final child in root.children!) {
        _buildHtmlNode(buffer, child, 0);
      }
    }

    buffer.writeln('        </div>');
    buffer.writeln('    </div>');

    buffer.writeln('    <script>');
    buffer.writeln('        function toggle(node) {');
    buffer.writeln('            const next = node.nextElementSibling;');
    buffer
        .writeln('            if (next && next.classList.contains("tree")) {');
    buffer.writeln('                next.classList.toggle("hidden");');
    buffer.writeln('            }');
    buffer.writeln('        }');
    buffer.writeln('        function toggleAll(btn) {');
    buffer.writeln(
        '            const subTrees = document.querySelectorAll("#treeRoot .tree");');
    buffer.writeln(
        '            const isAllHidden = Array.from(subTrees).every(t => t.classList.contains("hidden"));');
    buffer.writeln('            subTrees.forEach(t => {');
    buffer.writeln('                if (isAllHidden) {');
    buffer.writeln('                    t.classList.remove("hidden");');
    buffer.writeln('                } else {');
    buffer.writeln('                    t.classList.add("hidden");');
    buffer.writeln('                }');
    buffer.writeln('            });');
    buffer.writeln(
        '            btn.textContent = isAllHidden ? "${AppStrings.collapseAll}" : "${AppStrings.expandAll}";');
    buffer.writeln('        }');
    buffer.writeln('    </script>');
    buffer.writeln('</body>');
    buffer.writeln('</html>');

    return buffer.toString();
  }

  /// 递归构建 HTML 节点
  void _buildHtmlNode(StringBuffer buffer, FileNode node, int depth) {
    final indent = '    ' * (depth + 2);

    if (node.isDirectory) {
      buffer.writeln(
          '$indent<div class="folder" onclick="toggle(this)">▸ ${node.name}/</div>');
      if (node.children != null && node.children!.isNotEmpty) {
        buffer.writeln('$indent<div class="tree">');
        for (final child in node.children!) {
          _buildHtmlNode(buffer, child, depth + 1);
        }
        buffer.writeln('$indent</div>');
      }
    } else {
      buffer.writeln(
          '$indent<div class="file">${node.name} <span class="info">(${node.formattedSize})</span></div>');
    }
  }
}
