resource "snowflake_user" "TEST-USER" {
  name         = "TEST"
  default_role = "SECURITYADMIN"
}