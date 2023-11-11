
#Criando eventos no  Eventbridge
resource "aws_cloudwatch_event_rule" "start_schedule" {
  name        = "start_schedule"
  description = "Agendamento para 6 da manhã"
  schedule_expression = "cron(50 01 * * ? *)"

  event_pattern = <<PATTERN
{
  "source": ["aws.events"],
  "detail": {
    "eventName": ["manha_event"]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_rule" "stop_schedule" {
  name        = "stop_schedule"
  description = "Agendamento para 10 da noite"
  schedule_expression = "cron(45 01 * * ? *)"

  event_pattern = <<PATTERN
{
  "source": ["aws.events"],
  "detail": {
    "eventName": ["noite_event"]
  }
}
PATTERN
}



# Vinculando a regra no eventbridge com a função lambda como target

resource "aws_cloudwatch_event_target" "start_target" {
  rule      = aws_cloudwatch_event_rule.start_schedule.name
  target_id = "start_schedule"
  arn       = aws_lambda_function.Lambda_start.arn
}


resource "aws_cloudwatch_event_target" "stop_schedule" {
  rule      = aws_cloudwatch_event_rule.stop_schedule.name
  target_id = "stop_schedule"
  arn       = aws_lambda_function.Lambda_stop.arn
}