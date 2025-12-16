# 阶段1: 构建前端静态文件
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 安装 pnpm (使用固定版本确保构建一致性)
RUN npm install -g pnpm@7.30.0

# 先复制依赖清单,利用 Docker 层缓存
COPY package.json pnpm-lock.yaml ./

# 安装依赖
# 使用 --no-frozen-lockfile 因为 lock 文件可能与 package.json 不完全同步
RUN pnpm install --no-frozen-lockfile

# 复制源代码和配置文件
COPY . .

# 构建参数:允许在构建时动态设置 API 地址
ARG VITE_API_URL=https://sub.store
ENV VITE_API_URL=${VITE_API_URL}

# 执行构建
RUN pnpm build

# 阶段2: 使用 nginx 提供静态文件服务
FROM nginx:alpine

# 复制自定义 nginx 配置
COPY nginx.conf /etc/nginx/nginx.conf

# 从构建阶段复制构建产物
COPY --from=builder /app/dist /usr/share/nginx/html

# 暴露端口
EXPOSE 8888

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:8888/ || exit 1

# 启动 nginx
CMD ["nginx", "-g", "daemon off;"]
