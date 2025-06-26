# Dns-Fix-vps
One-click DNS lock script for Debian VPS
# fix-dns

**One-click DNS lock script for Debian VPS**

本脚本用于将 Debian VPS 的 `/etc/resolv.conf` 固定为公共 DNS 服务器（Cloudflare、Google、阿里等），并通过 `chattr +i` 将文件锁定，防止任何系统组件（DHCP、cloud-init、NetworkManager 或云平台 agent）覆盖。

## 使用方法

一行命令拉取并运行：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/luck7x/fix-dns/main/fix_dns.sh)
