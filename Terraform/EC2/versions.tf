terraform {
    cloud{
      organization = "raj_aws"
        workspaces {
          name = "awstemplates"
        }
    }    
    required_providers {
      aws = {
        source = "hashicorp/aws"
        version = ">=5.56.1"
      }
    }
}