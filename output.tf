output "db_instance_address" {
  value = aws_db_instance.default.address
}
output "db_instance_port" {
  value = aws_db_instance.default.port
}
output "mq_instance_console_url" {
  value = aws_mq_broker.default.instances.0.console_url
}
output "mq_instance_endpoint" {
  value = aws_mq_broker.default.instances.0.endpoints.0
}
output "kubernetes_endpoint" {
  value = aws_eks_cluster.default.endpoint
}
output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.default.certificate_authority[0].data
}
