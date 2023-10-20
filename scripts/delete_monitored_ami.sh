#!/bin/bash

ami_name="monitored-ami"

# Get the AMI ID by filtering on the name
ami_id=$(aws ec2 describe-images --filters "Name=name,Values=${ami_name}" --query 'Images[0].ImageId' --output text)

if [[ $ami_id == ami-* ]]; then
  # Deregister the AMI using the retrieved AMI ID
  if aws ec2 deregister-image --image-id $ami_id; then
    echo "Pre-existing AMI $ami_id deleted"
  else
    echo "Failed to delete AMI with ID: $ami_id"
  fi
else
  echo "No valid AMI ID found"
fi