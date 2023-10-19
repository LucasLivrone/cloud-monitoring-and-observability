#!/bin/bash

ami_name="monitored-ami"

# Get the AMI ID by filtering on the name
ami_id=$(aws ec2 describe-images --filters "Name=name,Values=${ami_name}" --query 'Images[0].ImageId' --output text)

# Deregister the AMI using the retrieved AMI ID
aws ec2 deregister-image --image-id $ami_id