## Openpilot 一键安装脚本

<h3 style="color:read;">本项目已终止维护，请点击了解<br> <a href="https://doc.sdut.me/cn/how_to_change_openpilot_fork_on_windows.html">使用 Putty SSH 切换 openpilot 分支版本</a>。</h3>

### 使用教程

1. 手机正常开机并联网
2. 电脑通过局域网连接到手机 SSH

**单次使用**，不用下载存储脚本：
```bash
# 下载并运行脚本
bash <(curl -s -L https://gitee.com/afaaa/openpilot_install/raw/master/op_install.sh)
```


**重复使用**，下载脚本放到 /sdcard 目录：
```bash
# 下载脚本到 /sdcard/op_install.sh
curl -o /sdcard/op_install.sh -L https://gitee.com/afaaa/openpilot_install/raw/master/op_install.sh

# 运行脚本
bash /sdcard/op_install.sh
```

### 演示图片

![op_install](https://doc.sdut.me/files/op_install.png)

### 演示视频

<a href="https://www.bilibili.com/video/av69034797/" rel="noopener"><img src="https://camo.githubusercontent.com/0a8aca6b272cdab68cc30733271100d5ec96b2a5/68747470733a2f2f69302e6864736c622e636f6d2f6266732f617263686976652f616638396130656137656332333936646535323436633836663538633330373334613436653063372e6a70675f31323830783830302e6a7067"></a>
