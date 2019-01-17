#!/bin/bash
# TODO
# - add argument to output to table format
# - use default aws profile unless a different one is specified at command line
size=0
current_size=0
objects=0
current_objects=0
index=1
aws_profile=$1
total_number_of_buckets=$(aws --profile $aws_profile s3 ls|wc -l|sed 's/\ //g')
list_of_buckets=$(aws --profile $aws_profile s3 ls|cut -f3 -d" ")
echo "Bucket	Size		Number of objects"
for bucket in $list_of_buckets
  do 
     current_bucket=$(aws --profile $aws_profile s3 ls --recursive --summarize $bucket|grep -e 'Total Size' -e 'Total Objects')
     # Calculate the size of bucket
     current_size=$(echo "$current_bucket"|grep "Total Size"|tr -s [:space:]|cut -f2 -d":"|sed -e 's/\ //g')
     size=$((size+current_size))
     # Calculate number of objects per bucket
     current_objects=$(echo "$current_bucket"|grep "Total Objects"|tr -s [:space:]|cut -f2 -d":"|sed -e 's/\ //g')
     objects=$((objects+current_objects))
     echo -en "[${index}/${total_number_of_buckets}] $bucket \t"
     echo -en "$current_size \t"
     echo "$current_objects"
     ((index++))
done

echo "Total size: $size bytes"
echo "Total objects: $objects"
