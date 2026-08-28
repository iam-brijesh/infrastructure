resource "aws_ecr_repository" "ms1" {
  name                 = "ms-1"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Service     = "ms-1"
    Environment = "practice"
  }
}

resource "aws_ecr_repository" "ms2" {
  name                 = "ms-2"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Service     = "ms-2"
    Environment = "practice"
  }
}

resource "aws_ecr_repository" "ms3" {
  name                 = "ms-3"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Service     = "ms-3"
    Environment = "practice"
  }
}
