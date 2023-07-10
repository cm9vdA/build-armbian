# build-armbian

编译步骤：
1. 你需要一个已经安装Docker的Linux系统
2. 克隆Armbian官方仓库到本地，地址：https://github.com/armbian/build
3. 复制本仓库下所有文件到你本地的Armbian代码目录
4. 执行`build-main.sh`或者`build-master.sh`选择型号开始编译，第一次编译通常耗时较长，需要耐心等待。

脚本说明：
- `build-master.sh`：从`master`分支编译，可以使用`root用户`，不需要其他配置

- `build-main.sh`：从`main`分支编译，必须使用`非root用户`，并且提前将普通用户加入`docker`用户组。
 ```
 创建 docker 用户组
 sudo groupadd docker
 添加你想用普通用户权限的用户名到 docker 用户组
 sudo usermod -aG docker $USER
 系统重启后就可以使用普通用户权限执行 docker, 如果不想重启，可以使用下面的命令更新并激活组权限
 newgrp docker
 验证设置是否成功
 docker run hello-world
 ```

注：编译参数和机型配置文件是我根据个人喜好设定的，你们编译的时候可以根据Armbian官方文档修改编译参数。
