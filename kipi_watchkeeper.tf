//ROLE CREATION FOR watchkeeper

resource "snowflake_role" "watchkeeper-admin-role" {
    name = "MONITOR_ADMIN"
}

resource "snowflake_role" "watchkeeper-user-role" {
    name = "MONITOR_USER"
}

resource "snowflake_role" "watchkeeper-task-role" {
    name = "TASK_MONITOR_ADMIN"
}


//RM CREATION
resource "snowflake_resource_monitor" "watchkeeper-monitor" {
    name         = "MONITOR_WH_RM"
    credit_quota = 15

    frequency       = "MONTHLY"
    start_timestamp = "22-08-2023"

    notify_triggers           = [50,60]
    suspend_trigger           = 70
    suspend_immediate_trigger = 80

    notify_users = ["TERRAFORM"]
}


//WH CREATION
resource "snowflake_warehouse" "watchkeeper-wh" {
    name           = "MONITOR_WH"
    warehouse_size = "XSMALL"
    warehouse_type = "STANDARD" 
    auto_suspend = 60
    auto_resume = true
    initially_suspended = true
    //resource_monitor="MONITOR_WH_RM"
    max_concurrency_level = 30
    statement_timeout_in_seconds = 300
    statement_queued_timeout_in_seconds = 1200
    comment="for watchkeeper usage"
    //depends_on = [snowflake_resource_monitor.watchkeeper-monitor]
}

//DB CREATION
resource "snowflake_database" "watchkeeper-db" {
  name                        = "MONITOR_DB"
  comment                     = "Database for watchkeeper accelerator"
}

// SNOWFLAKE DB GRANTS
resource "snowflake_database_grant" "grant-imported-privileges-snowflake-WK" {
    database_name = "SNOWFLAKE"
    privilege     = "IMPORTED PRIVILEGES"
    roles = [
        snowflake_role.watchkeeper-admin-role.name,
        snowflake_role.watchkeeper-user-role.name,
        snowflake_role.watchkeeper-task-role.name
    ]
}


//TASK GRANT
resource "snowflake_account_grant" "acct-wk-grant1" {
  roles             = [snowflake_role.watchkeeper-admin-role.name,snowflake_role.watchkeeper-task-role.name]
  privilege         = "EXECUTE TASK"
}

//managed task grant
resource "snowflake_account_grant" "acct-wk-grant2" {
  roles             = [snowflake_role.watchkeeper-admin-role.name,snowflake_role.watchkeeper-task-role.name]
  privilege         = "EXECUTE MANAGED TASK"
}


/*
////////////////////////////////second push

//ADMIN ROLE GRANTS
resource "snowflake_role_grants" "grant-watchkeeper-admin" {
    role_name = snowflake_role.watchkeeper-admin-role.name

    roles = [
        "ACCOUNTADMIN"
    ] 
    users = ["TERRAFORM"]
}


//USER ROLE GRANTS
resource "snowflake_role_grants" "grant-watchkeeper-user" {
    role_name = snowflake_role.watchkeeper-user-role.name

    roles = [
       snowflake_role.watchkeeper-admin-role.name
    ]
    users=[
        "TERRAFORM"
    ]
}

//TASK ROLE GRANTS
resource "snowflake_role_grants" "grant-watchkeeper-taskadmin" {
    role_name = snowflake_role.watchkeeper-task-role.name

    roles = [
        "ACCOUNTADMIN"
    ] 
    users = ["TERRAFORM"]
}


//WH GRANTS
resource "snowflake_warehouse_grant" "grant-wk-wh1" {
  warehouse_name = "MONITOR_WH"
  privilege      = "usage"

  roles = [snowflake_role.watchkeeper-admin-role.name,
  snowflake_role.watchkeeper-user-role.name,
  snowflake_role.watchkeeper-task-role.name]
  //depends_on = [snowflake_database.watchkeeper-wh]
}

resource "snowflake_warehouse_grant" "grant-wk-wh2" {
  warehouse_name = "MONITOR_WH"
  privilege      = "monitor"

  roles = [snowflake_role.watchkeeper-admin-role.name,snowflake_role.watchkeeper-task-role.name]
  //depends_on = [snowflake_database.watchkeeper-wh]
}

resource "snowflake_warehouse_grant" "grant-wk-wh3" {
  warehouse_name = "MONITOR_WH"
  privilege      = "modify"

  roles = [snowflake_role.watchkeeper-admin-role.name,snowflake_role.watchkeeper-task-role.name]
  //depends_on = [snowflake_database.watchkeeper-wh]
}

resource "snowflake_warehouse_grant" "grant-wk-wh4" {
  warehouse_name = "MONITOR_WH"
  privilege      = "operate"

  roles = [snowflake_role.watchkeeper-admin-role.name,snowflake_role.watchkeeper-task-role.name]
  //depends_on = [snowflake_database.watchkeeper-wh]
}

//DB GRANTS

resource "snowflake_database_grant" "db-wk-grant1" {
  database_name = "MONITOR_DB"

  privilege = "ALL PRIVILEGES"
  roles     = [snowflake_role.watchkeeper-admin-role.name,snowflake_role.watchkeeper-task-role.name]
  //depends_on = [snowflake_database.watchkeeper-db]
}

resource "snowflake_database_grant" "db-wk-grant2" {
  database_name = "MONITOR_DB"

  privilege = "USAGE"
  roles     = [snowflake_role.watchkeeper-user-role.name]
  //depends_on = [snowflake_database.watchkeeper-db]
}




//future grant
resource "snowflake_schema_grant" "future-grant-schema-wk" {
    database_name = "MONITOR_DB"
    privilege = "USAGE"
    roles     = [snowflake_role.watchkeeper-user-role.name,snowflake_role.watchkeeper-task-role.name]
    on_future         = true
    //depends_on = [snowflake_database.watchkeeper-db]
}

resource "snowflake_table_grant" "future-grant-table-wk" {
    database_name = "MONITOR_DB"

    privilege = "SELECT"
    roles     = [snowflake_role.watchkeeper-user-role.name,snowflake_role.watchkeeper-task-role.name]
    on_future         = true
    //depends_on = [snowflake_database.watchkeeper-db]
}

resource "snowflake_view_grant" "future-grant-view-wk" {
    database_name = "MONITOR_DB"

    privilege = "SELECT"
    roles     = [snowflake_role.watchkeeper-user-role.name,snowflake_role.watchkeeper-task-role.name]
    on_future         = true
    //depends_on = [snowflake_database.watchkeeper-db]
}


/////////////////////third push
//schema creation
resource "snowflake_schema" "wk-schema1" {
  database = "MONITOR_DB"
  name     = "COMPUTE_CREDIT_MONITOR_SCHEMA"
  //depends_on = [snowflake_database.watchkeeper-db]
}

resource "snowflake_schema" "wk-schema2" {
  database = "MONITOR_DB"
  name     = "PERFORMANCE_MONITOR_SCHEMA"
  //depends_on = [snowflake_database.watchkeeper-db]
}

resource "snowflake_schema" "wk-schema3" {
  database = "MONITOR_DB"
  name     = "SECURITY_MONITOR_SCHEMA"
  //depends_on = [snowflake_database.watchkeeper-db]
}

resource "snowflake_schema" "wk-schema4" {
  database = "MONITOR_DB"
  name     = "TASK_MONITOR_SCHEMA"
  //depends_on = [snowflake_database.watchkeeper-db]
}

*/
