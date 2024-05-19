resource "aws_cloudwatch_dashboard" "cloudwatch_dashboard" {
  dashboard_name = var.cloudwatch_dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "CPUUtilization",
              "InstanceId",
              aws_instance.ec2-server.id
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "Instance CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 13
        y      = 0
        width  = 12
        height = 6

        properties = {
          metrics = [
            [
              "AWS/EC2",
              "NetworkIn",
              "InstanceId",
              aws_instance.ec2-server.id
            ],
            [
              "AWS/EC2",
              "NetworkOut",
              "InstanceId",
              aws_instance.ec2-server.id
            ]
          ]
          period = 300
          stat   = "Average"
          region = var.region
          title  = "Instance Network In Out traffic"
        }
      }

    ]
  })
}
