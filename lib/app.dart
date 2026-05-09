import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'common/app_state.dart';
import 'common/app_strings.dart';
import 'orivale/orivale_visual.dart';
import 'orivale/orivale_about.dart';

/// 应用根 Widget
class FileTree extends StatelessWidget {
  const FileTree({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppState(),
      child: MaterialApp(
        title: AppStrings.appTitle,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const MainWindow(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

/// 主窗口界面
class MainWindow extends StatelessWidget {
  const MainWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OriValeVisual.kBg,
      body: Stack(
        children: [
          const MainContentArea(),
          Positioned(
            top: 55,
            left: 30,
            right: 30,
            child: Consumer<AppState>(
              builder: (context, state, child) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -1),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                      child: FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                    );
                  },
                  child: state.snackbarMessage == null
                      ? const SizedBox.shrink(key: ValueKey('empty'))
                      : OriValeVisual.frostedFloatingBar(
                          message: state.snackbarMessage!,
                          isError: state.isError,
                          onClear: () => state.clearMessage(),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// 主内容区域（卡片式布局）
class MainContentArea extends StatelessWidget {
  const MainContentArea({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    // Windows 标题栏空间比 macOS 小，动态调整顶部 padding
    final topPadding = Platform.isWindows ? 30.0 : 60.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(28, topPadding, 28, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OriValeVisual.frostedSectionTitle(
                AppStrings.appTitle,
                icon: Icons.folder_rounded,
              ),
              AboutHelper.aboutButton(
                label: AppStrings.aboutLabel,
                context: context,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: OriValeVisual.frostedCard(
              padding: const EdgeInsets.all(24),
              child: ClipRect(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDirectorySection(state),
                    const SizedBox(height: 20),
                    _buildFormatSection(state),
                    const SizedBox(height: 20),
                    _buildOutputSection(state),
                    const SizedBox(height: 28),
                    Center(
                      child: SizedBox(
                        width: 320,
                        child: OriValeVisual.frostedPrimaryButton(
                          label: state.isScanning
                              ? AppStrings.scanInProgressButton
                              : AppStrings.buttonGenerate,
                          onPressed: () async {
                            if (state.isScanning) {
                              state.showScanTip();
                            } else {
                              await state.startGeneration();
                            }
                          },
                          isLoading: state.isScanning,
                          isEnabled: state.canGenerate,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: OriValeVisual.frostedMiniStat(
                        folderText: state.inputDirectory == null
                            ? "${AppStrings.statUnknown} 个文件夹"
                            : AppStrings.statFolders.replaceAll(
                                '{count}', state.displayFolderCount.toString()),
                        fileText: state.inputDirectory == null
                            ? "${AppStrings.statUnknown} 个文件"
                            : AppStrings.statFiles.replaceAll(
                                '{count}', state.displayFileCount.toString()),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 输入目录选择区域
  Widget _buildDirectorySection(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OriValeVisual.frostedLabel(AppStrings.selectDirectoryTitle),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: OriValeVisual.kSurfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OriValeVisual.kDivider),
                ),
                child: Text(
                  state.inputDirectory ?? AppStrings.noDirSelected,
                  style: TextStyle(
                    color: state.inputDirectory == null
                        ? OriValeVisual.kTertiaryLabel
                        : OriValeVisual.kLabel,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 12),
            OriValeVisual.frostedSecondaryButton(
              label: AppStrings.selectDirButton,
              icon: Icons.folder_open,
              onPressed: state.isScanning ? null : state.pickDirectory,
            ),
          ],
        ),
      ],
    );
  }

  /// 输出格式选择区域
  Widget _buildFormatSection(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OriValeVisual.frostedLabel(AppStrings.outputFormatTitle),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: state.selectedFormats.keys.map((format) {
            return OriValeVisual.frostedFormatTag(
              label: format,
              isSelected: state.selectedFormats[format]!,
              onChanged: (_) => state.toggleFormat(format),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// 输出路径选择区域
  Widget _buildOutputSection(AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OriValeVisual.frostedLabel(AppStrings.selectOutputDirTitle),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: OriValeVisual.kSurfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: OriValeVisual.kDivider),
                ),
                child: Text(
                  state.outputDirectory.isEmpty
                      ? AppStrings.noDirSelected
                      : state.outputDirectory,
                  style: const TextStyle(
                      fontSize: 14, color: OriValeVisual.kLabel),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            const SizedBox(width: 12),
            OriValeVisual.frostedSecondaryButton(
              label: AppStrings.selectDirButton,
              icon: Icons.folder_open,
              onPressed: state.isScanning ? null : state.setOutputDirectory,
            ),
          ],
        ),
      ],
    );
  }
}
