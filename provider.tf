# provider "aws" {
#   # version = "~> 4.0"
#   region  = "us-west-1"
#     access_key = "XXXX"
#     secret_key = "XXXX"
# }

provider "aws" {
  shared_config_files      = ["~/.aws/config"]
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = "default"
}