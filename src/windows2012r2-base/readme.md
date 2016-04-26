  
 # Windows 2012 R2 Base
 
 A Packer template to create a base image for all other images. 
 It is based off the latest AWS Windows 2012 R2 AMI.
 
 ## What it is doing
 
 An EBS-Backed EC2 instance will be created and bootstrapped for provisioning. 
 
  1. Packer spins up a spot instance
  2. Tools, configuration files and Automation Powershell Modules are uploaded to instance
  3. Automation Powershell Modules are added to PSModulePath Environment Variable
  4. Install chocolately & Boxstarter
  5. Configure instance and install needed packages
  6. Clean-up unneccessary files
  7. Ec2Config service is reconfigured before shutdown
  8. AMI is created from instance
	 
