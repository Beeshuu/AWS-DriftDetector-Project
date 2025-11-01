aws events put-rule \
  --name "DailyDriftCheck" \
  --schedule-expression "rate(1 day)" \
  --description "Triggers drift detection Lambda once per day"

echo "Waiting 5 seconds for the next part of the automation."
sleep 5

echo "Second part now initializing."

aws events put-targets \
  --rule "DailyDriftCheck" \
  --targets "Id"="1","Arn"="$(aws lambda get-function --function-name lambdaDriftDetectionFunction --query 'Configuration.FunctionArn' --output text)"

echo "Waiting 5 seconds for the next part of the automation."
sleep 5

echo "Final steps of automation now initializing."

aws lambda add-permission \
  --function-name lambdaDriftDetectionFunction \
  --statement-id EventBridgeInvoke \
  --action 'lambda:InvokeFunction' \
  --principal events.amazonaws.com \
  --source-arn "$(aws events describe-rule --name DailyDriftCheck --query 'Arn' --output text)"
echo "Automation is set up now."
