# Netplan Static IP Configurator

A Bash script to automatically configure **static IP addresses on Linux systems using Netplan**, such as Ubuntu Server.

This script simplifies the process of generating the Netplan YAML configuration file, applying the network configuration, and optionally configuring DNS servers.

---

# Author

**Gustavo Henrique Rodrigues**
SysAdmin - NOC Engineer

[LinkedIn](https://www.linkedin.com/in/gustavo-henrique-rodrigues-3070a5260)

---

# Description

This project provides a simple and safe Bash script to automate network configuration on Linux servers that use **Netplan**.

It was designed to simplify the configuration of:

* static IP address
* network mask (CIDR)
* default gateway
* DNS servers
* automatic configuration deployment

The script also creates an **automatic backup of the previous Netplan configuration**, preventing configuration loss in case of mistakes.

---

# Features

* Network interface discovery
* Static IP configuration
* CIDR configuration
* Default gateway configuration
* Optional DNS configuration
* Automatic backup of existing Netplan configuration
* Basic IP validation
* Automatic YAML file generation
* Automatic configuration application
* Automatic restart of network services

---

# Compatibility

Linux distributions that support **Netplan**, including:

* Ubuntu Server 18.04+
* Ubuntu Server 20.04
* Ubuntu Server 22.04
* Ubuntu Server 24.04
* Netplan-based distributions

---

# Requirements

Required packages:

* netplan.io
* iproute2
* systemd-networkd

Check Netplan installation:

```
netplan --version
```

Install if necessary:

```
sudo apt update
sudo apt install netplan.io
```

---

# Project Structure

```
netplan-ip-configurator
│
├── config_network.sh
├── README.md
└── LICENSE
```

---

# Installation

Clone the repository:

```
git clone https://github.com/YOUR_USERNAME/netplan-ip-configurator.git
```

Enter the project directory:

```
cd netplan-ip-configurator
```

Make the script executable:

```
chmod +x config_network.sh
```

---

# Usage

Run the script as **root** or using **sudo**:

```
sudo ./config_network.sh
```

---

# Execution Flow

During execution the script will ask for the following information:

1. Whether to list available network interfaces
2. The network interface to configure
3. Static IP address
4. Network CIDR
5. Default gateway
6. Optional DNS configuration

---

# Example Execution

```
STATIC IP CONFIGURATOR - NETPLAN

Do you want to list available network interfaces? (y/n): y

Available interfaces:
ens33
ens160

Enter the network interface (example: ens33): ens33
Enter the static IP (example: 10.10.10.50): 10.10.10.50
Enter the CIDR (example: /24): /24
Enter the gateway (example: 10.10.10.1): 10.10.10.1
Configure DNS? (y/n): y
Enter DNS servers separated by space: 8.8.8.8 1.1.1.1
```

---

# Generated Configuration File

The script creates or overwrites the file:

```
/etc/netplan/01-config-network.yaml
```

Example configuration:

```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:
      dhcp4: false
      dhcp6: false
      addresses:
        - 10.10.10.50/24
      routes:
        - to: default
          via: 10.10.10.1
      nameservers:
        addresses:
          - 8.8.8.8
          - 1.1.1.1
```

---

# Automatic Backup

Before modifying the current configuration, the script automatically creates a backup:

```
/etc/netplan/backup_DATE_TIME.yaml
```

Example:

```
/etc/netplan/backup_2026-03-13_104522.yaml
```

This allows easy restoration of a previous configuration.

---

# Applying Configuration

After generating the YAML file, the script automatically executes:

```
netplan generate
netplan apply
systemctl restart systemd-networkd
```

It also flushes existing IP addresses on the interface to prevent conflicts.

---

# Important Warnings

⚠ Network changes may interrupt SSH connections if configured incorrectly.

Recommended practices:

* Test in a local environment
* Validate IP, gateway, and interface before applying
* Ensure console access to the server

---

# Future Improvements

Possible improvements for the project:

* Multiple IP support
* VLAN support
* Bond interface support
* Automatic mode via CLI arguments
* Logging system
* Integration with automation tools

---

# License

This project is licensed under the **MIT License**.
