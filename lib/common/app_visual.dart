import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 统一视觉系统
///
/// 集中管理颜色、常量和所有视觉组件，保持跨应用的一致性
class AppVisual {
  // ---------------------------------------------------------------------------
  // 颜色系统（macOS 风格）
  // ---------------------------------------------------------------------------

  static const Color kBg = Color(0xFFF6F6F8);
  static const Color kSurface = Color(0xFFFFFFFF);
  static const Color kSurfaceAlt = Color(0xFFF6F6F8);
  static const Color kDivider = Color(0xFFE5E5EA);
  static const Color kAccent = Color(0xFF007AFF);
  static const Color kGreen = Color(0xFF34C759);
  static const Color kOrange = Color(0xFFFF9F0A);
  static const Color kRed = Color(0xFFFF3B30);
  static const Color kLabel = Color(0xFF000000);
  static const Color kSecondaryLabel = Color(0xFF6E6E73);
  static const Color kTertiaryLabel = Color(0xFF8E8E93);

  // ---------------------------------------------------------------------------
  // 空间尺度
  // ---------------------------------------------------------------------------

  static const double kControlRadius = 12.0;
  static const double kCardRadius = 16.0;

  // ---------------------------------------------------------------------------
  // 动画参数
  // ---------------------------------------------------------------------------

  static const Duration kTouchDuration = Duration(milliseconds: 200);
  static const double kTouchScale = 0.9;

  // ---------------------------------------------------------------------------
  // 阴影
  // ---------------------------------------------------------------------------

  static const BoxShadow kElevatedShadow = BoxShadow(
    color: Color.fromARGB(15, 0, 0, 0),
    blurRadius: 10,
    offset: Offset(0, 10),
  );

  static const BoxShadow kFocusShadow = BoxShadow(
    color: Color(0x15007AFF),
    blurRadius: 4,
    spreadRadius: 2,
  );

  // ---------------------------------------------------------------------------
  // 间距
  // ---------------------------------------------------------------------------

  static const double kIconSpacing = 8.0;
  static const double kElementSpacing = 12.0;

  // -----------------------------------------------------------------------
  // 视觉组件
  // -----------------------------------------------------------------------

  /// 磨砂玻璃风格的区块标题
  static Widget frostedSectionTitle(String title, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 28, color: kAccent),
            const SizedBox(width: 10),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: kLabel,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  /// 磨砂玻璃卡片容器
  static Widget frostedCard({required Widget child, EdgeInsets? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(kCardRadius),
        boxShadow: const [kElevatedShadow],
      ),
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );
  }

  /// 主强调按钮（蓝色）
  static Widget frostedPrimaryButton({
    required String label,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
  }) {
    return ScaleOnTap(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isEnabled ? kAccent : kTertiaryLabel,
          borderRadius: BorderRadius.circular(kControlRadius),
          boxShadow: isEnabled ? const [kElevatedShadow] : [],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isLoading) ...[
                const SizedBox(
                  height: 18,
                  width: 18,
                  child: CupertinoActivityIndicator(color: Colors.white),
                ),
                const SizedBox(width: 10),
              ],
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 次要按钮（带图标）
  static Widget frostedSecondaryButton({
    required String label,
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return ScaleOnTap(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: kDivider.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(kControlRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: kSecondaryLabel),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: kLabel,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 格式选择标签（可切换选中状态）
  static Widget frostedFormatTag({
    required String label,
    required bool isSelected,
    required Function(dynamic) onChanged,
  }) {
    return ScaleOnTap(
      onTap: () => onChanged(null),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? kAccent : kSurfaceAlt,
          borderRadius: BorderRadius.circular(kControlRadius),
          border: isSelected ? null : Border.all(color: kDivider, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : kDivider,
                border: isSelected
                    ? null
                    : Border.all(color: kSecondaryLabel, width: 1.5),
              ),
              child: Center(
                child: isSelected
                    ? const Icon(Icons.check, size: 12, color: kAccent)
                    : const Icon(Icons.close, size: 12, color: kSecondaryLabel),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : kLabel,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 底部小统计组件（文件夹和文件数）
  static Widget frostedMiniStat({
    required String folderText,
    required String fileText,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.folder_open_rounded, size: 14, color: kTertiaryLabel),
        const SizedBox(width: 4),
        Text(folderText,
            style: const TextStyle(fontSize: 12, color: kSecondaryLabel)),
        const SizedBox(width: 12),
        const Icon(Icons.insert_drive_file_outlined,
            size: 14, color: kTertiaryLabel),
        const SizedBox(width: 4),
        Text(fileText,
            style: const TextStyle(fontSize: 12, color: kSecondaryLabel)),
      ],
    );
  }

  /// 浮动提示条（成功/错误 SnackBar）
  static Widget frostedFloatingBar({
    required String message,
    bool isError = false,
    VoidCallback? onClear,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isError
            ? kRed.withValues(alpha: 0.9)
            : kAccent.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(kControlRadius),
        boxShadow: const [kElevatedShadow],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (onClear != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, color: Colors.white, size: 14),
            ),
          ],
        ],
      ),
    );
  }

  /// 次要标签文字样式
  static Widget frostedLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: kSecondaryLabel,
      ),
    );
  }
}

/// 按压时缩放的可点击组件
///
/// 支持按压时的缩放动画，提供触觉反馈
class ScaleOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ScaleOnTap({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? AppVisual.kTouchScale : 1.0,
        duration: AppVisual.kTouchDuration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
