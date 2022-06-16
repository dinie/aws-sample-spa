function configure_new_user()
{
     echo "No worries! Will guide you here"
     read -r -p "Enter aws_access_key_id of User:" aws_access_key_id
     read -r -p "Enter aws_secret_access_key of User:" aws_secret_access_key
     echo "Setting the User credentials using aws configure"
     aws configure set aws_access_key_id $aws_access_key_id
     aws configure set aws_secret_access_key $aws_secret_access_key
     echo "Done! Configured the IAM User"
     echo "Current configured User is"
     aws sts get-caller-identity
}


# ====== Script ====
unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
read -p "Have you ran \"aws configure\" command to configure IAM user type (yes/no):" is_user_present
if [ "$is_user_present" = "yes" ] ; then
     echo "Verify if below is the user you want to use for this session."
     aws sts get-caller-identity
     read -p "Do you want to change the IAM user? (yes/no): " change_user
     if [ "$change_user" = "yes" ] ; then
       echo "Changing the current user by configuring user again"
       configure_new_user
     else
       echo "Okay. Going with current user itself"
     fi
     echo "Cool! You can assume the IAM role then"
elif [ "$is_user_present" = "no" ] ; then
     echo "Then you need to first configure IAM User"
     configure_new_user
     echo "Cool! Now you can assume the IAM role"
else
     echo "Sorry! Entered option is neither yes or no. Kindly re-execute script with one of valid options (yes/no)."
     exit 1
fi

read -p "Enter IAM Role you want to assume: " role_arn
role_session_name='temp-session'
profile_name='temp-profile'

temp_role=$(aws sts assume-role \
     --role-arn $role_arn \
     --role-session-name $role_session_name)

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq -r .Credentials.AccessKeyId)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq -r .Credentials.SecretAccessKey)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq -r .Credentials.SessionToken)

echo "Done! IAM role assumed successfully"
echo "Current Assume role is:"
aws sts get-caller-identity
echo "The End. Bye!!"
