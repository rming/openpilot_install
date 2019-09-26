## Openpilot 一键安装脚本


### 使用教程

1. 手机正常开机并联网
2. 电脑通过局域网连接到手机 SSH

**单次使用**，不用下载存储脚本：
```bash
# 下载并运行脚本
bash <(curl -s -L https://git.io/op_install.sh) 
```


**重复使用**，下载脚本放到 /sdcard 目录：
```bash
# 下载脚本到 /sdcard/op_install.sh
curl -o /sdcard/op_install.sh -L https://git.io/op_install.sh

# 运行脚本
bash /sdcard/op_install.sh
```

### 演示视频

<iframe src="//player.bilibili.com/player.html?aid=69034797&cid=119645754&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
