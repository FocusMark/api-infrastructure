product_name=$focusmark_productname

# Deploy certificates
certificates_template='auth-certificates.yaml'
certificates_stackname=$product_name-"$deployed_environment"-cf-auth-certificates

echo Deploying the $certificates_stackname stack into $deployed_environment
cfn-lint $certificates_template
aws cloudformation deploy \
    --template-file $certificates_template \
    --stack-name $certificates_stackname \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides \
        TargetEnvironment=$deployed_environment \
        ProductName=$product_name