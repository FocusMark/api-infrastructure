The FocusMark API Infrastructure repository contains all of the core AWS CloudFormation templates used to deploy the supporting resources that the FocusMark platform depends on. These resources are specific to the RESTful API services that are consumed by each repository starting in `api-`.

The repository consists of bash scripts and CloudFormation templates. It has been built and tested in a Linux environment. There should be very little work needed to deploy from macOS; deploying from Windows is not supported at this time but could be done with a little effort.

# Deploy

## Requirements

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv1.html)

## Environment Variables
In order to run the deployment script you must have your environment set up with a few environment variables. The following table outlines the environment variables required with example values.

| Key                  | Value Type | Description | Examples                                           |
|----------------------|------------|-------------|----------------------------------------------------|
| deployed_environment | string     | The name of the environment you are deploying into | dev or prod |
| focusmark_productname | string | The name of the product. You _must_ use the name of a Domain that you own. | SuperTodo |


In Linux or macOS environments you can set this in your `.bash_profile` file.

```
export deployed_environment=dev
export focusmark_productname=supertodo

PATH=$PATH:$HOME/.local/bin:$HOME/bin
```

once your `.bash_profile` is set you can refresh the environment

```
$ source ~/.bash_profile
```

The `deployed_environment` and `focusmark_productname` environment variables will be used in all of the names of the resources provisioned during deployment. Using the `prod` environment and `supertodo` as the product name for example, the Amazon Certificate created to bind with the API Gateway Custom Domain will be created as `supertodo-prod-certificate-api`.

## Infrastructure

The infrastructure in this repository consists of the following:

- API Gateway Custom Domain for APIs
- Certificate issued from AWS ACM that is bound to the API Gateway Custom Domain
- Route 53 A record created to build the api.mydomain.com subdomain.

![Resources](/docs/api-infrastructure-resources.jpeg)

## Deployment

In order to deploy the infrastructure you just need to execute the bash script included in the root directory from a terminal:

```
$ sh deploy.sh
```

This will kick off the CloudFormation process and deploy each of the templates in this repository as their own CloudFormation Stack. The templates assumes that you have a domain matching the `focusmark_productname` value defined in your environment variables with a TLD of `.app`. It also assumes that you have deployed the [AWS Infrastructure](https://github.com/focusmark/aws-infrastructure) repository to provision a Route 53 Hosted Zone with an output matching `{focusmark_productname}-route53-dotappzone`.

The following diagram shows the deployment order of each CloudFormation Template Stack.

![Deployment](/docs/api-infrastructure-deployment.jpeg)

## Usage
This repository does not deploy anything that is immediately usable outside of other CloudFormation templates. Things like SubDomains and Certificates are consumed by other repositories, such as the [API Project](https://github.com/focusmark/api-project) repository. 