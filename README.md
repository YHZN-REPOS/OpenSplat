# 💦 OpenSplat 增强版

本仓库为 OpenSplat 的增强版本，针对国内开发环境进行了优化，并增加了特定的参数支持。

## 1. 如何在国内构建镜像

为了解决国内网络访问瓶颈，建议使用 `Dockerfile.cn` 进行构建。该构建通过阿里云镜像源并支持本地依赖缓存。

### 准备工作
在项目根目录创建 `deps` 文件夹，并下载以下依赖文件放入其中：

```bash
mkdir -p deps && cd deps
# libtorch (CUDA 12.1 版本)
wget https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.2.1%2Bcu121.zip -O libtorch.zip
# 其他 C++ 依赖
wget https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.zip -O nlohmann_json.zip
wget https://github.com/jlblancoc/nanoflann/archive/refs/tags/v1.5.5.zip -O nanoflann.zip
wget https://github.com/jarro2783/cxxopts/archive/refs/tags/v3.2.0.zip -O cxxopts.zip
wget https://github.com/g-truc/glm/archive/refs/tags/1.0.1.zip -O glm.zip
```

### 构建命令
针对 RTX 4060 Ti (Ada Lovelace 架构) 的优化构建命令：

```bash
docker build -f Dockerfile.cn -t opensplat:rtx4060ti .
```

---

## 2. 新增参数说明：`--opensfm-image-path`

### 作用
该参数用于在使用 OpenSfM 项目作为输入时，**覆盖默认的图像搜索路径**。

### 适用场景
在 OpenSfM 项目中，`reconstruction.json` 或 `image_list.txt` 中记录的图像路径可能是绝对路径或相对于原始项目的路径。如果您在重建完成后移动了图像文件夹，或者在 Docker 容器中挂载的路径与原始记录不符，可以使用此参数指定图像的实际存放位置。

程序会自动保持原始文件名，仅将目录部分替换为您指定的路径。

---

## 3. 镜像使用说明

### 启动容器
使用以下命令启动并挂载数据目录（假设您的数据在宿主机的 `~/data`）：

```bash
docker run -it --gpus all -v ~/data:/data opensplat:rtx4060ti bash
```

### 执行训练
进入容器后，可以使用以下方式运行程序：

#### 基本使用
```bash
opensplat /data/your_project_folder -n 2000
```

#### 使用 OpenSfM 路径覆盖
如果您的图像放在 `/data/my_images`，而项目文件在 `/data/project`：

```bash
opensplat /data/project --opensfm-image-path /data/my_images -n 2000
```

### 生成结果
程序运行完成后，会在项目目录下生成 `splat.ply`（模型文件）和 `cameras.json`（相机参数），您可以将其拖入网页版查看器（如 PlayCanvas Viewer）进行预览。
