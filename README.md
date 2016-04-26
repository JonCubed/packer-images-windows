# Packer Scripts for Windows
Repository that stores packer scripts for creating windows images, like TeamCity

## Available Images

|Image                                 |Description|
|--------------------------------------|-----------|
|Windows 2012 R2 Base                  |Common image that all others will use|
|Windows 2012 R2 TeamCity Base (soon)  |Common image for TeamCity Server and Agent|
|Windows 2012 R2 TeamCity Server (soon)|Image for TeamCity Server|
|Windows 2012 R2 TeamCity Agent (soon) |Image for TeamCity Agent|

## Geting Started

### Prerequisite

You should install the following needed tools before starting:

* [Packer](https://www.packer.io/downloads.html)
    ```powershell
    > choco install packer
    ```
* [AWS Tools for Windows](http://sdk-for-net.amazonwebservices.com/latest/AWSToolsAndSDKForNet.msi)
 
### Setting up you AWS Account

 
* Create IAM Pocily for packer to use
 
 ```json
 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1461380639000",
      "Effect": "Allow",
      "Action": [
        "ec2:AttachVolume",
        "ec2:CreateVolume",
        "ec2:DeleteVolume",
        "ec2:CreateKeypair",
        "ec2:DeleteKeypair",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:CreateImage",
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:StopInstances",
        "ec2:DescribeVolumes",
        "ec2:DetachVolume",
        "ec2:DescribeInstances",
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:DescribeSnapshots",
        "ec2:DescribeImages",
        "ec2:RegisterImage",
        "ec2:CreateTags",
        "ec2:ModifyImageAttribute",
		"ec2:RequestSpotInstances",
		"ec2:CancelSpotInstanceRequests",
		"ec2:DescribeSpotInstanceRequests",
		"ec2:DescribeSpotPriceHistory",
		"iam:PassRole"
      ],
      "Condition": {
  		"IpAddress": {
            "aws:SourceIp": ["{vpn ip address}"]
  		}
      },
      "Resource": [
        "*"
      ]
    }
  ]
}
```
 
 * Create a deployment IAM Role for our purpose we will call it "Build-User"
 	* attach packer policy
 
* Setup AWS credentials
    Set-AWSCredentials -AccessKey {iam access key} -SecretKey {iam secret} -StoreAs {iam name}
 	* Add environment variable called *"AWS_ACCESS_KEY_ID"* with deployment user's access key
	* Add environment variable called *"AWS_SECRET_ACCESS_KEY"* with deployment user's secret key
 
 * Security group USE1-SG-B01-Packer Only
    * Inbound 
        * RDP               TCP 3389    sg-8e7060f6 (USE1-SG-B01-VPN)
        * Custom TCP Rule   TCP 5985    sg-8e7060f6 (USE1-SG-B01-VPN)
        * Custom TCP Rule   TCP 5986    sg-8e7060f6 (USE1-SG-B01-VPN)
    * Outbound
        * HTTP              TCP 80      0.0.0.0/0
        * HTTPS             TCP 443     0.0.0.0/0
 
 ## Tools
 