resource "aws_sns_topic" "opsgenie_alerts" {
  name = "OpsGenie-Alerts"
}

resource "aws_sns_topic_subscription" "opsgenie_alerts" {
  topic_arn = aws_sns_topic.opsgenie_alerts.arn
  protocol  = "https"
  endpoint  = "https://api.opsgenie.com/v1/json/amazonsns?apiKey=6aced953-ff6c-425e-9597-9d409f33c1a6"
}

resource "aws_sns_topic" "opsgenie_alerts_p2" {
  name = "OpsGenie-Alerts-P2"
}

resource "aws_sns_topic_subscription" "opsgenie_alerts_p2" {
  topic_arn = aws_sns_topic.opsgenie_alerts_p2.arn
  protocol  = "https"
  endpoint  = "https://api.opsgenie.com/v1/json/amazonsns?apiKey=b6a22655-cec9-4e79-b230-9a2a97856584"
}

resource "aws_sns_topic" "opsgenie_alerts_p3" {
  name = "OpsGenie-Alerts-P3"
}

resource "aws_sns_topic_subscription" "opsgenie_alerts_p3" {
  topic_arn = aws_sns_topic.opsgenie_alerts_p3.arn
  protocol  = "https"
  endpoint  = "https://api.opsgenie.com/v1/json/amazonsns?apiKey=1b51de42-009c-4b15-a32b-1301b5ba66b6"
}

resource "aws_sns_topic" "opsgenie_alerts_p4" {
  name = "OpsGenie-Alerts-P4"
}

resource "aws_sns_topic_subscription" "opsgenie_alerts_p4" {
  topic_arn = aws_sns_topic.opsgenie_alerts_p4.arn
  protocol  = "https"
  endpoint  = "https://api.opsgenie.com/v1/json/amazonsns?apiKey=ca8d5280-daa9-4bbf-bfae-bfc7834f131e"
}

resource "aws_sns_topic" "opsgenie_alerts_p5" {
  name = "OpsGenie-Alerts-P5"
}

resource "aws_sns_topic_subscription" "opsgenie_alerts_p5" {
  topic_arn = aws_sns_topic.opsgenie_alerts_p5.arn
  protocol  = "https"
  endpoint  = "https://api.opsgenie.com/v1/json/amazonsns?apiKey=cb3bf423-82a1-4b08-9cf0-8c76edf96832"
}
