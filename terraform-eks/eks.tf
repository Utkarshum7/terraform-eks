module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.1.5"

  name               = local.name
  kubernetes_version = "1.33"

  # Optional
  endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  # EKS Addons (use 'addons' not 'cluster_addons' in v21.x)
  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {
      before_compute = true
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    example = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t2.medium"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
      capacity_type = "SPOT"
    }
  }

  tags = {
    Environment = local.env
    Terraform   = "true"
  }
}
