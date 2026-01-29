#!/bin/bash
# =============================================================================
# OpenSplat Docker 构建脚本 (国内优化版)
# =============================================================================
#
# 使用前请确保 deps 文件夹存在并包含以下文件：
#   - libtorch.zip
#   - nlohmann_json.zip
#   - nanoflann.zip
#   - cxxopts.zip
#   - glm.zip
#
# 下载依赖（需要能访问 GitHub）：
#   ./build_docker.sh --download-deps
#
# 构建镜像：
#   ./build_docker.sh
#
# =============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

IMAGE_NAME="opensplat-dev:latest"
DOCKERFILE="Dockerfile.cn"

# 下载依赖
download_deps() {
    echo ">>> 创建 deps 目录..."
    mkdir -p deps && cd deps

    echo ">>> 下载 libtorch..."
    wget -c https://download.pytorch.org/libtorch/cu121/libtorch-cxx11-abi-shared-with-deps-2.2.1%2Bcu121.zip -O libtorch.zip

    echo ">>> 下载 nlohmann_json..."
    wget -c https://github.com/nlohmann/json/archive/refs/tags/v3.11.3.zip -O nlohmann_json.zip

    echo ">>> 下载 nanoflann..."
    wget -c https://github.com/jlblancoc/nanoflann/archive/refs/tags/v1.5.5.zip -O nanoflann.zip

    echo ">>> 下载 cxxopts..."
    wget -c https://github.com/jarro2783/cxxopts/archive/refs/tags/v3.2.0.zip -O cxxopts.zip

    echo ">>> 下载 glm..."
    wget -c https://github.com/g-truc/glm/archive/refs/tags/1.0.1.zip -O glm.zip

    echo ">>> 依赖下载完成！"
    cd ..
}

# 检查依赖
check_deps() {
    local deps_files=("libtorch.zip" "nlohmann_json.zip" "nanoflann.zip" "cxxopts.zip" "glm.zip")
    for f in "${deps_files[@]}"; do
        if [ ! -f "deps/$f" ]; then
            echo "错误: 缺少依赖文件 deps/$f"
            echo "请先运行: ./build_docker.sh --download-deps"
            exit 1
        fi
    done
}

# 构建镜像
build_image() {
    check_deps
    echo ">>> 开始构建 Docker 镜像: $IMAGE_NAME"
    docker build -f "$DOCKERFILE" -t "$IMAGE_NAME" .
    echo ">>> 构建完成！"
    echo ""
    echo "运行容器："
    echo "  docker run -it --gpus all -v ~/data:/data $IMAGE_NAME bash"
}

# 主逻辑
case "${1:-}" in
    --download-deps)
        download_deps
        ;;
    --help|-h)
        echo "用法: $0 [选项]"
        echo ""
        echo "选项:"
        echo "  --download-deps  下载所有依赖文件到 deps 目录"
        echo "  --help, -h       显示帮助信息"
        echo ""
        echo "无参数运行时将构建 Docker 镜像"
        ;;
    *)
        build_image
        ;;
esac
