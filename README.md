## openpilot 安装工具

openpilot 安装工具（开发测试中）

### 使用教程

如果手机可以开机，并且可以通过 SSH 连接到手机操作，如果手机无法正常开机，则重启手机进入TWRP模式下操作。

#### 开机SSH状态下的操作步骤

1. 手机正常开机并联网
2. 电脑通过局域网连接到手机 SSH

```bash
# 运行安装脚本
bash <(curl -s -L https://git.io/op_install.sh) 
```


#### 在TWRP模式下的操作步骤

1. 手机连接到电脑，开启 adb 调试、解锁 bootloader，重启进入 TWRP 模式
2. 在电脑端命令行运行：
  
```bash
# 进入手机 shell
adb shell
```

3. 在手机 shell 中运行


```bash

# 初始化bash环境
source <(curl -s -L http://git.io/op_bash_init.sh)

# 运行安装脚本
bash <(curl -s -L https://git.io/op_install.sh) 
```

