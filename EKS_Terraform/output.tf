output "cluster_id" {
  value = aws_eks_cluster.saurav.id
}

output "node_group_id" {
  value = aws_eks_node_group.saurav.id
}

output "vpc_id" {
  value = aws_vpc.saurav_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.saurav_subnet[*].id
}
