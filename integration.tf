resource "snowflake_email_notification_integration" "alert_email_int" {
  name    = "ALERT_NF"
  comment = "A notification integration for alerts"

  enabled   = true
  allowed_recipients = ["airflowcoursemarch@gmail.com"]
}



resource "snowflake_notification_integration" "aws_sns_int" {
  name    = "TASK_NF"
  comment = "A notification integration for aws sns"

  enabled   = true
  type      = "QUEUE"
  direction = "OUTBOUND"

  # AWS_SNS
  notification_provider = "AWS_SNS"
  aws_sns_topic_arn     = "arn:aws:sns:us-west-2:105767744673:SnowpipeTopic"
  aws_sns_role_arn      = "arn:aws:iam::105767744673:role/Snowflake_SNS_Role"
}


resource "snowflake_integration_grant" "alert-grant" {
  integration_name = snowflake_email_notification_integration.alert_email_int.name

  privilege = "ALL PRIVILEGES"
  roles     = ["MONITOR_ADMIN","TASK_MONITOR_ADMIN"]

  with_grant_option = false
}

resource "snowflake_account_grant" "execute-alert" {
    privilege="EXECUTE ALERT"
    roles=["MONITOR_ADMIN","TASK_MONITOR_ADMIN"
    ]
  
}

resource "snowflake_integration_grant" "aws-sns-grant" {
  integration_name = snowflake_notification_integration.aws_sns_int.name

  privilege = "ALL PRIVILEGES"
  roles     = ["DEV_READ","TASK_MONITOR_ADMIN"]

  with_grant_option = false
}