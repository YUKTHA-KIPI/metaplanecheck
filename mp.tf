resource "snowflake_role" "metaplane-role" {
    name = "METAPLANE_ROLE"
}


//dedicated wh for metaplane
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
    password     = "Meta123@plane"//var.default_user_pwd
    default_warehouse       = "METAPLANE_WH"
    default_role            = "METAPLANE_ROLE"
}
