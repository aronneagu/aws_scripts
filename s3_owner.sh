#!/bin/bash
# Will print buckets that don't have "owner" tag
if [ "$#" -eq 1 ]; then
    aws_profile=$1
elif [ -n "$AWS_DEFAULT_PROFILE" ]; then
    aws_profile="$AWS_DEFAULT_PROFILE"
elif [ -n "$AWS_PROFILE" ]; then
    aws_profile="$AWS_PROFILE"
else
    echo "Usage: $(basename "$0") <aws_profile>"
    exit 1
fi

tmpfile=$(mktemp "${TMPDIR:-/tmp/}$(basename "$0").XXXX")

for bucket in $(aws --profile "$aws_profile" s3 ls|tr -s '[:space:]'|cut -f3 -d" ")
do
  bucket_owner=''
  bucket_owner=$(aws --output text --profile "$aws_profile" s3api get-bucket-tagging --bucket "$bucket" --query "TagSet[?Key=='date_owner'].Value|[0]" 2>/dev/null)
  echo "$bucket $bucket_owner" >> "$tmpfile"
done
column -t "$tmpfile"
rm -f $"tmpfile"
