STACK_NAME="DriftTestStack"
BUCKET_NAME="bee-drift-test-bucket-1"
LAMBDA_FUNCTION="lambdaDriftDetectionFunction"
OUTPUT_FILE="output.json"

echo "Commencing phase 1 of the Drift Test"
aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Enabled

echo "Waiting 10 seconds for changes to be implemented within AWS"
sleep 10

echo "Commencing phase 2 of the Drift Test"
echo "Running Lambda Drift Detection."

aws lambda invoke \
  --function-name $LAMBDA_FUNCTION \
  $OUTPUT_FILE > /dev/null

cat $OUTPUT_FILE
echo "Detection complete"
echo "Commencing original bucket configuration"

aws s3api put-bucket-versioning \
  --bucket $BUCKET_NAME \
  --versioning-configuration Status=Suspended

aws s3api put-bucket-encryption \
  --bucket $BUCKET_NAME \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
aws cloudformation delete-stack --stack-name $STACK_NAME
aws s3 rb s3://$BUCKET_NAME --force
echo "Waiting 10 seconds for changes to be implemented within AWS"
sleep 10

echo "Commencing the rerun of drift detection to see changes"
aws lambda invoke \
  --function-name $LAMBDA_FUNCTION \
  $OUTPUT_FILE > /dev/null

cat $OUTPUT_FILE

echo "This drift test cycle has been completed."
