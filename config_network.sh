#!/bin/bash

# ==================================================
# CONFIGURADOR DE IP FIXO PARA NETPLAN
# Autor: gustavoohrodrigues
# ==================================================

NETPLAN_FILE="/etc/netplan/01-config-network.yaml"

echo "==============================================="
echo "   CONFIGURADOR DE IP FIXO - NETPLAN"
echo "   Autor: Gustavo Rodrigues"
echo "==============================================="

# Verifica se é root
if [[ $EUID -ne 0 ]]; then
    echo "Este script precisa ser executado como root."
    exit 1
fi

# Lista interfaces
read -p "Deseja listar interfaces de rede disponíveis? (s/n): " LISTAR

if [[ "$LISTAR" =~ ^[Ss]$ ]]; then
    echo ""
    echo "Interfaces disponíveis:"
    ip -br link | awk '{print $1}' | grep -v lo
    echo ""
fi

# Interface
read -p "Informe a interface de rede (ex: ens33): " INTERFACE

# Verifica se interface existe
if ! ip link show "$INTERFACE" &> /dev/null; then
    echo "Interface inválida!"
    exit 1
fi

# IP
read -p "Informe o IP fixo (ex: 10.1.11.226): " IP

# Validação simples de IP
if ! [[ $IP =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "IP inválido!"
    exit 1
fi

# CIDR
read -p "Informe o CIDR (ex: /24 ou /16): " CIDR

# Gateway
read -p "Informe o gateway (ex: 10.1.1.1): " GATEWAY

# DNS
read -p "Deseja configurar DNS? (s/n): " CONFIG_DNS

DNS_BLOCK=""

if [[ "$CONFIG_DNS" =~ ^[Ss]$ ]]; then

    read -p "Digite os servidores DNS separados por espaço (ex: 8.8.8.8 1.1.1.1): " DNS_ENTRADA

    DNS_BLOCK="      nameservers:
        addresses:"

    for dns in $DNS_ENTRADA; do
        DNS_BLOCK="$DNS_BLOCK
          - $dns"
    done
fi

echo ""
echo "Gerando configuração Netplan..."
echo ""

# Backup da configuração anterior
if [ -f "$NETPLAN_FILE" ]; then
    BACKUP="/etc/netplan/backup_$(date +%F_%H%M%S).yaml"
    cp "$NETPLAN_FILE" "$BACKUP"
    echo "Backup criado em: $BACKUP"
fi

# Cria configuração
cat <<EOF > "$NETPLAN_FILE"
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      dhcp4: false
      dhcp6: false
      addresses:
        - $IP$CIDR
      routes:
        - to: default
          via: $GATEWAY
$DNS_BLOCK
EOF

chmod 600 "$NETPLAN_FILE"

echo ""
echo "Arquivo gerado:"
echo "--------------------------------"
cat "$NETPLAN_FILE"
echo "--------------------------------"
echo ""

read -p "Deseja aplicar essa configuração agora? (s/n): " APPLY

if [[ "$APPLY" =~ ^[Ss]$ ]]; then

    echo ""
    echo "Limpando IP antigo da interface..."
    ip addr flush dev "$INTERFACE"

    echo "Gerando configuração..."
    netplan generate

    echo "Aplicando configuração..."
    netplan apply

    echo "Reiniciando systemd-networkd..."
    systemctl restart systemd-networkd

    echo ""
    echo "Configuração aplicada!"
    echo ""

    ip -br a show "$INTERFACE"

else
    echo "Configuração salva mas NÃO aplicada."
fi

echo ""
echo "Finalizado."
