resource "aws_iam_role" "lambda_role" {
  name = "Lambda_stop"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}



resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_lambda_function" "Lambda_stop" {
  function_name = "stop_bytag_lab02"
  runtime = "python3.8"
  handler = "stop_function.lambda_handler"
  role =  aws_iam_role.lambda_role.arn
  timeout = 10

  filename = "stop_function.zip"
}



resource "aws_lambda_function" "Lambda_start" {
  function_name = "start_bytag_lab02"
  runtime = "python3.8"
  handler = "start_function.lambda_handler"
  role =  aws_iam_role.lambda_role.arn
  timeout = 10

  filename = "start_function.zip"
}