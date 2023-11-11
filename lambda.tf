

# Role para a função lambda
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




# Permissoes entre Eventbridge e o Lambda
resource "aws_lambda_permission" "permissao_eventbridge_start" {
  statement_id  = "AllowExecutionFromEventBridge_manha"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda_start.function_name
  principal     = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.start_schedule.arn
}



resource "aws_lambda_permission" "permissao_eventbridge_stop" {
  statement_id  = "AllowExecutionFromEventBridge_manha"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.Lambda_stop.function_name
  principal     = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.stop_schedule.arn
}

# Adicionando permissao para a funcao lambda iniciar e desligar as maquinas 
resource "aws_iam_role_policy_attachment" "lambda_role_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}




#Funcoes lambda para iniciar e parar as maquinas Ec2
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

