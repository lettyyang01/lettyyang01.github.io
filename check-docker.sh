#!/bin/bash

echo "🔍 检查 Docker 状态..."
echo ""

# 检查 Docker 是否运行
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker Desktop 没有运行！"
    echo ""
    echo "请执行以下步骤："
    echo "1. 打开 Docker Desktop 应用程序"
    echo "2. 等待 Docker 完全启动（状态栏图标不再闪烁）"
    echo "3. 然后重新运行: docker compose up"
    exit 1
fi

echo "✅ Docker 正在运行"
echo ""

# 检查端口是否被占用
if lsof -Pi :8080 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo "⚠️  端口 8080 已被占用"
    echo ""
    echo "正在检查是什么占用了端口..."
    lsof -Pi :8080 -sTCP:LISTEN
    echo ""
    echo "你可以："
    echo "1. 停止占用端口的程序"
    echo "2. 或者修改 docker-compose.yml 使用其他端口（如 4000）"
else
    echo "✅ 端口 8080 可用"
fi

echo ""
echo "检查容器状态..."
docker compose ps

echo ""
echo "如果容器没有运行，请执行："
echo "  docker compose up"
echo ""
echo "如果容器正在运行但无法访问，请检查："
echo "1. Docker Desktop 是否完全启动"
echo "2. 防火墙是否阻止了连接"
echo "3. 尝试访问: http://127.0.0.1:8080"
