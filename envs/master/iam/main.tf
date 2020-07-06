resource "aws_iam_group" "admin" {
  name = "admin"
  path = "/terraform/users/"
}

resource "aws_iam_group_membership" "admins" {
  name = "admin-membership"

  users = [
    aws_iam_user.peter.name
  ]

  group = aws_iam_group.admin.name
}

resource "aws_iam_group_policy_attachment" "admin-group-policy" {
  group = aws_iam_group.admin.id
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_group_policy_attachment" "admin-group-billing-policy" {
  group = aws_iam_group.admin.id
  policy_arn = "arn:aws:iam::aws:policy/job-function/Billing"
}


//resource "aws_iam_policy" "billing-full-access" {
//  name = "BillingFullAccess"
//  policy = <<EOF
//{
//    "Version": "2012-10-17",
//    "Statement": [
//        {
//            "Effect": "Allow",
//            "Action": "aws-portal:*",
//            "Resource": "*"
//        }
//    ]
//}
//EOF
//}
//
//resource "aws_iam_group_policy_attachment" "admin-group-billing-policy" {
//  group = aws_iam_group.admin.id
//  policy_arn = aws_iam_policy.billing-full-access.arn
//}


resource "aws_iam_policy" "admin-assume-role" {
  name = "admin-assume-role"
  path = "/terraform/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::${var.shared_services_account_id}:role/OrganizationAccountAccessRole"
        },
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::${var.development_account_id}:role/OrganizationAccountAccessRole"
        },
        {
            "Action": "sts:AssumeRole",
            "Effect": "Allow",
            "Resource": "arn:aws:iam::${var.production_account_id}:role/OrganizationAccountAccessRole"
        }
    ]
}
EOF
}

resource "aws_iam_group_policy_attachment" "admins-group-policy" {
  group = aws_iam_group.admin.id
  policy_arn = aws_iam_policy.admin-assume-role.arn
}
