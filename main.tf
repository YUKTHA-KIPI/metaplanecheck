terraform {
  required_version = ">= 1.5.2"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.59.0"
    }
  }
}

provider "snowflake" {
  role = "ACCOUNTADMIN" 
  account = "wy30041.ap-southeast-3.aws" 
  private_key_path = "~/.ssh/snowflake_tf_snow_key.p8" 
  username = "tf-snow"

}
