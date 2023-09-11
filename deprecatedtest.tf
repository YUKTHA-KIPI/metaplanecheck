resource "snowflake_grant_privileges_to_role" "execute-task-devops-dev" {
  role_name         = snowflake_role.watchkeeper-admin-role.name
  privileges = ["EXECUTE TASK", "EXECUTE MANAGED TASK"]
  on_account        = true
}

resource "snowflake_grant_privileges_to_role" "execute-task-1" {
  role_name         = snowflake_role.watchkeeper-task-role.name
  privileges = ["EXECUTE TASK", "EXECUTE MANAGED TASK"]
  on_account        = true
}

resource "snowflake_grant_privileges_to_role" "g3" {
  privileges = ["IMPORTED PRIVILEGES"]
  role_name  = snowflake_role.watchkeeper-admin-role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = "SNOWFLAKE"
  }
}


resource "snowflake_grant_privileges_to_role" "g4" {
  privileges = ["IMPORTED PRIVILEGES"]
  role_name  = snowflake_role.watchkeeper-task-role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = "SNOWFLAKE"
  }
}