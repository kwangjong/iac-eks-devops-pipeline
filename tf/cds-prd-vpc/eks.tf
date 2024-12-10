resource "aws_eks_cluster" "eks_cluster" {
  name     = "cds-prd-eks"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnets["cds-prd-sbn-ap-pri-a"].id,
      aws_subnet.subnets["cds-prd-sbn-ap-pri-c"].id
    ]
  }

  tags = {
    Name = "cds-prd-eks"
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "cds-prd-eks-ng"
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = [
    aws_subnet.subnets["cds-prd-sbn-ap-pri-a"].id,
    aws_subnet.subnets["cds-prd-sbn-ap-pri-c"].id
  ]
  instance_types = ["t3.medium"]

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 0
  }

  tags = {
    Name = "cds-prd-eks-ng"
  }
}
