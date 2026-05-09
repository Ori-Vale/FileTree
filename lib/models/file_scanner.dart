import 'dart:io';
import 'package:flutter/foundation.dart';
import 'file_node.dart';

/// 目录扫描器
/// 递归遍历指定目录，构建文件树结构
class FileScanner {
  /// 扫描指定路径，返回完整的目录树根节点
  ///
  /// [path] 要扫描的根目录路径
  /// [ignoreList] 需要忽略的文件夹/文件名称列表
  /// [onProgress] 扫描进度回调，每扫描完一个目录层级调用一次
  static Future<FileNode> scan(
    String path, {
    List<String> ignoreList = const [],
    Function(int folders, int files)? onProgress,
  }) async {
    final rootNode = FileNode.fromEntity(Directory(path));
    rootNode.children = await _recursiveScan(path, ignoreList, onProgress);
    return rootNode;
  }

  // ---------------------------------------------------------------------------
  // 内部实现
  // ---------------------------------------------------------------------------

  /// 递归扫描当前目录下的所有子节点
  ///
  /// 返回排序后的子节点列表（文件夹在前，文件在后，同类按名称排序）
  static Future<List<FileNode>> _recursiveScan(
    String path,
    List<String> ignoreList,
    Function(int, int)? onProgress,
  ) async {
    final List<FileNode> children = [];

    try {
      final entities = await Directory(path).list().toList();

      int folders = 0;
      int files = 0;

      for (final entity in entities) {
        final name = entity.path.split(Platform.pathSeparator).last;
        if (ignoreList.contains(name)) continue;

        if (entity is Directory) {
          folders++;
          final dirNode = FileNode.fromEntity(entity);
          dirNode.children =
              await _recursiveScan(entity.path, ignoreList, onProgress);
          children.add(dirNode);
        } else {
          files++;
          children.add(FileNode.fromEntity(entity));
        }
      }

      onProgress?.call(folders, files);

      // 排序：文件夹在前，文件在后，同类按名称字母序
      children.sort((a, b) {
        if (a.isDirectory && !b.isDirectory) return -1;
        if (!a.isDirectory && b.isDirectory) return 1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    } catch (e) {
      debugPrint('无法读取目录 $path: $e');
    }

    return children;
  }
}
