# 刷机说明

## 前提

- 已解锁 Bootloader
- Windows 电脑，装好小米 USB 驱动（或用 Google USB Driver / 通用 ADB 驱动）
- 设备电量 > 30%

## 文件

从 [Releases](../../releases) 下载以下文件，**全部放在同一个文件夹**：

```
super.img                 动态分区（system / system_ext / product / vendor / odm）
boot.img                  正常内核
boot_root_apatch.img      内置 APatch root 的内核
vendor_boot.img           vendor_boot
dtbo.img                  dtbo
vbmeta.img                vbmeta
vbmeta_system.img         vbmeta_system
flash.bat                 刷机脚本
```

## 一键刷机

1. 平板关机
2. 按住 **音量下 + 电源** 进入 fastboot 模式
3. 双击 `flash.bat`
4. 按提示输入：

   - **是否清除数据**
     - 从 MIUI / HyperOS 刷入：输入 `y`
     - 从其他类原生系统刷入：可先输 `n`，开机异常再重刷并选 `y`
   - **是否需要 root（APatch）**
     - 需要：`y`，刷入 `boot_root_apatch.img`
     - 不需要：`n`，刷入 `boot.img`

5. 等待完成，自动重启。首次开机 5–10 分钟。

脚本会先校验机型：只有 `elish` 或 `enuma` 才会继续，其他机型直接退出。

## 手动刷机

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

## APatch root

刷入 `boot_root_apatch.img` 后：

1. 安装 Releases 里的 `APatch_*.apk`
2. 打开 APatch，按提示设置超级密钥
3. 授权需要 root 的应用

## 常见问题

| 现象 | 处理 |
|---|---|
| 脚本提示未检测到设备 | 换 USB 口/线；设备管理器里更新 Android Bootloader Interface |
| `fastboot flash super` 很慢 | 正常，5GB 左右，切勿拔线 |
| 刷完进 recovery / fastboot | 多半没清数据，重刷并选 `y` |
| 开机卡 logo | 确认机型是 elish / enuma；确认已清数据 |
| 想退回 MIUI | 用小米官方线刷包重新刷入 |
