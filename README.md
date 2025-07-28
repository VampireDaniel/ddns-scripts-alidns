# ddns-scripts-alidns

OpenWrt ddns-scripts provider for Aliyun DNS (alidns.com).

## Features
- Supports A/AAAA record updates
- Aliyun API signature authentication
- TTL, RecordId, IPv4/IPv6, interval, and retry options
- Error handling, logging, and debug mode
- LuCI and /etc/config/ddns configuration

## Installation

### Build with OpenWrt SDK
```
git clone https://github.com/openwrt/openwrt.git
cd openwrt
./scripts/feeds update -a
./scripts/feeds install -a
# Add this package to feeds or copy to package/ directory
make menuconfig # Select Network -> ddns-scripts-alidns
make package/ddns-scripts-alidns/compile V=s
```

### Install on Router
```
scp bin/packages/*/custom/ddns-scripts-alidns_*.ipk root@router:/tmp/
ssh root@router 'opkg install /tmp/ddns-scripts-alidns_*.ipk'
```

## Configuration

Edit `/etc/config/ddns` or use LuCI:
```
config service 'aliyun'
    option service_name 'alidns'
    option domain 'your.domain.com'
    option username 'YourAccessKeyId'
    option password 'YourAccessKeySecret'
    option ip_source 'web'
    option use_ipv6 '0'
    option ttl '600'
    option record_id ''
    option force_interval '72'
    option retry_interval '60'
    option verbose '2'
```

## Troubleshooting
- Check logs: `logread | grep ddns-alidns` or `/var/log/ddns.log`
- Ensure router time is synchronized (NTP)
- Use verbose mode for debugging

## Dependencies
- ddns-scripts, curl, openssl-util, jshn, jsonfilter

## Testing
- Run `shellcheck files/usr/lib/ddns/update_alidns.sh`
- Bats tests in `tests/`

## License
GPL-2.0 