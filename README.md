# Minecraft Server Automation

## Background

This project fully automates the provisioning and configuration of a Minecraft Java Edition server on AWS using Terraform and Ansible. Goals:
- Create AWS infrastructure from scratch
- Configure and launch a Minecraft Server on Amazon Linux 2023
- Ensure server restarts automatically on reboot
- Require no manual SSH access or AWS Console usage
Everything runs via CLI-based scripts. 

## Requirements

To run this, you will need the following installed:
- Terraform
- Ansible
- AWS CLI
- Python 
- nmap

You must also configure your AWS credentials locally before running the pipeline:
- In terminal (terraform directory), run:
    aws configure
  You will be prompted to enter:
    - AWS Access Key ID
    - AWS Secret Access Key
    - AWS Session Token
    - Default region: us-west-2
    - Output format: json
    
## Diagram
+----------------+       +--------------------+       +-----------------------------+
|   Local CLI    | ----> |   Terraform        | --->  |   AWS EC2 Instance          |
|                |       |   (main.tf, etc.)  |       |   + Security Group (SSH +   |
|                |       |                    |       |     Minecraft port 25565)   |
+----------------+       +--------------------+       +-----------------------------+
                                                              |
                                                              v
                                                  +---------------------------+
                                                  |  Ansible Provisioning     |
                                                  |  (minecraft.yml)          |
                                                  |  - Java Install           |
                                                  |  - Minecraft Setup        |
                                                  |  - systemd Service        |
                                                  +---------------------------+

## Commands to run

1. Clone the Repo
    - In terminal, run:
        git clone https://github.com/edithliang/minecraft-server-automation.git
        cd minecraft-server-automation/terraform
2. Configure AWS CLI
    - In terminal, run:
        aws configure
      Follow prompts (listed in Requirements section)
    - Note: Add session token manually to ~/.aws/credentials
        nano ~/.aws/credentials
3. Run Terraform to Provision EC2
    - In terminal, run:
        terraform init
        terraform apply
    - You should see an output like:
        Outputs:
        minecraft_server_ip = "52.43.157.23"
4. Run Ansible to Configure Server
    - Open new terminal and go back to project root (minecraft-server-automation)
    - In terminal, run: 
        ansible-playbook -i ansible/inventory.ini ansible/minecraft.yml --become
5. Verify Minecraft Server is Running
    - ansible -i ansible/inventory.ini all -a "systemctl status minecraft" --become

## Connect to Minecraft Server

From your Minecraft client, connect using the IP output from Terraform:
- multiplayer --> direct connection --> 52.43.157.23 --> join server
Or Verify using nmap:
- In terminal, run:
    nmap -sV -Pn -p T:25565 52.43.157.23

## Resources/Sources
- https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html
- https://www.minecraft.net/en-us/download/server
- https://registry.terraform.io/providers/hashicorp/aws/latest/docs
- https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html