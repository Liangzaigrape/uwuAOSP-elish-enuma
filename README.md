# uwuAOSP for Xiaomi Pad 5 Pro (elish / enuma)

非官方 **uwuAOSP 17.0.181**（Android 17）构建，适用于小米平板 5 Pro（`elish` / `enuma`）。

基于 [web1n 的 LineageOS 24 for elish](https://xdaforums.com/t/rom-unofficial-a17-elish-lineageos-24-for-xiaomi-pad-5-pro-wifi.4804913/) 设备树，
配合 [uwuAOSP](https://github.com/UwUAOSP) 的 manifest 编译，内置 GMS、保留第三方触控笔支持。

---

## 版本信息

| 项目 | 值 |
|---|---|
| Android | 17 |
| ROM | uwuAOSP 17.0.181 |
| 构建日期 | 2026-11-05 |
| Build ID | `CP2A.260605.016 release-keys` |
| 安全补丁 | 2026-10 |
| 设备 | elish / enuma（小米平板 5 Pro） |
| SELinux | Enforcing |

## 特性

- ✅ 完整 GMS（GmsCore、Play 商店、SetupWizard、WebView）
- ✅ 第三方触控笔支持（`org.lineageos.pad_parts`，设置 → 小米平板设置）
- ✅ `release-keys` 签名（自建密钥，非 AOSP 公开 testkey）
- ✅ 可选 APatch root（刷入 `boot_root_apatch.img`）
- ✅ 相机使用 LineageOS Aperture
- ❌ 不含 MIUI 相机（见下方「已知问题」）

## 下载

前往 [Releases](../../releases) 下载：

- `uwu_elish-17.0.181-elish-20261105.zip` — 完整 OTA 包
- 分区镜像（`super.img`、`boot.img`、`boot_root_apatch.img`、`vendor_boot.img`、`dtbo.img`、`vbmeta*.img`）
- `flash.bat` + `README.txt` — Windows 一键刷机脚本
- `checksums.sha256` — 全部文件的 SHA256

## 刷机

详见 [docs/INSTALL.md](docs/INSTALL.md)。简要步骤：

1. 解锁 Bootloader，关机后按住 **音量下 + 电源** 进入 fastboot
2. 把分区镜像和 `flash.bat` 放在同一文件夹，双击运行
3. 脚本会校验机型（仅 `elish` / `enuma`），询问是否清数据、是否需要 root

> 从 MIUI / HyperOS 刷入**必须清除数据**；从其他类原生系统可先不清，异常再清。

## 已知问题

- **不含 MIUI 相机**：MIUI 相机依赖 `/vendor/lib64` 下的私有 native 库（`libmialgoengine.so` 等）
  与 MIUI 的相机 ID 映射（`persist.vendor.camera.mi.module.info` 在本机为 `back_main=none`），
  在 AOSP 上无法稳定工作，因此本版移除，改用 Aperture。
- 首次开机会先优化应用，5–10 分钟属正常。

## 构建说明

见 [docs/BUILD.md](docs/BUILD.md)。

## 致谢

- **[web1n](https://xdaforums.com/t/rom-unofficial-a17-elish-lineageos-24-for-xiaomi-pad-5-pro-wifi.4804913/)** —
  提供了 elish 的 LineageOS 24 设备树与内核，本构建的源码基础
- **[uwuAOSP](https://github.com/UwUAOSP)**（[官网](https://uwuaosp.uwuniverse.org)）—
  优秀的 AOSP 衍生项目，提供了本构建使用的 manifest 与产品化方案
- **DeepSeek-V4.1-Flash** — 本构建的调试、编译、刷机脚本与文档由它完成
- **LineageOS / AOSP / Xiaomi** — 上游代码与驱动

## 免责声明

本项目为非官方个人构建，与小米、LineageOS、uwuAOSP 官方均无关联。
刷机有风险，可能导致数据丢失或设备损坏，**风险自负**。刷机即视为同意自行承担后果。
