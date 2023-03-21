/**
 https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.Enabling.html
 */

variable "name" {
  default = "RDSMonitoringRole"
}

variable "description" {
  default = "Allows RDS to manage CloudWatch Logs resources for Enhanced Monitoring on your behalf."
}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "MonitoringRDS"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  name               = var.name
  description        = var.description
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy" "enhanced_monitoring" {
  name = "AmazonRDSEnhancedMonitoringRole"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.enhanced_monitoring.arn
}

output "iam_role_arn" {
  value = aws_iam_role.this.arn
}
