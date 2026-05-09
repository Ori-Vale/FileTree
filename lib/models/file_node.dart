import 'dart:io';

/// 文件树节点模型
/// 递归表示目录结构中的文件和文件夹
class FileNode {
  // ---------------------------------------------------------------------------
  // 属性
  // ---------------------------------------------------------------------------

  final String name;
  final String path;
  final bool isDirectory;
  final int size;
  final DateTime modifiedTime;
  List<FileNode>? children;

  FileNode({
    required this.name,
    required this.path,
    required this.isDirectory,
    this.size = 0,
    required this.modifiedTime,
    this.children,
  });

  // ---------------------------------------------------------------------------
  // 工厂方法
  // ---------------------------------------------------------------------------

  /// 从 Dart 文件系统实体创建 FileNode
  factory FileNode.fromEntity(FileSystemEntity entity) {
    final stat = FileStat.statSync(entity.path);
    final isDir = FileSystemEntity.isDirectorySync(entity.path);

    return FileNode(
      name: entity.path.split(Platform.pathSeparator).last,
      path: entity.path,
      isDirectory: isDir,
      size: isDir ? 0 : stat.size,
      modifiedTime: stat.modified,
    );
  }

  // ---------------------------------------------------------------------------
  // 格式化
  // ---------------------------------------------------------------------------

  /// 格式化文件大小（如 1.2 MB），文件夹返回空字符串
  String get formattedSize {
    if (isDirectory) return '';

    const units = ['B', 'KB', 'MB', 'GB', 'TB'];
    var sizeInBytes = size.toDouble();
    var unitIndex = 0;

    while (sizeInBytes >= 1024 && unitIndex < units.length - 1) {
      sizeInBytes /= 1024;
      unitIndex++;
    }

    return '${sizeInBytes.toStringAsFixed(1)} ${units[unitIndex]}';
  }

  /// 格式化修改时间（YYYY-MM-DD HH:MM:SS）
  String get formattedModifiedTime {
    return '${modifiedTime.year}-'
        '${modifiedTime.month.toString().padLeft(2, '0')}-'
        '${modifiedTime.day.toString().padLeft(2, '0')} '
        '${modifiedTime.hour.toString().padLeft(2, '0')}:'
        '${modifiedTime.minute.toString().padLeft(2, '0')}:'
        '${modifiedTime.second.toString().padLeft(2, '0')}';
  }

  // ---------------------------------------------------------------------------
  // 统计
  // ---------------------------------------------------------------------------

  /// 递归统计所有文件数量
  int get fileCount {
    if (!isDirectory) return 1;
    if (children == null) return 0;
    return children!.fold(0, (sum, child) => sum + child.fileCount);
  }

  /// 递归统计所有文件夹数量（包含自身）
  int get folderCount {
    if (!isDirectory) return 0;
    if (children == null) return 1;
    return 1 + children!.fold(0, (sum, child) => sum + child.folderCount);
  }

  @override
  String toString() {
    return 'FileNode(name: $name, isDirectory: $isDirectory, size: $formattedSize)';
  }
}
