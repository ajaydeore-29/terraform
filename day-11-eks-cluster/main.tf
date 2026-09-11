#default vpc used 

data "aws_vpc" "default" {
    default = true
}

#default subnet used

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]

    }
}

#eks role creation

resource "aws_iam_role" "cluster_role" {
  name = "cluster_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
      }]
  })

  tags = {
    tag-key = "cluster_role"
  }
}

#eks cluster policy to the role

resource "aws_iam_role_policy_attachment" "cluster_policy" {
    role = aws_iam_role.cluster_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

#node role creation


resource "aws_iam_role" "node_role" {
  name = "node_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
      }]
  })

  tags = {
    tag-key = "node_role"
  }
}

#node role policy attachment to the role 

resource "aws_iam_role_policy_attachment" "node_policies" {
    count = 3
    role = aws_iam_role.node_role.name

    policy_arn = element([
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ], count.index)
}

#Cluster creation

resource "aws_eks_cluster" "eks_cluster" {
    name = "eks_cluster"
    role_arn = aws_iam_role.cluster_role.arn 
    version = "1.36"
    vpc_config {
        subnet_ids = data.aws_subnets.default.ids
        
    }
    depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

#node group creation

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "node_group"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.default.ids
  instance_types = ["c7i-flex.large"]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }
  depends_on = [aws_iam_role_policy_attachment.node_policies]
}  
