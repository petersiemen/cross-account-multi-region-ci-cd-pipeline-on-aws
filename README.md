# Cross-Account/Multi-Region CI/CD pipeline on AWS

##### Ready to used template of a multi-account multi-region ci/cd pipeline

* Clear separation of production and development by using independent accounts
* Effective use of a ci/cd pipeline in a shared services account for automatic git push based deployments into development and production    

## AWS multiple account structure

### master account
AWS Organization owner for **consolidated billing** and for **service control policies** to 
configure the available AWS services for every account in the organization.

I use the master account as the central account to configure IAM users.
From the master account IAM users can switch to the other AWS accounts (shared services, development, production)
into the appropriate IAM roles. 
> In order to achieve an even higher level of security one can *eject* the IAM users into yet 
> another AWS account. We keep the configuration of IAM users in the master account for simplicity for now. 
##### used services
* Organizations
* IAM

### shared services account 
##### used services 
* IAM
* CodeCommit 
* CodeBuild
* CodePipeline 
* S3 artifact store for CodeBuild and CodePipeline

### development account
##### used services 
* S3 bucket for static website hosting
* API Gateway 
* Lambda
* SES
* SNS

### production account
##### used services 
* S3 bucket for static website hosting
* API Gateway 
* Lambda
* SES
* SNS


### Getting Started
1. Install terraform and terragrunt
2. Create an AWS account (used as master account) and convert the account to an AWS organization
3. Create 3 additional accounts in your AWS Organization  
    * Shared Services Account
    * Development Account
    * Production Account
    
   Go with the default cross-account role settings (OrganizationAccountAccessRole created in sub-accounts to be
   assumed into from other accounts)
4. Create an IAM user in the master account, give him Administrator Access and enable programmatic access and
configure your AWS_PROFILE with the access credentials. 

    Let's say we call the master account homepage-master.
    The shared services account homepage-shared-services.
    The development account homepage-development.
    The production account homepage-production.
        
    ```bash
    cat .aws/credentials
    ....
    
    [homepage-master]
    aws_access_key_id = XXXXXXXXXXXXX
    aws_secret_access_key = YYYYYYYYYYYYYYYYY
    
    ```
    
    ```bash
    cat .aws/config
    ....
    
    [profile homepage-master]
    region = eu-central-1
    
    [profile homepage-shared-services]
    region = eu-central-1
    role_arn = arn:aws:iam::REPLACE_WITH_YOUR_SHARED_SERVICES_ACCOUNT_ID:role/OrganizationAccountAccessRole
    source_profile = homepage-master
    
    [profile homepage-development]
    region = eu-central-1
    role_arn = arn:aws:iam::REPLACE_WITH_YOUR_DEVELOPMENT_ACCOUNT_ID:role/OrganizationAccountAccessRole
    source_profile = homepage-master
    
    [profile homepage-production]
    region = eu-central-1
    role_arn = arn:aws:iam::REPLACE_WITH_YOUR_PRODUCTION_ACCOUNT_ID:role/OrganizationAccountAccessRole
    source_profile = homepage-master
    
    ```

    ```bash
    cat .bashrc
    ...
   
   alias terragrunt-homepage-master="AWS_PROFILE=homepage-master terragrunt"  
   ```

5. Init your personal **common.hcl**
    ```shell script
    cd ./envs
    cp common-example.hcl common.hcl
    ``` 
   And fill common.hcl with your personal Acccount-ids, email adresses, etc.

6. Import the created organization
    ```shell script
    cd ./envs/master/organization
    terragrunt-homepage-master import aws_organizations_organization.org xxxxx
    terragrunt import aws_organizations_account.shared-services xxxxx
    terragrunt import aws_organizations_account.development xxxxx
    terragrunt import aws_organizations_account.production xxxxx
    ```
7. Terragrunt the modules in the different accounts and environments, ... 