resource "aws_ecs_task_definition" "backend" {
  family                   = "backend"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "512"  # Adjust based on your needs
  memory                   = "1024"  # Adjust based on your needs
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "269599744150.dkr.ecr.us-east-1.amazonaws.com/coding-challenge1-repo"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        },
      ],
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        },
      ],
    }
  ])
}

resource "aws_ecs_service" "backend_service" {
  name            = "backend-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    assign_public_ip = false  
    subnets          = [aws_subnet.ecs_private_subnet.id]
    security_groups  = [aws_security_group.backend_security_group.id]
  }

  depends_on = [
    aws_ecs_cluster.my_cluster,
    aws_ecs_task_definition.backend
  ]
}
