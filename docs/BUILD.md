# 构建说明

## 源码组成

| 部分 | 来源 |
|---|---|
| 设备树 / 内核 / vendor blobs | [web1n 的 LineageOS 24 for elish](https://xdaforums.com/t/rom-unofficial-a17-elish-lineageos-24-for-xiaomi-pad-5-pro-wifi.4804913/) |
| ROM 框架与产品化 | [uwuAOSP](https://github.com/UwUAOSP)（[官网](https://uwuaosp.uwuniverse.org)） |
| AOSP / LineageOS | 上游 |

## 环境

- Ubuntu 24.04（WSL2 亦可，建议内存 ≥ 20GB、swap ≥ 24GB、磁盘 ≥ 300GB）
- `repo`、OpenJDK 21、约 4 小时（首次全量）

## 同步

```bash
mkdir -p ~/uwu && cd ~/uwu
repo init -u https://github.com/UwUAOSP/platform_manifests -b uwu-17.0
repo sync -j8 --force-sync
```

设备树放进 `device/xiaomi/elish`（来自 web1n 的仓库），
本项目对其做的改动：

1. `AndroidProducts.mk` / `device.mk` 产品名改为 `uwu_elish`，继承 uwuAOSP 的产品配置
2. `lineage_elish.mk` → `uwu_elish.mk`，增加 `UWU_DEVICE_TYPE := tablet`
3. 生成自建签名密钥替换 `build/make/target/product/security/` 下的 AOSP 公开密钥
4. `build/soong/scripts/gen_build_prop.py`：
   `ro.build.display.id` / `ro.build.tags` 固定输出 `release-keys`
   （否则 userdebug 变体下恒为 `test-keys`）

## 编译

```bash
source build/envsetup.sh
lunch uwu_elish-cp2a-userdebug
m -j4 otapackage
```

> 内存吃紧时用 `-j4`，并 `ulimit -s 65536` 避免 clang/lld 模板递归导致的栈溢出。

## 生成刷机镜像

```bash
out/host/linux-x86/bin/build_super_image \
  out/target/product/elish/obj/PACKAGING/target_files_intermediates/uwu_elish-target_files \
  super.img
```

`super.img` 必须用 `build_super_image` 生成，手写 `lpmake` 会缺少
`qti_dynamic_partitions_b` 分组，导致 `update_engine` 报 `kNotEnoughSpace`。

其余镜像在 target_files 的 `IMAGES/` 下：`boot.img`、`vendor_boot.img`、
`dtbo.img`、`vbmeta.img`、`vbmeta_system.img`。

## 已知坑

- soong 分析阶段很吃内存，swap 抖动时可能 30 分钟以上
- 磁盘不足会让 soong 直接 `SIGBUS`，注意留足空间
- `adb sideload` 在本机常卡在 46%，用 `fastboot flash super` 更可靠
