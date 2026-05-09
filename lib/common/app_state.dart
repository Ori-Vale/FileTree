import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'dart:io';
import 'dart:convert';
import 'app_strings.dart';
import 'app_constants.dart';
import '../models/file_node.dart';
import '../models/file_scanner.dart';
import '../generators/generators.dart';

/// 应用核心状态管理类
///
/// 管理输入目录、文件树、扫描进度、格式选择、输出路径和消息通知
class AppState extends ChangeNotifier {
  // ---------------------------------------------------------------------------
  // 输入与扫描状态
  // ---------------------------------------------------------------------------

  String? _inputDirectory;
  FileNode? _treeRoot;
  int _displayFolderCount = 0;
  int _displayFileCount = 0;
  bool _isScanning = false;

  // ---------------------------------------------------------------------------
  // 输出格式选择
  // ---------------------------------------------------------------------------

  final Map<String, bool> _selectedFormats = {
    'Html': true,
    'Markdown': true,
    'Text': true,
  };

  // ---------------------------------------------------------------------------
  // 输出路径
  // ---------------------------------------------------------------------------

  String _outputDirectory = '';

  // ---------------------------------------------------------------------------
  // 消息通知
  // ---------------------------------------------------------------------------

  String? _snackbarMessage;
  bool _isError = false;
  int _messageVersion = 0;

  // ---------------------------------------------------------------------------
  // Getter
  // ---------------------------------------------------------------------------

  String? get inputDirectory => _inputDirectory;
  FileNode? get treeRoot => _treeRoot;
  int get displayFolderCount => _displayFolderCount;
  int get displayFileCount => _displayFileCount;
  bool get isScanning => _isScanning;
  Map<String, bool> get selectedFormats => _selectedFormats;
  String get outputDirectory => _outputDirectory;
  String? get snackbarMessage => _snackbarMessage;
  bool get isError => _isError;

  /// 是否至少选择了一种输出格式
  bool get hasSelectedFormat => _selectedFormats.values.contains(true);

  /// 是否满足生成条件（输入目录、输出目录、格式选择均就绪）
  bool get canGenerate =>
      _inputDirectory != null &&
      _outputDirectory.isNotEmpty &&
      hasSelectedFormat;

  // ---------------------------------------------------------------------------
  // 目录选择
  // ---------------------------------------------------------------------------

  /// 选择输入目录并自动开始扫描
  Future<void> pickDirectory() async {
    final String? directoryPath = await getDirectoryPath();
    if (directoryPath != null) {
      _inputDirectory = directoryPath;
      _treeRoot = null;
      _displayFolderCount = 0;
      _displayFileCount = 0;
      notifyListeners();

      await scanDirectory();
    }
  }

