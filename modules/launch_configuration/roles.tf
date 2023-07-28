resource "aws_iam_instance_profile" "profile-ec2" {
  name  = "tecnofit-ec2-sistema-role"
  role = aws_iam_role.launch_configuration.name
}

resource "aws_iam_role" "launch_configuration" {
  name = "sistema_launch_configuration_role_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ssm_ec2_paramter_tf" {
  name        = "ssm_ec2_paramter_tf"
  path        = "/"
  
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "ssm:GetParameters"
            ],
            "Resource": [
                "arn:aws:kms:us-east-1:*:key/*",
                "arn:aws:ssm:us-east-1:*:parameter/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess", 
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",    
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  ])

  role       = aws_iam_role.launch_configuration.name
  policy_arn = each.value  
}

resource "aws_iam_role_policy_attachment" "ssm_ec2_paramter" {
  role       = aws_iam_role.launch_configuration.name
  policy_arn = aws_iam_policy.ssm_ec2_paramter_tf.arn
}