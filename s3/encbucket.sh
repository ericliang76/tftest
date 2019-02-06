#!/bin/bash
BUCKET=lianger-dev-store
aws s3api create-bucket --bucket ${BUCKET} --region us-east-1 #--create-bucket-configuration LocationConstraint=us-east-1
aws s3api put-bucket-encryption --bucket ${BUCKET} --server-side-encryption-configuration={\"Rules\":[{\"ApplyServerSideEncryptionByDefault\":{\"SSEAlgorithm\":\"AES256\"}}]}
    
aws iam create-user --user-name terraform-deployer
aws iam attach-user-policy --policy-arn arn:aws:iam::aws:policy/AmazonS3FullAccess --user-name terraform-deployer
ARNID=`aws iam get-user --user-name terraform-deployer | grep Arn| cut -f4 -d"\""`
cat <<-EOF >> policy.json
{
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "AWS": "${ARNID}"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::${BUCKET}"
        }
    ]
}
EOF
    
aws s3api put-bucket-policy --bucket ${BUCKET} --policy file://policy.json
rm -f ./policy.json
aws s3api put-bucket-versioning --bucket ${BUCKET} --versioning-configuration Status=Enabled
    
mkdir tempdynamo
cd tempdynamo
cat <<-EOF >> main.tf
# create-dynamodb-lock-table.tf
resource "aws_dynamodb_table" "${BUCKET}-state-lock" {
  name           = "${BUCKET}-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5
attribute {
    name = "LockID"
    type = "S"
  }
tags {
    Name = "DynamoDB Terraform State Lock Table"
  }
}
EOF

terraform plan -out planfile ; terraform apply -input=false -auto-approve "planfile"
cd ..
rm -Rf tempdynamo
