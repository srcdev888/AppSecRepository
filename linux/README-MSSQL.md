# Installing MS SQL 2017 on Ubuntu 18.04.3
* Author:   Pedric Kng  
* Updated:  04 Dec 2019

***

## Overview
This page describes the installation of MS SQL 2017 on Ubuntu 18.04.3 which is not officially supported and requires a tweak on libcurl library for support.

## Step by step
  1. Follow article [[1]] to install MS SQL
  2. Installing Libcurl3

  Prior to SQL Server for Linux 2017 CU10 the package dependencies prevented install on Ubuntu 18.04 LTS. The SQL Server 2017 installation packages have updated use the libssl1.0.0 package, allowing installation to occur on Ubuntu 18.04 LTS installations.

  Ubuntu 18.04 LTS was updated and ships with version 1.1 of the openssl package. SQL Server 2017 for Linux had version a 1.0 openssl dependency. The correct dependency is the libssl1.0.0 package which CU10 corrects.

  There may be additional actions required on some systems. If libcurl4 is installed libcurl4 should be removed and libcurl3 installed as shown in these example commands.

  If libcurl4 exists, it should be removed
  ```bash
    sudo apt-get remove libcurl4
  ```

  Install libcurl4
  ```bash
  sudo apt-get update -y
  sudo apt-get install -y libcurl3
  ```
  Alter MS SQL openssl dependencies
  ```bash
  # Stop MS SQL Server
  sudo systemctl stop mssql-server

  # Edit service configuration for mssql
  sudo systemctl edit mssql-server
  ```

  Add the following lines in service configuration
  ```bash
  [Service]
  Environment="LD_LIBRARY_PATH=/opt/mssql/lib"
  ```

  Create symbolic links to OpenSSL 1.0 for SQL Server to use
  ```bash
  sudo ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /opt/mssql/lib/libssl.so
  sudo ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /opt/mssql/lib/libcrypto.so
  ```
  Reload service configuration
  ```bash
  sudo systemctl daemon-reload
  ```
  Start SQL Server
  ```bash
  sudo systemctl start mssql-server
  ```
  Check SQL Server status
  ```bash
  sudo systemctl status mssql-server
  ```
  3. Open firewall ports for MS sql
 ```bash
  # MS SQL service port
  sudo ufw 1433
  # MS SQL Admin port
  sudo ufw 1434
  ```



## References
Installing MS SQL on Ubuntu [[1]]  
Resolving Libcurl3 on MS SQL Linux Installation [[2]]  

[1]:https://docs.microsoft.com/en-us/sql/linux/quickstart-install-connect-ubuntu?view=sql-server-ver15 "Installing MS SQL on Ubuntu"
[2]:https://blogs.msdn.microsoft.com/sql_server_team/installing-sql-server-2017-for-linux-on-ubuntu-18-04-lts/ "Resolving Libcurl3 on MS SQL Linux Installation"
