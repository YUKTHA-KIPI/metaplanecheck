terraform {
  required_version = ">= 1.5.2"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.70.1"
    }
  }
}

provider "snowflake" {
  role = "ACCOUNTADMIN" 
  account = "df84412.ap-south-1.aws" 
  private_key_path = ".github/workflows/snowflake_tf_snow_key.p8" 
  username = "tf-snow"

}
