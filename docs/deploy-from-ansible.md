# Scripted Deployment

Before you begin, make sure you have installed all the dependencies necessary for your operating system as described in the [README](../README.md).

You can deploy Algo non-interactively by running the Ansible playbooks directly with `ansible-playbook`.

`ansible-playbook` accepts "tags" via the `-t` or `TAGS` options. You can pass tags as a list of comma separated values. Ansible will only run plays (install roles) with the specified tags.

`ansible-playbook` accepts variables via the `-e` or `--extra-vars` option. You can pass variables as space separated key=value pairs. Algo requires certain variables that are listed below.

Here is a full example for DigitalOcean:

```shell
ansible-playbook main.yml -e "provider=digitalocean
                                server_name=algo
                                ondemand_cellular=false
                                ondemand_wifi=false
                                local_dns=true
                                ssh_tunneling=true
                                windows=false
                                store_cakey=true
                                region=ams3
                                do_token=token"
```

See below for more information about providers and extra variables

### Variables

- `provider` - (Required) The provider to use. See possible values below
- `server_name` - (Required) Server name. Default: algo
- `ondemand_cellular` (Optional) VPN On Demand when connected to cellular networks. Default: false
- `ondemand_wifi` - (Optional. See `ondemand_wifi_exclude`) VPN On Demand when connected to WiFi networks. Default: false
- `ondemand_wifi_exclude` (Required if `ondemand_wifi` set) - WiFi networks to exclude from using the VPN. Comma-separated values
- `local_dns` - (Optional) Enable a DNS resolver. Default: false
- `ssh_tunneling` - (Optional) Enable SSH tunneling for each user. Default: false
- `windows` - (Optional) Enables compatible ciphers and key exchange to support Windows clients, less secure. Default: false
- `store_cakey` - (Optional) Whether or not keep the CA key (required to add users in the future, but less secure). Default: false

If any of those unspecified ansible will ask the user to input

### Ansible roles

Roles can be activated by specifying an extra variable `provider`

Cloud roles:

- role: cloud-digitalocean, provider: digitalocean
- role: cloud-ec2,          provider: ec2
- role: cloud-vultr,        provider: vultr
- role: cloud-gce,          provider: gce
- role: cloud-azure,        provider: azure
- role: cloud-scaleway,     provider: scaleway
- role: cloud-openstack,    provider: openstack

Server roles:

- role: vpn
- role: dns_adblocking
- role: dns_encryption
- role: ssh_tunneling
- role: wireguard

Note: The `vpn` role generates Apple profiles with On-Demand Wifi and Cellular if you pass the following variables:

- ondemand_wifi: true
- ondemand_wifi_exclude: HomeNet,OfficeWifi
- ondemand_cellular: true

### Local Installation

- role: local, provider: local

Required variables:

- server - IP address of your server
- ca_password - Password for the private CA key

Note that by default, the iptables rules on your existing server will be overwritten. If you don't want to overwrite the iptables rules, you can use the `--skip-tags iptables` flag.

### Digital Ocean

Required variables:

- do_token
- region

Possible options can be gathered calling to https://api.digitalocean.com/v2/regions

### Amazon EC2

Required variables:

- aws_access_key
- aws_secret_key
- region

Possible options can be gathered via cli `aws ec2 describe-regions`

Additional variables:

- [encrypted](https://aws.amazon.com/blogs/aws/new-encrypted-ebs-boot-volumes/) - Encrypted EBS boot volume. Boolean (Default: false)

#### Minimum required IAM permissions for deployment:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PreDeployment",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
                "ec2:DescribeKeyPairs",
                "ec2:DescribeRegions",
                "ec2:ImportKeyPair",
                "ec2:CopyImage"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "DeployCloudFormationStack",
            "Effect": "Allow",
            "Action": [
                "cloudformation:CreateStack",
                "cloudformation:UpdateStack",
                "cloudformation:DescribeStacks",
                "cloudformation:DescribeStackEvents",
                "cloudformation:ListStackResources"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Sid": "CloudFormationEC2Access",
            "Effect": "Allow",
            "Action": [
                "ec2:CreateInternetGateway",
                "ec2:DescribeVpcs",
                "ec2:CreateVpc",
                "ec2:DescribeInternetGateways",
                "ec2:ModifyVpcAttribute",
                "ec2:createTags",
                "ec2:CreateSubnet",
                "ec2:Associate*",
                "ec2:CreateRouteTable",
                "ec2:AttachInternetGateway",
                "ec2:DescribeRouteTables",
                "ec2:DescribeSubnets",
                "ec2:ModifySubnetAttribute",
                "ec2:CreateRoute",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeSecurityGroups",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:RunInstances",
                "ec2:DescribeInstances",
                "ec2:AllocateAddress",
                "ec2:DescribeAddresses"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

### Google Compute Engine

Required variables:

- gce_credentials_file
- [region](https://cloud.google.com/compute/docs/regions-zones/)

### Vultr

Required variables:

- [vultr_config](https://trailofbits.github.io/algo/cloud-vultr.html)
- [region](https://api.vultr.com/v1/regions/list)

### Azure

Required variables:

- azure_secret
- azure_tenant
- azure_client_id
- azure_subscription_id
- [region](https://azure.microsoft.com/en-us/global-infrastructure/regions/)

### Lightsail

Required variables:

- aws_access_key
- aws_secret_key
- region

Possible options can be gathered via cli `aws lightsail get-regions`

#### Minimum required IAM permissions for deployment:

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "LightsailDeployment",
            "Effect": "Allow",
            "Action": [
                "lightsail:GetRegions",
                "lightsail:GetInstance",
                "lightsail:CreateInstances",
                "lightsail:OpenInstancePublicPorts"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
```

### Scaleway

Required variables:

- [scaleway_token](https://www.scaleway.com/docs/generate-an-api-token/)
- region

Possible regions:

- ams1
- par1

### OpenStack

You need to source the rc file prior to run Algo. Download it from the OpenStack dashboard->Compute->API Access and source it in the shell (eg: source /tmp/dhc-openrc.sh)


### Local

Required variables:

- server - IP or hostname to access the server via SSH
- endpoint - Public IP address or domain name of your server
- ssh_user


### Update users

Playbook:

```
users.yml
```

Required variables:

- server - IP or hostname to access the server via SSH
- ca_password - Password to access the CA key

Tags required:

- update-users
