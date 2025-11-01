# AWS CloudFormation Drift Detector
This is a serverless AWS Lambda project that detects infrastructure drift across the AWS CloudFormation stacks and notifies you through SMS.

#AWS Services Used:
- AWS Lambda (used for executing drift detection logic via boto3)
- AWS CloudFormation (used for managing stacks and defining the expected resource states)
- AWS Simple Notification Service [SMS] (used to email alerts of drift detection status)
- AWS IAM (used to set up rules and permissions for Lambda)

#Key Features:
- Automation of detecting drifts in the system as long as the system is on, sending notifications once a day or however much time you choose to do.
- Intigrates with SMends an SMS email to you to notify if any drift is detected everyday.
- Executable script to simulate that the drift detection factor is working.
- Supports detection of multiple stacks.

#How the System Works 
First, the Lambda runs `cloudformation.detect_stack_drift()`.
Next, AWS performs a drift analysis on target stacks.
Then, results are checked, if there seems to be a drift, a SMS notification is sent out.
Then finally, scripts restore and makes sure that there is "No Drift."

#--------------------------------IMPORTANT DISCLAIMER---------------------------------#
SOME OF THE SCRIPTS WILL NOT WORK DUE TO THE NAMES NOT LINKING IT TO YOUR AWS ACCOUNT AND API SPECIFIC NAMES BEING TAKEN SO PLEASE CHANGE THE NAMES ACCORDINGLY. THERE WILL NOT BE A GUIDE FOR THIS.
#--------------------------------IMPORTANT SETUP GUIDE--------------------------------#

#Lambda Setup Guide
You have to open up the terminal and use bash for this, and install all the required packages. (git, aws, zip, boto3)

Now run the following bash command:

zip function.zip lambdaDriftFunction.py
aws lambda create-function \
  --function-name lambdaDriftDetectionFunction \
  --runtime python3.12 \
  --role arn:aws:iam::<YOUR_ACCOUNT_ID>:role/LambdaDriftDetectionRole \
  --handler lambdaDriftFunction.lambda_entrypoint \
  --zip-file fileb://function.zip \
  --environment "Variables={SNS_TOPIC_ARN=arn:aws:sns:<YOUR AWS REGION>:<YOUR_ACCOUNT_ID>:driftDetectorAlertsTopic}"

There, you have the lambda system deployed and running now. 
Key Notes to takeaway:
Please replace <YOUR AWS REGION> and <YOUR_ACCOUNT_ID> with well your credentials.

#Setting Up Test Run for Drift Check
Run the following bash commands:
chmod +x createBucketandStack.sh
chmod +x driftTestCycle.sh

THIS IS REALLY IMPOROTANT TO NOTE:
For executing the following commands, you must do it in this order otherwise it will not work:

./createBucketandStack.sh
./driftTestCycle.sh

And you got the test going.

#Deleting the bucket and stack
Run the following bash command:
aws cloudformation delete-stack --stack-name DriftTestStack

#Manually checking for drift in the system
Run the following bash commands:
aws lambda invoke \
--function-name DriftDetectorFunction \
--payload '{}' \
output.json

This manually creates a report of if any drift in the system is detected.
Then you run the following bash command:
cat output.json

You are manually able to read the report and you get an SMS report in your email.

#Automating SMS Notifications
Run the following bash commands:
chmod +x automationEventRule.sh
./automationEventRule.sh

And there, we got automation.
Side Note: You can go in the script and set the timer to however much time you like within the sleep command.
