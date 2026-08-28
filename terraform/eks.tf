module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.24.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access  = true
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = true

  # ============================================================
  # EKS ACCESS FOR GITHUB ACTIONS
  # ============================================================

  access_entries = {
    github_actions = {
      principal_arn = aws_iam_role.github_actions.arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  # ============================================================
  # NETWORKING
  # ============================================================

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # ============================================================
  # EKS ADD-ONS
  # IMPORTANT: CREATE BEFORE NODE GROUP
  # ============================================================

  addons = {

    vpc-cni = {
      most_recent    = true
      before_compute = true
    }

    kube-proxy = {
      most_recent    = true
      before_compute = true
    }

    coredns = {
      most_recent    = true
      before_compute = true
    }

    eks-pod-identity-agent = {
      most_recent    = true
      before_compute = true
    }
  }

  # ============================================================
  # MANAGED NODE GROUP
  # ============================================================

  eks_managed_node_groups = {
    default = {
      name = "main-ng"

      kubernetes_version = var.kubernetes_version

      # Free-Tier eligible for your account
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 2

      capacity_type = "ON_DEMAND"

      subnet_ids = module.vpc.private_subnets

      labels = {
        Environment = "practice"
      }
    }
  }

  # ============================================================
  # TAGS
  # ============================================================

  tags = {
    Environment = "practice"
    Project     = "hello-world"
  }
}
