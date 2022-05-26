#!/bin/bash
# Useful script for developers who wish to test out assumable IAM roles
# Intended for local use only

unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

read -p "Enter IAM Role you want to assume: " role_arn
role_session_name='temp-session'
profile_name='temp-profile'

temp_role=$(aws sts assume-role \
     --role-arn $role_arn \
     --role-session-name $role_session_name)

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

# Print it to use as bash export on another terminal
printf "export AWS_ACCESS_KEY_ID=\"%s\"\\n" $AWS_ACCESS_KEY_ID;\
printf "export AWS_SECRET_ACCESS_KEY=\"%s\"\\n" $AWS_SECRET_ACCESS_KEY;\
printf "export AWS_SESSION_TOKEN=\"%s\"\\n\\n\\n" $AWS_SESSION_TOKEN;

echo "Done! IAM role assumed successfully"
echo "Current Assume role is:"
aws sts get-caller-identity
echo "The End. Bye!!"
