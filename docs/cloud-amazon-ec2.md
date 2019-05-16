# Amazon EC2 cloud setup

## AWS account creation

Creating an Amazon AWS account requires giving Amazon a phone number that can receive a call and has a number pad to enter a PIN challenge displayed in the browser. This phone system prompt occasionally fails to correctly validate input, but try again (request a new PIN in the browser) until you succeed.

### Select an EC2 plan

The cheapest EC2 plan you can choose is the "Free Plan" a.k.a. the "AWS Free Tier." It is only available to new AWS customers, it has limits on usage, and it converts to standard pricing after 12 months (the "introductory period"). After you exceed the usage limits, after the 12 month period, or if you are an existing AWS customer, then you will pay standard pay-as-you-go service prices.

*Note*: Your Algo instance will not stop working when you hit the bandwidth limit, you will just start accumulating service charges on your AWS account.

As of the time of this writing (July 2018), the Free Tier limits include "750 hours of Amazon EC2 Linux t2.micro instance  usage" per month, 15 GB of bandwidth (outbound) per month, and 30 GB of cloud storage. Algo will not even use 1% of the storage limit, but you may have to monitor your bandwidth usage or keep an eye out for the email from Amazon when you are about to exceed the Free Tier limits.

### Create an AWS permissions policy

In the AWS console, find the policies menu: click Services > IAM > Policies. Click Create Policy.

Here, you have the policy editor. Switch to the JSON tab and copy-paste over the existing empty policy with [the minimum required AWS policy needed for Algo deployment](https://github.com/trailofbits/algo/blob/master/docs/deploy-from-ansible.md#minimum-required-iam-permissions-for-deployment).

![Creating a new permissions policy in the AWS console.](/docs/images/aws-ec2-new-policy.png)

### Set up an AWS user

In the AWS console, find the users (“Identity and Access Management”, a.k.a. IAM users) menu: click Services > IAM.

Activate multi-factor authentication (MFA) on your root account. The simplest choice is the mobile app "Google Authenticator." A hardware U2F token is ideal (less prone to a phishing attack), but a TOTP authenticator like this is good enough.

![The new user screen in the AWS console.](/docs/images/aws-ec2-new-user.png)

Now "Create individual IAM users" and click Add User. Create a user name. I chose “algovpn”. Then click the box next to Programmatic Access. Then click Next.

![The IAM user naming screen in the AWS console.](/docs/images/aws-ec2-new-user-name.png)

Next, click “Attach existing policies directly.” Type “Algo” in the search box to filter the policies. Find “AlgoVPN_Provisioning” (the policy you created) and click the checkbox next to that. Click Next when you’re done.

![Attaching a policy to an IAM user in the AWS console.](/docs/images/aws-ec2-attach-policy.png)

The user creation confirmation screen should look like this if you've done everything correctly.

![New user creation confirmation screen in the AWS console.](/docs/images/aws-ec2-new-user-confirm.png)

On the final screen, click the Download CSV button. This file includes the AWS access keys you’ll need during the Algo set-up process. Click Close, and you’re all set.

![Downloading the credentials for an AWS IAM user.](/docs/images/aws-ec2-new-user-csv.png)

## Using EC2 during Algo setup

After you have downloaded Algo and installed its dependencies, the next step is running Algo to provision the VPN server  on your AWS account.

First you will be asked which server type to setup. You would want to enter "2" to use Amazon EC2.

```
$ ./algo

  What provider would you like to use?
    1. DigitalOcean
    2. Amazon EC2
    3. Microsoft Azure
    4. Google Compute Engine
    5. Scaleway
    6. OpenStack (DreamCompute optimised)
    7. Install to existing Ubuntu 16.04 server (Advanced)

Enter the number of your desired provider
: 2
```

Next you will be asked for the AWS Access Key (Access Key ID) and AWS Secret Key (Secret Access Key) that you received in  the CSV file when you setup the account (don't worry if you don't see your text entered in the console; the key input is  hidden here by Algo).

```
Enter your aws_access_key (http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)
Note: Make sure to use an IAM user with an acceptable policy attached (see https://github.com/trailofbits/algo/blob/master/docs/deploy-from-ansible.md).
[pasted values will not be displayed]
[AKIA...]: 

Enter your aws_secret_key (http://docs.aws.amazon.com/general/latest/gr/managing-aws-access-keys.html)
[pasted values will not be displayed]
[ABCD...]: 
```

You will be prompted for the server name to enter. Feel free to leave this as the default ("algo") if you are not certain  how this will affect your setup. Here we chose to call it "algovpn".

```
Name the vpn server:
[algo]: algovpn
```

After entering the server name, the script ask which region you wish to setup your new Algo instance in. Enter the number  next to name of the region.

```
  What region should the server be located in?
    1.   us-east-1           US East (N. Virginia)
    2.   us-east-2           US East (Ohio)
    3.   us-west-1           US West (N. California)
    4.   us-west-2           US West (Oregon)
    5.   ca-central-1        Canada (Central)
    6.   eu-central-1        EU (Frankfurt)
    7.   eu-west-1           EU (Ireland)
    8.   eu-west-2           EU (London)
    9.   eu-west-3           EU (Paris)
    10.  ap-northeast-1      Asia Pacific (Tokyo)
    11.  ap-northeast-2      Asia Pacific (Seoul)
    12.  ap-northeast-3      Asia Pacific (Osaka-Local)
    13.  ap-southeast-1      Asia Pacific (Singapore)
    14.  ap-southeast-2      Asia Pacific (Sydney)
    15.  ap-south-1          Asia Pacific (Mumbai)
    16.  sa-east-1           South America (São Paulo)

Enter the number of your desired region:
[1]: 10
```

You will then be asked the remainder of the standard Algo setup questions.

## Cleanup
If you've installed Algo onto EC2 multiple times, your AWS account may become cluttered with unused or deleted resources e.g. instances, VPCs, subnets, etc. This may cause future installs to fail. The easiest way to clean up after you're done with a server is to go to "CloudFormation" from the console and delete the CloudFormation stack associated with that server. Please note that unless you've enabled termination protection on your instance, deleting the stack this way will delete your instance without warning, so be sure you are deleting the correct stack.
