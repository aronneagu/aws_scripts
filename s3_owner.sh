#!/bin/bash
# Will print buckets that don't have "owner" tag
aws_profile=$1
for bucket in $(aws --profile $aws_profile s3 ls|tr -s [:space:]|cut -f3 -d" ")
do
  bucket_owner=''
  bucket_owner=$(aws --output text --profile $aws_profile s3api get-bucket-tagging --bucket $bucket --query "TagSet[?Key=='owner'].Value|[0]" 2>/dev/null)
  if [ -z "$bucket_owner" ]
    then
      echo $bucket
  fi
done
