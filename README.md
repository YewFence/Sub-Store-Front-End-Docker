<div align="center">
<br>
<img width="200" src="https://raw.githubusercontent.com/cc63/ICON/main/Sub-Store.png" alt="Sub-Store">
<br>
<br>
<h2 align="center">Sub-Store</h2>
</div>

<p align="center" color="#6a737d">
Advanced Subscription Manager for QX, Loon, Surge, Stash and ShadowRocket.
</p>

[![Build](https://github.com/Peng-YM/Sub-Store/actions/workflows/main.yml/badge.svg)](https://github.com/Peng-YM/Sub-Store/actions/workflows/main.yml) ![GitHub](https://img.shields.io/github/license/Peng-YM/Sub-Store) ![GitHub issues](https://img.shields.io/github/issues/Peng-YM/Sub-Store) ![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed-raw/Peng-Ym/Sub-Store) ![Lines of code](https://img.shields.io/tokei/lines/github/Peng-YM/Sub-Store) ![Size](https://img.shields.io/github/languages/code-size/Peng-YM/Sub-Store)

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/PengYM)

Core functionalities:

1. Conversion among various formats.
2. Subscription formatting.
3. Collect multiple subscriptions in one URL.

## 1. Subscription Conversion

### Supported Input Formats

- [x] SS URI
- [x] SSR URI
- [x] SSD URI
- [x] V2RayN URI
- [x] QX (SS, SSR, VMess, Trojan, HTTP)
- [x] Loon (SS, SSR, VMess, Trojan, HTTP)
- [x] Surge (SS, VMess, Trojan, HTTP)
- [x] Stash & Clash (SS, SSR, VMess, Trojan, HTTP)

### Supported Target Platforms

- [x] QX
- [x] Loon
- [x] Surge
- [x] Stash & Clash
- [x] ShadowRocket

## 2. Subscription Formatting

### Filtering

- [x] **Regex filter**
- [x] **Discard regex filter**
- [x] **Region filter**
- [x] **Type filter**
- [x] **Useless proxies filter**
- [x] **Script filter**

### Proxy Operations

- [x] **Set property operator**: set some proxy properties such as `udp`,`tfo`
  , `skip-cert-verify` etc.
- [x] **Flag operator**: add flags or remove flags for proxies.
- [x] **Sort operator**: sort proxies by name.
- [x] **Regex sort operator**: sort proxies by keywords (fallback to normal
  sort).
- [x] **Regex rename operator**: replace by regex in proxy names.
- [x] **Regex delete operator**: delete by regex in proxy names.
- [x] **Script operator**: modify proxy by script.


## 3. Deployment

### Docker Deployment (Recommended)

This project supports Docker deployment with optimized configuration for PWA and SPA features.

[![Docker Build](https://github.com/sub-store-org/Sub-Store-Front-End/actions/workflows/docker.yml/badge.svg)](https://github.com/sub-store-org/Sub-Store-Front-End/actions/workflows/docker.yml)

#### Using Pre-built Image from GitHub Container Registry

The easiest way to deploy is using the pre-built Docker image:

```bash
# Pull the latest image (replace with your own registry if self-hosted)
docker pull ghcr.io/<owner>/sub-store-front-end:latest

# Run with default configuration
docker run -d \
  -p 8888:8888 \
  --name sub-store-frontend \
  ghcr.io/<owner>/sub-store-front-end:latest

# Run with custom backend API
docker run -d \
  -p 8888:8888 \
  --name sub-store-frontend \
  ghcr.io/<owner>/sub-store-front-end:latest

# Or use with docker compose (create docker-compose.yml)
services:
  sub-store-frontend:
    image: ghcr.io/<owner>/sub-store-front-end:latest
    container_name: sub-store-frontend
    ports:
      - "8888:8888"
    environment:
      - TZ=Asia/Shanghai
    restart: unless-stopped
```

> **Note**: Replace `<owner>` with the actual GitHub username or organization name that hosts the image.

**Available Tags:**
- `latest` - Latest stable build from master branch
- `v2.x.x` - Specific version tags
- `master-<sha>` - Build from specific commit

#### Build from Source

If you prefer to build the image yourself:

#### Quick Start

```bash
# Use default configuration (connects to https://sub.store)
docker compose up -d --build

# Access the application
# http://localhost:8888
```

#### Custom Configuration

All configuration options can be set via:
1. **Environment variables** when running docker compose
2. **`.env` file** in the project root (see `.env.production` for examples)
3. **Command line arguments** with `--build-arg`

**Available Environment Variables:**
- `VITE_API_URL` - Backend API URL (default: `https://sub.store`)
- `PORT` - Frontend service port (default: `8888`)
- `NETWORK_NAME` - Docker network name (default: `sub-store-network`)
- `NETWORK_EXTERNAL` - Use external network (default: `false`)

**Option 1: Environment Variables**
```bash
# Custom backend API URL
VITE_API_URL=http://your-backend:3000 docker compose up -d --build

# Custom port
PORT=9999 docker compose up -d
```

**Option 2: .env File**
```bash
# Create .env file (recommended for production)
cat > .env << EOF
# Backend API configuration
VITE_API_URL=http://sub-store-backend:3000

# Frontend port
PORT=8888

# Network configuration
NETWORK_NAME=sub-store-network
NETWORK_EXTERNAL=false
EOF

# Start with docker compose
docker compose up -d --build
```

> **Tip**: Check `.env.production` for more configuration examples and usage instructions.

**Option 3: Direct Docker Build**
```bash
# Build image with custom API URL
docker build --build-arg VITE_API_URL=http://your-backend:3000 -t sub-store-frontend .

# Run container
docker run -d -p 8888:8888 --name sub-store-frontend sub-store-frontend
```

**Option 4: Connect with Backend Container (Same Docker Network)**
```bash
# Method 1: Use default network (sub-store-network)
# Frontend will connect to backend via service name
VITE_API_URL=http://sub-store-backend:3000 docker compose up -d --build

# Method 2: Use existing external network
# If your backend is already in a network named "my-network"
NETWORK_NAME=my-network NETWORK_EXTERNAL=true VITE_API_URL=http://backend-service:3000 docker compose up -d --build

# Method 3: Full stack deployment example
# Create a docker-compose file that includes both frontend and backend
# See example below
```

**Full Stack Deployment Example**:
```yaml
# docker-compose.fullstack.yml
services:
  sub-store-backend:
    image: your-backend-image:latest
    container_name: sub-store-backend
    ports:
      - "3000:3000"
    networks:
      - sub-store-network

  sub-store-frontend:
    build:
      context: .
      dockerfile: Dockerfile
      args:
        VITE_API_URL: http://sub-store-backend:3000
    container_name: sub-store-frontend
    ports:
      - "8888:8888"
    networks:
      - sub-store-network
    depends_on:
      - sub-store-backend

networks:
  sub-store-network:
    driver: bridge
```

Start with: `docker compose -f docker-compose.fullstack.yml up -d --build`

#### Docker Features

- ✅ Multi-stage build optimized image (~50MB)
- ✅ PWA Service Worker cache strategy optimized
- ✅ Dynamic backend API configuration via environment variables
- ✅ Health check and auto-restart support
- ✅ gzip compression and static resource caching
- ✅ Nginx configuration optimized for SPA routing

#### Health Check

```bash
# Check container health
docker compose ps

# Check health endpoint
curl http://localhost:8888/health
# Should return: healthy
```

#### Logs

```bash
# View logs
docker compose logs -f sub-store-frontend

# Stop container
docker compose down
```

### Development

#### Guidelines

Commit message follows [@commitlint/config-angular](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-angular)

#### Created in the following version:
- pnpm v7.3.0
- Vite v2.9.9
- Vue v3.2
- Pinia v2
- Typescript v4.6

#### Font Awesome Icon
This project is using [Font Awesome](https://fontawesome.com/icons/check?s=regular) icons and this is [Documentation](https://fontawesome.com/docs/web/style/size)

#### Start
```bash
# install dependencies
pnpm i

# run the server
pnpm dev

# build the app
pnpm build

# preview the built app
pnpm preview
```

## LICENSE

This project is under the GPL V3 LICENSE.

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2FPeng-YM%2FSub-Store.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2FPeng-YM%2FSub-Store?ref=badge_large)

## Acknowledgements

- Special thanks to @KOP-XIAO for his awesome resource-parser. Please give
  a [star](https://github.com/KOP-XIAO/QuantumultX) for his great work!
- Speicial thanks to @Orz-3 and @58xinian for their awesome icons.
