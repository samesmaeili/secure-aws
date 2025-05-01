# AWS Secure Environment

Goal for this project is to create a secure cloud environment. 
I have created folders for each type of resource, for better organization and management.

From a networking perspective, following the network segmentation principles, I've created the public and private subnets, NAT gateway, internet gateway. Locking down each resource and turning on practical security configurations is a must.

For an EC2, I deployed it in a private subnet, to minimize it's attack surface. Additionally, I encrypted it's volume and configured it with a secure configuration using IMDSV2. Additonally, I've created and attached an IAM role to the instance that can be assumed to access the instance securely, instead of relying on SSH keys that can be misused/stolen and lead to overhead. The IAM role does have least privilege, meaning it only has permissions to access the EC2 instance using SSM.

The S3 bucket has been deployed with secure conifgurations such as block public access setting turned on (minimize attack surface), a bucket policy that denies access to the bucket unless the access is originating from the source account (leasr priviliege). Additional bucket policy requires SSL when communication occurs (provide security in-transit). Additional configurations for the bucket include server-access logging and server-side encryption. No other bucket policy permissions defined, which follows principle of least privilege. With these permissions in place, only the IAM role attached to the EC2 and users in the same AWS account with bucket permissions can interact with this bucket. 

The IAM role that the EC2 assumes has been granted read and write access to the bucket. This was done for easier management of permissions of this role specifically. Following principles of least-privilege, iam role only has ability to read and write, not delete.

A little out of scope for this project, but using OIDC to have Terraform comunicate with AWS is a beneficial security feature. This means that it is no longer necessary to have a dedicated IAM user to pass hard-coded credentials to Terraform. Instead, temporary credentials are automatically provided by AWS to Terraform Cloud, which is much more secure and reduces overhead.