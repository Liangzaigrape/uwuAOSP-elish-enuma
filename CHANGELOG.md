# 更新日志

## 20261105 — uwuAOSP 17.0.181 (elish / enuma)

首个公开版本。

### 系统
- 基于 uwuAOSP `uwu-17.0`（Android 17）构建
- Build ID：`CP2A.260605.016 release-keys`
- 安全补丁：2026-10
- SELinux：Enforcing

### 特性
- 内置完整 GMS（GmsCore / Play 商店 / SetupWizard / WebView）
- 保留第三方触控笔支持（`org.lineageos.pad_parts`）
- 使用自建密钥签名（`release-keys`，非 AOSP testkey）
- 相机为 LineageOS Aperture

### 变更
- 修复「设置 → 关于本机」Build 号显示 `test-keys` 的问题
  （`gen_build_prop.py` 的 `BuildKeys` 改为固定的 `release-keys`）
- 移除 MIUI 相机：其 native 依赖与 SELinux 策略在 AOSP 上冲突，且相机 ID 映射依赖
  MIUI 的 `persist.vendor.camera.mi.module.info`（本机为 `back_main=none`），无法稳定工作

### 刷机
- 提供分区独立镜像（`super` / `boot` / `vendor_boot` / `dtbo` / `vbmeta`）
- 提供 Windows 脚本 `flash.bat`：机型校验（`elish` / `enuma`）、可选清数据、可选 APatch root
