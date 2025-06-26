#!/usr/bin/env bash
# fix_dns.sh — 一键锁定 Debian VPS DNS 为公共服务器

set -euo pipefail

# 如果不是 root，就自动提权
if [ "$EUID" -ne 0 ]; then
  exec sudo bash "$0" "$@"
fi

cat << 'EOF'
===============================================
    一键 Fix DNS 脚本 —— Debian VPS 专用
    将 /etc/resolv.conf 固定为公共 DNS，
    并锁定文件防止任何覆盖（DHCP/cloud-init）
===============================================
EOF

read -p "确认要执行 DNS 修复并锁定？[y/N] " yn
case "$yn" in
  [Yy]* )
    echo "→ 步骤 1：更新包列表并移除 resolvconf…"
    apt update -y
    apt purge -y resolvconf

    echo "→ 步骤 2：删除旧的 /etc/resolv.conf…"
    rm -f /etc/resolv.conf

    echo "→ 步骤 3：写入新的 DNS 列表…"
    cat > /etc/resolv.conf << 'DNSEOF'
# 固定 DNS 列表，由脚本管理
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
nameserver 223.5.5.5
nameserver 2606:4700:4700::1111
nameserver 2606:4700:4700::1001
nameserver 2001:4860:4860::8888
nameserver 2001:4860:4860::8844
DNSEOF

    echo "→ 步骤 4：锁定 /etc/resolv.conf（不可变）…"
    if command -v chattr &>/dev/null; then
      chattr +i /etc/resolv.conf && echo "Lock succeeded."
    else
      echo "⚠️ chattr not found, skipping lock."
    fi

    echo
    echo "✅ 完成！当前 DNS 如下："
    grep '^nameserver' /etc/resolv.conf
    echo
    echo "如需修改，请先运行：sudo chattr -i /etc/resolv.conf"
    echo "修改后再运行：sudo chattr +i /etc/resolv.conf"
    ;;
  * )
    echo "❌ 已取消。没有做任何更改。"
    ;;
esac
