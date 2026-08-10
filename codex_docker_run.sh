#docker run --name=codex --workdir /mnt/codex_work  --volume /mnt/f/codex_aiwork:/mnt --network=bridge --runtime=runc --detach=true -t swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/library/ubuntu:24.04 /bin/bash
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
