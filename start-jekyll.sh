#!/bin/bash

echo "🛑 停止现有的 Jekyll 进程..."
docker compose exec jekyll pkill -f jekyll 2>/dev/null || true
docker compose exec jekyll pkill -f entry_point 2>/dev/null || true

echo "📦 安装依赖..."
docker compose exec jekyll bash -c "cd /srv/jekyll && bundle install" > /dev/null 2>&1

echo "🚀 启动 Jekyll 服务器..."
docker compose exec -d jekyll bash -c "cd /srv/jekyll && bundle exec jekyll serve --host=0.0.0.0 --port=8080 --livereload --force_polling"

echo "⏳ 等待服务器启动..."
sleep 8

echo "✅ 检查服务器状态..."
if docker compose logs --tail=30 jekyll | grep -q "Server address\|Server running"; then
    echo ""
    echo "🎉 Jekyll 服务器已成功启动！"
    echo "📱 请在浏览器访问: http://localhost:8080"
    echo ""
    echo "查看实时日志: docker compose logs -f jekyll"
else
    echo ""
    echo "⚠️  服务器可能还在启动中，请稍等..."
    echo "查看日志: docker compose logs -f jekyll"
    echo "或访问: http://localhost:8080"
fi
