import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'app_strings.dart';
import 'app_visual.dart';

/// 关于面板助手
///
/// 提供「关于」按钮和弹窗，显示应用信息和项目主页入口
class AboutHelper {
  static const String _projectUrl = 'https://github.com/Ori-Vale/FileTree';

  // ---------------------------------------------------------------------------
  // 关于按钮
  // ---------------------------------------------------------------------------

  /// 创建「关于」按钮 Widget
  ///
  /// 点击后弹出关于对话框
  static Widget aboutButton({String? label, required BuildContext context}) {
    return ScaleOnTap(
      onTap: () => _showAboutDialog(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppVisual.kSurfaceAlt,
          borderRadius: BorderRadius.circular(AppVisual.kControlRadius),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (label != null) ...[
              Text(
                label,
                style: const TextStyle(
                    fontSize: 13, color: AppVisual.kSecondaryLabel),
              ),
              const SizedBox(width: 6),
            ],
            const Icon(Icons.info_outline,
                size: 18, color: AppVisual.kSecondaryLabel),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 弹窗构建
  // ---------------------------------------------------------------------------

  /// 弹出关于对话框
  static void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => _buildAboutDialog(context),
    );
  }

  /// 构建关于弹窗内容
  ///
  /// 包含应用名称、版本号（动态读取）、描述和 GitHub 链接
  static Widget _buildAboutDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: AppVisual.frostedCard(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.folder_rounded,
                    size: 36, color: AppVisual.kAccent),
                const SizedBox(width: 12),
                Text(
                  AppStrings.appTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppVisual.kLabel,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                final version =
                    snapshot.hasData ? snapshot.data!.version : '...';
                return Text(
                  '${AppStrings.versionLabel} $version',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppVisual.kSecondaryLabel,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Container(height: 1, color: AppVisual.kDivider),
            const SizedBox(height: 24),
            Text(
              AppStrings.aboutDescription,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppVisual.kLabel,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => launchUrl(Uri.parse(_projectUrl)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/github.svg',
                    width: 16,
                    height: 16,
                    colorFilter: const ColorFilter.mode(
                      AppVisual.kSecondaryLabel,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppStrings.projectHomeLabel,
                    style:
                        const TextStyle(fontSize: 13, color: AppVisual.kAccent),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 110,
              child: AppVisual.frostedPrimaryButton(
                label: AppStrings.closeButton,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