  /// 选择输出目录
  Future<void> setOutputDirectory() async {
    final String? path = await getDirectoryPath();
    if (path != null) {
      _outputDirectory = path;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // 扫描
  // ---------------------------------------------------------------------------

  /// 执行目录扫描
  Future<void> scanDirectory() async {
    if (_inputDirectory == null) return;

    _isScanning = true;
    _displayFolderCount = 0;
    _displayFileCount = 0;
    notifyListeners();

    try {
      _treeRoot = await FileScanner.scan(
        _inputDirectory!,
        ignoreList: AppConstants.kDefaultIgnoreList,
        onProgress: (folders, files) {
          // 进度动画：每次回调只更新 10%，营造渐进仪式感
          _displayFolderCount += (folders * 0.1).round();
          _displayFileCount += (files * 0.1).round();
          notifyListeners();
        },
      );

      if (_treeRoot != null) {
        _displayFolderCount = _treeRoot!.folderCount;
        _displayFileCount = _treeRoot!.fileCount;
      }

      _showMessage(
        AppStrings.scanComplete
            .replaceAll('{folderCount}', _displayFolderCount.toString())
            .replaceAll('{fileCount}', _displayFileCount.toString()),
      );
    } catch (e) {
      if (e is PathAccessException) {
        _showError(AppStrings.scanFailedPermissionDenied);
      } else if (e is PathNotFoundException) {
        _showError(AppStrings.scanFailedDirNotFound);
      } else if (e is FileSystemException) {
        _showError(AppStrings.scanFailedDiskError);
      } else {
        _showError(AppStrings.scanFailedUnknown);
      }
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // 格式切换
  // ---------------------------------------------------------------------------

  /// 切换指定格式的选中状态
  void toggleFormat(String format) {
    if (_selectedFormats.containsKey(format)) {
      _selectedFormats[format] = !(_selectedFormats[format]!);
      notifyListeners();
    }
  }

  // ---------------------------------------------------------------------------
  // 文件生成
  // ---------------------------------------------------------------------------

  /// 开始生成文件树（前置条件校验后调用内部方法）
  Future<void> startGeneration() async {
    if (_inputDirectory == null) {
      _showError(AppStrings.noInputDirSelected);
      return;
    }
    if (_outputDirectory.isEmpty) {
      _showError(AppStrings.noOutputDirSelected);
      return;
    }
    if (!hasSelectedFormat) {
      _showError(AppStrings.noFormatSelected);
      return;
    }
    if (_treeRoot == null) {
      _showError(AppStrings.scanInProgressButton);
      return;
    }

    await _generateFiles();
  }

  /// 生成文件的核心逻辑：遍历选中格式，调用对应生成器写入文件
  Future<void> _generateFiles() async {
    try {
      final generators = {
        'Html': HtmlGenerator(),
        'Markdown': MarkdownGenerator(),
        'Text': TextGenerator(),
      };

      List<String> generatedFiles = [];

      for (var format in generators.keys) {
        if (_selectedFormats[format] != true) continue;

        final generator = generators[format]!;
        final content = await generator.generate(_treeRoot!, _inputDirectory!);

        final fileName =
            '${generator.generateFileName()}.${generator.extension}';
        final file = File('$_outputDirectory/$fileName');
        await file.writeAsString(content, encoding: utf8);

        generatedFiles.add(fileName);
      }

      if (generatedFiles.isNotEmpty) {
        _showMessage(AppStrings.generateSuccess
            .replaceAll('{count}', generatedFiles.length.toString()));
      } else {
        _showError(AppStrings.noFormatSelected);
      }
    } catch (e) {
      String errorMsg;
      if (e is PathAccessException) {
        errorMsg = AppStrings.writeFailedPermissionDenied;
      } else if (e is PathNotFoundException) {
        errorMsg = AppStrings.writeFailedDirNotFound;
      } else if (e is FileSystemException) {
        errorMsg = AppStrings.writeFailedDiskError;
      } else {
        errorMsg = AppStrings.writeFailedUnknown;
      }
      _showError(errorMsg);
    }
  }

  // ---------------------------------------------------------------------------
  // 消息管理
  // ---------------------------------------------------------------------------

  /// 显示普通消息，5 秒后自动消失
  void _showMessage(String message) {
    _isError = false;
    _snackbarMessage = message;
    final int version = ++_messageVersion;
    notifyListeners();

    Future.delayed(const Duration(seconds: 5), () {
      if (_messageVersion == version) {
        clearMessage();
      }
    });
  }

  /// 显示错误消息，5 秒后自动消失
  void _showError(String message) {
    _isError = true;
    _snackbarMessage = message;
    final int version = ++_messageVersion;
    notifyListeners();

    Future.delayed(const Duration(seconds: 5), () {
      if (_messageVersion == version) {
        clearMessage();
      }
    });
  }

  /// 立即清除当前消息
  void clearMessage() {
    _snackbarMessage = null;
    notifyListeners();
  }

  /// 显示"扫描进行中"提示（扫描中点击生成按钮时触发）
  void showScanTip() {
    _showError(AppStrings.scanInProgressTip);
  }
}
