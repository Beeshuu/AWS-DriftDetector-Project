import json
import boto3
import time
import os

cloudformation = boto3.client("cloudformation")
sns = boto3.client("sns")
SNS_TOPIC_ARN = os.environ["SNS_TOPIC_ARN"]

def lambda_entrypoint(event, context):
    stacks = cloudformation.list_stacks(
        StackStatusFilter=["CREATE_COMPLETE", "UPDATE_COMPLETE"]
    )["StackSummaries"]

    drifted_stacks = []

    for stack in stacks:
        stack_name = stack["StackName"]
        print(f"Checking drift for: {stack_name}")
        resp = cloudformation.detect_stack_drift(StackName=stack_name)
        drift_id = resp["StackDriftDetectionId"]

        while True:
            time.sleep(5)
            status_resp = cloudformation.describe_stack_drift_detection_status(
                StackDriftDetectionId=drift_id
            )
            detection_status = status_resp["DetectionStatus"]
            print(f"{stack_name}: Detection status = {detection_status}")

            if detection_status != "DETECTION_IN_PROGRESS":
                break

        drift_status = status_resp.get("StackDriftStatus", "UNKNOWN")
        print(f"{stack_name}: Drift status = {drift_status}")

        if drift_status == "DRIFTED":
            drifted_stacks.append(stack_name)

    if drifted_stacks:
        message = f"Drift detected in stacks: {', '.join(drifted_stacks)}"
    else:
        message = "No drift detected."

    print(message)
    sns.publish(
        TopicArn=SNS_TOPIC_ARN,
        Message=message,
        Subject="Drift Detection Result"
    )

    return {"statusCode": 200, "body": json.dumps(message)}

