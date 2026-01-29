# 💦 OpenSplat 增强版

本仓库为 OpenSplat 的增强版本，针对国内开发环境进行了优化，并增加了特定的参数支持。

## 1. 如何在国内构建镜像

为了方便国内用户，我们提供了一键式构建脚本 `build_docker.sh`。

### 步骤一：准备依赖
脚本支持自动下载构建所需的 libtorch 及其他 C++ 依赖库：

```bash
# 下载所有依赖文件到 deps 目录
./build_docker.sh --download-deps
```

### 步骤二：一键构建
依赖准备完成后，直接运行脚本即可完成镜像构建（默认标签为 `opensplat-dev:latest`）：

```bash
# 执行一键构建
./build_docker.sh
```
> 注：该构建基于 `Dockerfile.cn`，已针对 RTX 4060 Ti (Ada Lovelace 架构) 进行优化，并使用了阿里云镜像源。

---

## 2. 容器使用说明

### 默认工作目录
镜像启动后的默认工作目录为 `/data`。建议将宿主机的项目数据挂载到此目录下。

### 系统级命令支持
在新的镜像中，`opensplat` 已配置为系统级命令。您可以在任何路径下直接输入 `opensplat` 运行，无需再前往 `/code/build/` 目录寻找可执行文件。

### 启动示例
```bash
# 启动容器并挂载数据
docker run -it --gpus all -v ~/data:/data opensplat-dev:latest bash
```

---

## 3. 新增参数说明：`--opensfm-image-path`

### 作用
该参数用于在使用 OpenSfM 项目作为输入时，**覆盖默认的图像搜索路径**。

### 适用场景
在 OpenSfM 项目中，`reconstruction.json` 记录的路径可能不符合当前的目录结构。您可以使用此参数指定图像的实际存放位置，程序会自动保持文件名不变，仅替换路径部分。

### 运行示例
```bash
# 在容器内直接执行（已支持系统命令）
opensplat /data/your_project --opensfm-image-path /data/actual_images -n 2000
```

---

## 4. 结果查看
训练完成后，模型文件 `splat.ply` 和相机参数 `cameras.json` 将保存在您的项目目录下。您可以使用 PlayCanvas Viewer 等查看器进行预览。
