# Git clone with SSH keys
* Author:   Pedric Kng  
* Updated:  09 Mar 21

This article share how to generate a git SSH key, install it on windows and execute a git clone

***

1. Generate the SSH keypair and store the key files as prompted e.g., C:\Users\\_you_\\.ssh
    ```bash
    # Generate the ras key pair
    ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
    ```
2. Check with your respective SCM on how to add the SSH public key accordingly.

3. Add the ssh keys to the ssh agent accordingly.
    ```bash
    # Check that the agent is up and running
    eval $(ssh-agent)

    # Add the private key file generated previously.
    ssh-add ~/.ssh/id_rsa
    ```

    * In the event of exception "invalid format", it could because the format is not accepted.  
    You can use PuttyGen[[3]] to convert the _Conversions -> Export OpenSSH key_

4. Execute a git clone

    ```bash
    git clone git@gitlab.com:cxdemosg/JavaVulnerableLab.git
    ```



## References
Generating Your SSH Public Key [[1]]  
Generating a new SSH key and adding it to the ssh-agent [[2]]  
Puttygen [[3]]  
How do I tell Git for Windows where to find my private RSA key? [[4]]  

[1]:https://git-scm.com/book/en/v2/Git-on-the-Server-Generating-Your-SSH-Public-Key "Generating Your SSH Public Key"
[2]:https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent "Generating a new SSH key and adding it to the ssh-agent"
[3]:https://www.puttygen.com/ "puttygen"
[4]:https://serverfault.com/questions/194567/how-do-i-tell-git-for-windows-where-to-find-my-private-rsa-key "How do I tell Git for Windows where to find my private RSA key?"