## Summary

Following terraform code will create two s3 buckets. One of them is for internal users usage and other one will be used by external users.

  

Next we will create 3 users - one as a representation of internal users, one for external user and Josh who will be treated like a separate user to demonstrate different ways of attaching policies.

  

External user will be allowed to assume role based on externalID. There is a possibility to create multiple users by adding `aws_iam_user` blocks or `count` and then managing their group membership.

  

Individual user, Josh and external user permissions can be adjusted as needed by changing values in `aws_iam_policy_document` data source or directly in provided policy.json files used for Josh in template file.

To introduce more flexibility code will also create groups and attach users to them. This can be further improved to introduce even more control over individual users and their policies.

  

ExternalID and other "confidential" variables could be consumed from AWS Secrets Manager or using Vault. In our case for simplicity we will be using `secrets.tfvars` file which can be used during `apply` - `terraform apply -var-file="secret.tfvars"`. If the file is not provided Terraform will ask for input variables during apply.

## Remote backend

Code supports using s3 as Terraform backend. This backend also supports state locking and consistency checking via Dynamo DB. This is to allow safe development process in case multiple users would be using this code at the same time.

Additionally using `environment` variable appended to resources and supplying it according to the environment could be one of the approaches for environment separation. Another possibility is to utilize `terraform workspaces`.

# module
More flexibility can be achieved by transforming this code into a module and changing static values into variables. 
