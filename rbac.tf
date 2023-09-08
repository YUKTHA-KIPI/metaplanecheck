
resource "snowflake_role_grants" "grant-check" {
  role_name = "IMPORTCHECK"
  roles = [
    "DEV_READ"
    
  ]
}
resource "snowflake_schema_grant" "name" {
  database_name = "MONITOR_DB"
  schema_name="GRANT_CHECK"
  privilege = "USAGE"
  roles=["IMPORTCHECK",
  "DEV_READ"] 
}

resource "snowflake_schema_grant" "name1" {
  database_name = "NEW"
  schema_name="PUBLIC"
  privilege = "USAGE"
  roles=["IMPORTCHECK",
  "DEV_READ",
  "PROD_DS_RO"] 
}


resource "snowflake_table_grant" "checktable" {
  database_name = "MONITOR_DB"
  schema_name="COMPUTE_CREDIT_MONITOR_SCHEMA"
  privilege = "SELECT"
  table_name = "CHECKING"
  roles=["IMPORTCHECK"]
}

resource "snowflake_table_grant" "checktable1" {
  database_name = "MONITOR_DB"
  schema_name="COMPUTE_CREDIT_MONITOR_SCHEMA"
  privilege = "SELECT"
  roles=["DEV_DS_RO"]
  on_future=true
}

resource "snowflake_table_grant" "checktable2" {
  database_name = "MONITOR_DB"
  schema_name="COMPUTE_CREDIT_MONITOR_SCHEMA"
  privilege = "SELECT"
  roles=["DEV_DS_RO"]
  on_all=true
}



//DEV ROLES
resource "snowflake_role" "AMBYINT_DEV_READ_role" {
  name    = "AMBYINT_DEV_READ"
  comment = "For Ambyint DEV Read"
}

resource "snowflake_role" "DEV_READ_role" {
  name    = "DEV_READ"
}

resource "snowflake_role_grants" "grant-dev-access-role" {
  role_name = snowflake_role.DEV_READ_role.name

  roles = [
    snowflake_role.AMBYINT_DEV_READ_role.name
  ]
}

resource "snowflake_role_grants" "grant-dev-func-role" {
  role_name = snowflake_role.AMBYINT_DEV_READ_role.name

  roles = [
    "SYSADMIN"
  ]

  users = ["TERRAFORM"
  ]
}

resource "snowflake_role" "DEV_AMBYINT_DS_SERVICE_role" {
  name    = "DEV_AMBYINT_DS_SERVICE"
  comment = "For Ambyint DS Service DEV Read"
}

resource "snowflake_role_grants" "grant-dev-ds-role" {
  role_name = snowflake_role.DEV_AMBYINT_DS_SERVICE_role.name

  roles = [
    "SYSADMIN"
  ]

  users = ["TERRAFORM"
  ]
}

resource "snowflake_role" "DEV_DS_RO_role" {
  name    = "DEV_DS_RO"
}

resource "snowflake_role_grants" "grant-dev-ds-ro" {
  role_name = snowflake_role.DEV_DS_RO_role.name

  roles = [
    snowflake_role.DEV_AMBYINT_DS_SERVICE_role.name
  ]
}


resource "snowflake_role" "DEV_DS_WRITE_role" {
  name    = "DEV_DS_WRITE"
}

resource "snowflake_role_grants" "grant-dev-ds-rw" {
  role_name = snowflake_role.DEV_DS_WRITE_role.name

  roles = [
    snowflake_role.DEV_AMBYINT_DS_SERVICE_role.name
  ]
}




resource "snowflake_role" "AMBYINT_QA_READ_role" {
  name    = "AMBYINT_QA_READ"
  comment = "For Ambyint QA Read"
}

resource "snowflake_role" "AMBYINT_PROD_READ_role" {
  name    = "AMBYINT_PROD_READ"
  comment = "For Ambyint PROD Read"
}




resource "snowflake_role" "QA_READ_role" {
  name    = "QA_READ"
}

resource "snowflake_role" "PROD_READ_role" {
  name    = "PROD_READ"
}




