# Common linux commands
* Author:   Pedric Kng  
* Updated:  04 Dec 2019

***
## Tail linux system blogs
```bash
tail -f /var/log/syslog
```
## SSH Installation
  ```bash
  sudo apt install openssh-server
  sudo systemctl status ssh
  sudo ufw allow ssh
  ```

## Dotnet SDK Installation
  ```bash
  wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
  sudo apt-get install apt-transport-https
  sudo apt-get update
  sudo apt-get install dotnet-sdk-2.1
  ```
  
  ```bash
  wget https://download.visualstudio.microsoft.com/download/pr/e5eef3df-d2e3-429b-8204-f58372eb6263/20c825ddcc6062e93ff0c60e8354d3af/dotnet-sdk-2.1.500-linux-x64.tar.gz
  sudo mkdir -p /opt/dotnet && sudo tar zxf dotnet-sdk-2.1.500-linux-x64.tar.gz -C /opt/dotnet
  sudo ln -s /opt/dotnet/dotnet /usr/local/bin
  dotnet --info
  ```
## Remove Dotnet
  ```bash
  apt-get remove dotnet-host
  ```
  
## Openjdk 8 installation
  ```bash
  sudo apt-get install openjdk-8-jdk
  java -version
  ```

## Create/Edit Systemctl (Systemd) Service

List all services
```bash
sudo systemctl
```

If service already exists, you need to stop the service.
```bash
sudo systemctl stop <service name>

# Optional to delete the service
sudo systemctl disable <service name>
```

Create/Extend new service file
```bash
# Create new service file
sudo vim /etc/systemd/system/<servicename>.service

# Edit existing service file
sudo systemctl edit <servicename>
```
Refer to [[2]] for service file editing

Add service to systemctl
```bash
# Reload the service configuration
sudo systemctl daemon-reload

# Manual reload
sudo systemctl reload <servicename>

# Add service to systemctl
sudo systemctl enable <servicename>.service
sudo systemctl start <servicename>
sudo systemctl status <servicename>
```

Remove service from systemctl
```bash
# Reload the service configuration
sudo systemctl stop <servicename>
sudo systemctl disable <servicename>
rm /etc/systemd/system/<servicename>.service
systemctl daemon-reload
systemctl reset-failed
```



## References
Introduction to Systemctl [[1]]  
Working with unit files [[2]]  

[1]:https://www.linode.com/docs/quick-answers/linux-essentials/introduction-to-systemctl/ "Introduction to Systemctl"
[2]:https://www.linode.com/docs/quick-answers/linux-essentials/introduction-to-systemctl/#working-with-unit-files "Working with unit files"
