variable "master_account_email" {}

resource "aws_budgets_budget" "cost" {
  name = "overall-cost-cap"
  budget_type = "COST"
  limit_amount = "20"
  limit_unit = "USD"
  time_unit = "MONTHLY"
  time_period_start = "2020-04-01_12:00"

  notification {
    comparison_operator = "GREATER_THAN"
    threshold = 80
    threshold_type = "PERCENTAGE"
    notification_type = "FORECASTED"
    subscriber_email_addresses = [
      var.master_account_email]
  }
}

//
//resource "aws_budgets_budget" "kinesis-usage" {
//  name = "kinesis-usage"
//  budget_type = "USAGE"
//  limit_amount = "10"
//  limit_unit = "ShardHour"
//  time_unit = "MONTHLY"
//  time_period_start = "2020-04-01_12:00"
//  cost_filters = {
//    "UsageType:Kinesis" = "EUW1-Storage-ShardHour (ShardHour)"  #TODO this does not work properly ... figure out how to configure this
//  }
//
//  notification {
//    comparison_operator = "GREATER_THAN"
//    threshold = 80
//    threshold_type = "PERCENTAGE"
//    notification_type = "FORECASTED"
//    subscriber_email_addresses = [
//      var.master_account_email]
//  }
//}
//
