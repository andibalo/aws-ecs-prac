# ECS
resource "aws_ecs_cluster" "ecs" {
  name = "${var.app_name}-${var.environment}"
  tags = {
    Name = "${var.app_name}-${var.environment}-ecs-cluster"
  }

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.app_name}-${var.environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AWS managed policy for ECS task execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS TASK DEFINITION
resource "aws_ecs_task_definition" "fe" {

  container_definitions = jsonencode(
    [
      {

        environment = []
        essential   = true
        image       = "${data.terraform_remote_state.main.outputs.fe_ecr_repository_url}:${data.aws_ecr_image.latest_fe_image.image_tag}"
        mountPoints = []
        name        = "${var.app_name}-${var.environment}-frontend"
        portMappings = [
          {
            appProtocol   = "http"
            containerPort = 80
            hostPort      = 80
            name          = "${var.app_name}-${var.environment}-frontend-tcp"
            protocol      = "tcp"
          },
        ]
        systemControls = []
        volumesFrom    = []
      },
    ]
  )
  cpu                    = "1024"
  enable_fault_injection = false
  family                 = "${var.app_name}-${var.environment}-frontend"
  memory                 = "3072"
  network_mode           = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  tags = {
    Name = "${var.app_name}-${var.environment}-fe-task-def"
  }

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}

# ECS TASK DEFINITION
resource "aws_ecs_task_definition" "be" {

  container_definitions = jsonencode(
    [
      {

        environment = []
        essential   = true
        image       = "${data.terraform_remote_state.main.outputs.be_ecr_repository_url}:${data.aws_ecr_image.latest_be_image.image_tag}"
        mountPoints = []
        name        = "${var.app_name}-${var.environment}-backend"
        portMappings = [
          {
            appProtocol   = "http"
            containerPort = 80
            hostPort      = 80
            name          = "${var.app_name}-${var.environment}-backend-tcp"
            protocol      = "tcp"
          },
        ]
        systemControls = []
        volumesFrom    = []
      },
    ]
  )
  cpu                    = "1024"
  enable_fault_injection = false
  family                 = "${var.app_name}-${var.environment}-backend"
  memory                 = "3072"
  network_mode           = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  tags = {
    Name = "${var.app_name}-${var.environment}-be-task-def"
  }

  runtime_platform {
    cpu_architecture        = "X86_64"
    operating_system_family = "LINUX"
  }
}