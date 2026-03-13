# Netplan Static IP Configurator

Script Bash para configurar **endereços IP estáticos automaticamente em sistemas Linux que utilizam Netplan**, como Ubuntu Server.

O script facilita a criação do arquivo de configuração YAML do Netplan, aplica a configuração de rede automaticamente e permite configurar DNS opcionalmente.

---

# Autor

**Gustavo Rodrigues**
SysAdmin - NOC Engineer

---

# Descrição

Este projeto fornece um script Bash simples e seguro para automatizar a configuração de rede em servidores Linux que utilizam **Netplan**.

Ele foi desenvolvido para facilitar a configuração de:

* endereço IP estático
* máscara de rede (CIDR)
* gateway padrão
* servidores DNS
* aplicação automática da configuração

O script também cria **backup automático da configuração anterior do Netplan**, evitando perda de configuração em caso de erro.

---

# Funcionalidades

* Listagem de interfaces de rede disponíveis
* Configuração de IP estático
* Configuração de CIDR
* Configuração de gateway padrão
* Configuração opcional de DNS
* Backup automático do arquivo Netplan existente
* Validação básica de IP
* Geração automática do arquivo YAML
* Aplicação automática da configuração
* Reinício automático do serviço de rede

---

# Compatibilidade

Distribuições Linux com suporte ao **Netplan**:

* Ubuntu Server 18.04+
* Ubuntu Server 20.04
* Ubuntu Server 22.04
* Ubuntu Server 24.04
* Sistemas derivados que utilizem Netplan

---

# Requisitos

Pacotes necessários no sistema:

* netplan.io
* iproute2
* systemd-networkd

Para verificar se o Netplan está instalado:

```
netplan --version
```

Caso necessário instalar:

```
sudo apt update
sudo apt install netplan.io
```

---

# Estrutura do Projeto

```
netplan-ip-configurator
│
├── config_network.sh
├── README.md
└── LICENSE
```

---

# Instalação

Clone o repositório:

```
git clone https://github.com/SEU_USUARIO/netplan-ip-configurator.git
```

Entre na pasta do projeto:

```
cd netplan-ip-configurator
```

Dê permissão de execução ao script:

```
chmod +x config_network.sh
```

---

# Execução

Execute o script como **root** ou utilizando **sudo**:

```
sudo ./config_network.sh
```

---

# Fluxo de execução

Durante a execução o script solicitará as seguintes informações:

1. Se deseja listar interfaces de rede disponíveis
2. Interface de rede que será configurada
3. Endereço IP estático
4. CIDR da rede
5. Gateway padrão
6. Configuração opcional de DNS

---

# Exemplo de execução

```
CONFIGURADOR DE IP FIXO - NETPLAN

Deseja listar interfaces de rede disponíveis? (s/n): s

Interfaces disponíveis:
ens33
ens160

Informe a interface de rede (ex: ens33): ens33
Informe o IP fixo (ex: 10.10.10.50): 10.10.10.50
Informe o CIDR (ex: /24): /24
Informe o gateway (ex: 10.10.10.1): 10.10.10.1
Deseja configurar DNS? (s/n): s
Digite os servidores DNS separados por espaço: 8.8.8.8 1.1.1.1
```

---

# Arquivo de configuração gerado

O script cria ou sobrescreve o arquivo:

```
/etc/netplan/01-config-network.yaml
```

Exemplo de configuração gerada:

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

# Backup automático

Antes de alterar a configuração atual, o script cria automaticamente um backup:

```
/etc/netplan/backup_DATA_HORA.yaml
```

Exemplo:

```
/etc/netplan/backup_2026-03-13_104522.yaml
```

Isso permite restaurar facilmente uma configuração anterior.

---

# Aplicação da configuração

Após gerar o arquivo YAML o script executa automaticamente:

```
netplan generate
netplan apply
systemctl restart systemd-networkd
```

Também remove IPs antigos da interface para evitar conflitos.

---

# Avisos importantes

⚠ Alterações de rede podem interromper conexões SSH caso configuradas incorretamente.

Recomenda-se:

* testar em ambiente local
* validar IP, gateway e interface antes de aplicar
* ter acesso ao console do servidor

---

# Melhorias futuras

Possíveis melhorias para o projeto:

* suporte a múltiplos IPs
* suporte a VLAN
* suporte a interfaces bond
* suporte a modo automático via argumentos
* criação de logs
* integração com ferramentas de automação

---

# Licença

Este projeto está licenciado sob a licença **MIT**.

---

# Author

**Gustavo Henrique Rodrigues**  
SysAdmin - NOC Engineer  

[LinkedIn](https://www.linkedin.com/in/gustavo-henrique-rodrigues-3070a5260)
