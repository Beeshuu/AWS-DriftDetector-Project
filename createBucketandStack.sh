STACK_NAME="DriftTestStack"
BUCKET_NAME="bee-drift-test-bucket-1"

cat > drift-template.json <<EOF
{
  "Resources": {
    "TestBucket": {
      "Type": "AWS::S3::Bucket",
      "Properties": {
        "BucketName": "$BUCKET_NAME",
        "VersioningConfiguration": {
          "Status": "Suspended"
        },
        "BucketEncryption": {
          "ServerSideEncryptionConfiguration": [
            {
              "ServerSideEncryptionByDefault": {
                "SSEAlgorithm": "AES256"
              }
            }
          ]
        }
      }
    }
  }
}
EOF

echo "Commencing the creation of the following stack: $STACK_NAME"
aws cloudformation create-stack \
  --stack-name $STACK_NAME \
  --template-body file://driftTemplate.json \
  --capabilities CAPABILITY_NAMED_IAM

echo "Waiting for stack creation to be completed"
aws cloudformation wait stack-create-complete --stack-name $STACK_NAME

echo "'$STACK_NAME' created successfully!"
aws cloudformation list-stack-resources --stack-name $STACK_NAME

echo "'$BUCKET_NAME' is ready for testing!"
