# 更新日志

## v1.0.0

发布日期：2026-05-06

### 初始版本
- FileTree 首次构建
- 递归扫描目录结构，生成树形结构
- 支持四种导出格式：HTML、Markdown、Text、XML
- 图形界面操作，无需命令行
- 实时显示文件夹和文件统计
- Ori Vale 家族化视觉风格（类 Sequoia / Tahoe）
- 支持大目录快速扫描
- 折叠/展开目录树（HTML 格式）
- 跨平台支持：macOS 通用二进制、Windows x86_64

### 技术实现
- Flutter 3.0+ 框架
- Provider 状态管理
- file_selector 文件选择器
- package_info_plus 版本信息读取
- 家族化视觉组件库（OriValeStyles + OriValeVisual）

---

## v1.0.1

发布日期：2026-05-10

### 新增
- 关于页面添加 GitHub 链接（支持浏览器跳转）
- 新增 `assets/github.svg` GitHub 图标
- 新增 MIT 开源许可证
- 新增 README.md 项目文档

### 改进
- HTML 生成页面全面升级为 Ori Vale 家族化视觉风格
  - 配色系统：#F6F6F8 背景、#007AFF 系统蓝、#34C759 成功绿
  - 卡片化布局：标题/工具栏/树形区域独立卡片
  - 文件夹图标：Unicode 三角箭头（不依赖 CSS/emoji）
  - 工具栏：折叠按钮与统计信息同行显示
- 合并 `OriValeStyles` 类到 `OriValeVisual`，统一管理所有视觉常量和组件
- Windows 窗口大小统一为 840x600，与 macOS 一致
- 窗口不可调整大小（固定尺寸）
- 版本号完全从 pubspec.yaml 自动同步（去掉 Runner.rc fallback）

### 移除
- 删除 XML 格式支持（html、markdown、text 三种格式保留）
- 删除 `orivale_styles.dart` 文件（内容合并至 `orivale_visual.dart`）

### 依赖变更
- 新增 `url_launcher`（GitHub 链接跳转）
- 新增 `flutter_svg`（GitHub 图标加载）
