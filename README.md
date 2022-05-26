# aws-sample-spa
Contains any base tooling required to run Sceptre, the Cloudformation wrangling tool

## CI/CD Setup

The CI/CD in this project is dependent on the OIDC-hardened IAM Role created in [this repo](https://github.com/dinie/aws-oidc-gh-actions/). The process is:

1. Assume the OIDC-hardened IAM Role
2. Sceptre Run _base_: Use this role to provision another Sceptre IAM Role specific to this infrastructure stack
3. Sceptre Run _sample-app_: Use this newly created Sceptre IAM Role to provision the infrastructure stack required for the SPA (S3, Cloudfront, etc).

# Cloudformation Diagrams

The `cfn-diagram` node package, along with the [draw-io-export action](https://github.com/marketplace/actions/draw-io-export-action) is used to document these as infrastructure diagrams.

### Single Page App Architecture
![Application VPC Infrastructure Diagram](drawio-assets/export/s3_cloudfront-Diagram.png)

