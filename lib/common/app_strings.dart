// UI 文案常量
class AppStrings {
  // 通用
  static const String appTitle = "FileTree";
  static const String aboutLabel = "关于";

  // 关于页面
  static const String aboutDescription = "一款轻量化文件树生成工具。\n\n"
      "支持平台:\n"
      "  • Windows x86_64\n"
      "  • macOS 通用二进制 (Apple Silicon | Intel)";
  static const String versionLabel = "版本:";
  static const String projectHomeLabel = "项目主页";
  static const String closeButton = "关 闭";

  // 路径&输出格式选择区
  static const String selectDirectoryTitle = "需要生成文件树的路径：";
  static const String selectDirButton = "选择";
  static const String noDirSelected = "未选择路径";
  static const String selectOutputDirTitle = "文件树导出路径：";
  static const String outputFormatTitle = "选择输出格式";

  // 操作按钮
  static const String buttonGenerate = "导出树形结构";
  static const String scanInProgressButton = "文件扫描中，请稍候...";
  static const String scanInProgressTip = "请耐心等待扫描完成";

  // 错误提示（输入相关）
  static const String noInputDirSelected = "请先选择需要生成文件树的路径";
  static const String noOutputDirSelected = "请先选择文件树导出路径";
  static const String noFormatSelected = "请至少选择一种格式";

  // 扫描结果（包含 {folderCount} 和 {fileCount} 占位符）
  static const String scanComplete =
      "扫描完成！共发现 {folderCount} 个文件夹，{fileCount} 个文件";

  // 扫描错误
  static const String scanFailedUnknown = "扫描失败: 未知原因，请联系开发者进行反馈";
  static const String scanFailedPermissionDenied = "扫描失败: 权限不足，请在系统设置中授予访问权限";
  static const String scanFailedDirNotFound = "扫描失败: 输入路径不存在或已被移动，请重新选择";
  static const String scanFailedDiskError = "扫描失败: 磁盘空间不足或文件系统异常";

  // 生成结果（包含 {count} 占位符）
  static const String generateSuccess = "生成成功！已输出 {count} 个文件到输出路径";
  static const String writeFailedUnknown = "生成失败: 未知原因，请联系开发者进行反馈";
  static const String writeFailedPermissionDenied = "生成失败: 权限不足，请在系统设置中授予访问权限";
  static const String writeFailedDirNotFound = "生成失败: 输出路径不存在或已被移动，请重新选择";
  static const String writeFailedDiskError = "生成失败: 磁盘空间不足或文件系统异常";

  // 权限请求
  static const String permRequestTitle = "授权提示";
  static const String permRequestMessage = "请在系统弹窗中允许访问，以便进行文件解析。";

  // 统计区（包含 {count} 占位符）
  static const String statFolders = "{count} 个文件夹";
  static const String statFiles = "{count} 个文件";
  static const String statUnknownFolders = "-- 个文件夹";
  static const String statUnknownFiles = "-- 个文件";

  // 生成器输出
  static const String sourcePath = "根目录";
  static const String dateTime = "生成时间";
  static const String statisticsInfo = "统计信息";
  static const String collapseAll = "折叠全部";
  static const String expandAll = "展开全部";
  static const String rootFolderCount = "个文件夹";
  static const String rootFileCount = "个文件";
}
