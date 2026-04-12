#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="${1:-/var/www/CRMEB}"
ADMIN_DIR="$PROJECT_ROOT/template/admin"
DIST_DIR="$ADMIN_DIR/dist"
TARGET_DIR="$PROJECT_ROOT/crmeb/public/admin"

echo "==> Admin dir:  $ADMIN_DIR"
echo "==> Dist dir:   $DIST_DIR"
echo "==> Target dir: $TARGET_DIR"

[ -d "$ADMIN_DIR" ] || { echo "Admin source not found: $ADMIN_DIR"; exit 1; }
[ -d "$TARGET_DIR" ] || { echo "Target dir not found: $TARGET_DIR"; exit 1; }

cd "$ADMIN_DIR"

if [ "${SKIP_INSTALL:-0}" != "1" ]; then
  echo "==> npm install"
  npm install
fi

echo "==> npm run build"
NODE_OPTIONS="--max-old-space-size=1536" npm run build

[ -d "$DIST_DIR" ] || { echo "Build output not found: $DIST_DIR"; exit 1; }

echo "==> Sync dist -> public/admin"
rm -rf "${TARGET_DIR:?}/"*
cp -a "$DIST_DIR/." "$TARGET_DIR/"

echo "==> Done"
echo "Next: 浏览器 Ctrl+F5 强刷；若有 CDN 再清 /admin 缓存。"
