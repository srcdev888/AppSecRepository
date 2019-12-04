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

## References
Introduction to Systemctl [[1]]  
Working with unit files [[2]]  

[1]:https://www.linode.com/docs/quick-answers/linux-essentials/introduction-to-systemctl/ "Introduction to Systemctl"
[2]:https://www.linode.com/docs/quick-answers/linux-essentials/introduction-to-systemctl/#working-with-unit-files "Working with unit files"
