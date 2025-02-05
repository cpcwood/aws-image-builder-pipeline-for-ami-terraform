# AWS Image Builder Pipeline for EC2 AMIs Using Terraform

Sample AWS infrastructure for the AWS Image Builder Pipeline outlined in my blog post:
[AWS Image Builder Pipeline for EC2 AMIs Using Terraform](https://cpcwood.com/blog/8-aws-image-builder-pipeline-for-ec2-amis-using-terraform)

## Dependencies

Install required dependencies:

- [bash](https://www.gnu.org/software/bash/)
  ([command-not-found](https://command-not-found.com/bash))
- [terraform v1.10.5](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  ([tfenv](https://github.com/tfutils/tfenv) can be useful)

## Setup

### AWS Credentials

Create an AWS IAM user with the relevant permissions for the Terraform setup (Image Builder, EC2,
VPC, etc) or use `AdministratorAccess` for quicker less secure setup.

Add the access keys for the IAM user to the `aws-image-builder-pipeline` AWS profile in the
credentials list on your machine:

```sh
sudo vim ~/.aws/credentials
```

```
[aws-image-builder-pipeline]
aws_access_key_id = <iam-user-access-key-id>
aws_secret_access_key = <iam-user-secret-key>
```

### Create the Infrastructure

Fork or clone the project and navigate to the project root directory.

**IMPORTANT:** While the infrastructure required for this sample project is relatively low cost
(short running EC2 instances), please remember to evaluate costs are acceptable and teardown project
afterwards.

Run deploy script:

```sh
./tasks deploy
```

The AWS Image Builder Pipeline will now run daily at 9am.

### Teardown the Infrastructure

Run destroy script:

```sh
./tasks destroy
```
