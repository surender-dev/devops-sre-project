terraform/
├── create-s3-bucket/
│   ├── main.tf
│   ├── providers.tf
│   └── outputs.tf
├── ec2/
│   ├── main.tf
│   ├── backend.tf
│   ├── variables.tf
│   └── outputs.tf
└── README.md



cd terraform/create-s3-bucket

aws configure
aws sts get-caller-identity

# s3 bucket creation 
terraform init
terraform plan -var="bucket_suffix=YOUR-UNIQUE-SUFFIX"
terraform apply -var="bucket_suffix=YOUR-UNIQUE-SUFFIX"

Replace YOUR-UNIQUE-SUFFIX with your own lowercase letters and numbers.

Check the output:
terraform output state_bucket_name

# ec2 instance creation 
cd ../ec2

terraform init

# to know the AMI-ID 
aws ssm get-parameters \
  --names /aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id \
  --query 'Parameters[0].Value' \
  --output text \
  --region us-west-2
  
terraform plan \
  -var="ami_id=YOUR-VALID-AMI-ID"

terraform apply \
  -var="ami_id=YOUR-VALID-AMI-ID"

