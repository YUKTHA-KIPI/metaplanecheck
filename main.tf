terraform {
  required_version = ">= 1.5.2"

  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "0.67.0"
    }
  }
}

provider "snowflake" {
  role = "ACCOUNTADMIN" 
  account = "bh52760.ap-northeast-3.aws" 
  private_key_path = ".github/workflows/snowflake_tf_snow_key.p8" 
  username = "tf-snow"

}
