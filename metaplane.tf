

resource "snowflake_role" "metaplane-role" {
    name = "METAPLANE_ROLE"
}

resource "snowflake_warehouse" "metaplane-obs-wh" {
    name           = "METAPLANE_WH"
    warehouse_size = "XSMALL"
    warehouse_type = "STANDARD" 
    auto_suspend = 5
    auto_resume = true
    initially_suspended = true
    max_concurrency_level = 30
    statement_timeout_in_seconds = 300
    statement_queued_timeout_in_seconds = 1200
}


resource "snowflake_user" "metaplane-user" {
    name         = "METAPLANE_USER"
    login_name   = "METAPLANE_USER"
    comment      = "A user for data observability tool metaplane"
    password     = "Meta123plane@"
    default_warehouse       = "METAPLANE_WH"
    default_role            = "METAPLANE_ROLE"
}

resource "snowflake_role_grants" "grant-to-metaplane-role" {
    role_name = snowflake_role.metaplane-role.name

    roles = [
        "SYSADMIN"
    ]

    users = [
        snowflake_user.metaplane-user.name
    ] 
}


resource "snowflake_warehouse_grant" "grant-to-metaplane-wh" {
  warehouse_name = "METAPLANE_WH"
  privilege      = "usage"

  roles = [snowflake_role.metaplane-role.name]
}

resource "snowflake_database_grant" "grant-imported-privileges-snowflake-db" {
    database_name = "SNOWFLAKE"
    privilege     = "IMPORTED PRIVILEGES"
    roles = [
     snowflake_role.metaplane-role.name
    ]
}


resource "snowflake_database_grant" "db-grant-prod" {
  database_name = "MONITOR_DB"

  privilege = "USAGE"
  roles     = [snowflake_role.metaplane-role.name]
}

resource "snowflake_database_grant" "db-grant-qa" {
  database_name = "TF_DEMO"

  privilege = "USAGE"
  roles     = [snowflake_role.metaplane-role.name]
}



data "snowflake_schemas" "sc1" {
  database = "MONITOR_DB"
}

locals {
   schema_prod = toset([
  for schema in data.snowflake_schemas.sc1 :
  schema.name
  if (schema.name!="INFORMATION_SCHEMA")
  ])
}
resource "snowflake_schema_grant" "sc_grant" {
  for_each      = local.schema_prod
  database_name = "PROD"
  schema_name   = each.value

  privilege = "USAGE"

  roles  = [snowflake_role.metaplane-role.name]

  depends_on = [
    data.snowflake_schemas.sc1
  ]
}