resource "snowflake_role_grants" "grant-qa-access-role" {
  role_name = snowflake_role.QA_READ_role.name

  roles = [snowflake_role.AMBYINT_QA_READ_role.name
  ]
}

resource "snowflake_role_grants" "grant-prod-access-role" {
  role_name = snowflake_role.PROD_READ_role.name

  roles = [
    snowflake_role.AMBYINT_PROD_READ_role.name
  ]
}



resource "snowflake_role_grants" "grant-qa-func-role" {
  role_name = snowflake_role.AMBYINT_QA_READ_role.name

  roles = [
    "SYSADMIN"
  ]

  users = ["TERRAFORM"
  ]
}


resource "snowflake_role_grants" "grant-prod-func-role" {
  role_name = snowflake_role.AMBYINT_PROD_READ_role.name

  roles = [
    "SYSADMIN"
  ]

  users = ["TERRAFORM"
  ]
}




resource "snowflake_role" "QA_AMBYINT_DS_SERVICE_role" {
  name    = "QA_AMBYINT_DS_SERVICE"
  comment = "For Ambyint DS Service QA Read"
}
resource "snowflake_role_grants" "grant-qa-ds-role" {
  role_name = snowflake_role.QA_AMBYINT_DS_SERVICE_role.name

  roles = [
    "SYSADMIN"
  ]

  users = ["TERRAFORM"
  ]
}

resource "snowflake_role" "PROD_AMBYINT_DS_SERVICE_role" {
  name    = "PROD_AMBYINT_DS_SERVICE"
  comment = "For Ambyint DS Service PROD Read"
}
resource "snowflake_role_grants" "grant-prod-ds-role" {
  role_name = snowflake_role.PROD_AMBYINT_DS_SERVICE_role.name

  roles = [
    "SYSADMIN"
  ]

  users = ["TERRAFORM"
  ]
}





resource "snowflake_role" "QA_DS_RO_role" {
  name    = "QA_DS_RO"
}
resource "snowflake_role_grants" "grant-qa-ds-ro" {
  role_name = snowflake_role.QA_DS_RO_role.name

  roles = [
    snowflake_role.QA_AMBYINT_DS_SERVICE_role.name
  ]

}


resource "snowflake_role" "QA_DS_WRITE_role" {
  name    = "QA_DS_WRITE"
}
resource "snowflake_role_grants" "grant-qa-ds-rw" {
  role_name = snowflake_role.QA_DS_WRITE_role.name

  roles = [
    snowflake_role.QA_AMBYINT_DS_SERVICE_role.name
  ]
}

resource "snowflake_role" "PROD_DS_RO_role" {
  name    = "PROD_DS_RO"
}
resource "snowflake_role_grants" "grant-prod-ds-ro" {
  role_name = snowflake_role.PROD_DS_RO_role.name

  roles = [
    snowflake_role.PROD_AMBYINT_DS_SERVICE_role.name
  ]
}

resource "snowflake_role" "PROD_DS_WRITE_role" {
  name    = "PROD_DS_WRITE"
}
resource "snowflake_role_grants" "grant-prod-ds-rw" {
  role_name = snowflake_role.PROD_DS_WRITE_role.name

  roles = [
   snowflake_role.PROD_AMBYINT_DS_SERVICE_role.name
  ]
}

///alerts grants
/*
resource "snowflake_role_grants" "grants-alert-db-role" {
  role_name = "SNOWFLAKE.ALERT_VIEWER"

  roles = [
    "MONITOR_USER"
  ]
}
*/

resource "snowflake_grant_privileges_to_role" "g4" {
  role_name = "MONITOR_USER"
  on_account_object {
    object_type = "DATABASE ROLE"
    object_name = "SNOWFLAKE.ALERT_VIEWER"
  }
}

resource "snowflake_grant_privileges_to_role" "g3" {
  privileges = ["IMPORTED PRIVILEGES"]
  role_name  = snowflake_role.watchkeeper-admin-role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = "SNOWFLAKE"
  }
}