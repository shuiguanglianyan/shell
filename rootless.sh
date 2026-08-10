#docker volume create codex-buildkit-sock

docker run -d \
  --name codex-buildkit \
  --restart unless-stopped \
  --security-opt seccomp=unconfined \
  --security-opt apparmor=unconfined \
  --security-opt systempaths=unconfined  \
  -v codex-buildkit-sock:/run/user/1000/buildkit \
  swr.cn-north-4.myhuaweicloud.com/ddn-k8s/docker.io/moby/buildkit:rootless 

