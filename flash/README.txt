# uwuAOSP 17.0.181 (elish) 刷机说明

版本：20261105-RELEASE
Build 号：CP2A.260605.016 release-keys
支持机型：elish（小米平板 5 Pro）、enuma

## 文件说明

| 文件 | 分区 | 大小 |
|---|---|---|
| super.img | super（动态分区：system / system_ext / product / vendor / odm） | 4.9 GB |
| boot.img | boot（正常内核） | 192 MB |
| boot_root_apatch.img | boot（已内置 APatch root） | 192 MB |
| vendor_boot.img | vendor_boot | 96 MB |
| dtbo.img | dtbo | 32 MB |
| vbmeta.img | vbmeta | 8 KB |
| vbmeta_system.img | vbmeta_system | 4 KB |
| flash.bat | 刷机脚本 | — |

所有分区都是独立镜像，脚本和镜像放在同一文件夹即可。

## 使用方法

1. 解锁 Bootloader
2. 关机后按住 **音量下 + 电源** 进入 fastboot 模式
3. 双击 `flash.bat`
4. 按提示输入：
   - 是否清除数据：`y` 或 `n`
   - 是否需要 root：`y` 刷 `boot_root_apatch.img`，`n` 刷 `boot.img`

## 清除数据说明

- 从 **MIUI / HyperOS** 刷入：**必须选 y**，否则大概率无法开机
- 从其他类原生系统刷入：可以先选 n，开机异常再重新刷并选 y
- 清除数据会删除内部存储全部内容，请先备份

## 手动刷入（等价命令）

```bat
fastboot --set-active=a
fastboot flash boot boot.img
fastboot flash vendor_boot vendor_boot.img
fastboot flash dtbo dtbo.img
fastboot flash vbmeta vbmeta.img
fastboot flash vbmeta_system vbmeta_system.img
fastboot flash super super.img
fastboot -w
fastboot reboot
```

需要 root 时把 `boot.img` 换成 `boot_root_apatch.img`。

## 常见问题

- **脚本提示未检测到设备**：检查驱动、换 USB 口/线，或在设备管理器里更新 Android Bootloader Interface
- **刷 super 很慢**：正常，5GB 左右，期间不要拔线
- **首次开机很久**：5–10 分钟正常，会先优化应用
- **刷完仍进 recovery/fastboot**：多半是没清数据，重新运行脚本并选 y
