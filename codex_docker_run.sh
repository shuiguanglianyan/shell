#前提首先启动codex-buildkit
#首先制作codex基础镜像，里面包含安装codex和认证登录，都在容器中操作，我这里没有坐dockerfile
#然后docker commit一个基础镜像
#制作基础image的启动方式
#docker run --name=codex --workdir /mnt/codex_work  --volume /mnt/f/codex_aiwork:/mnt --network=bridge --runtime=runc --detach=true -t swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/ubuntu:24.04 /bin/bash
#启动
docker run --name=codex \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    --security-opt systempaths=unconfined \
    --workdir /mnt/codex_work \
    --volume /mnt/f/codex_aiwork:/mnt \
    --volume codex-buildkit-sock:/run/buildkit \
    --network=bridge \
    --runtime=runc \
    --detach=true \
    -t  codex:202060807-v1.000 /bin/bash
