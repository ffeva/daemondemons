
#-----------Route53-------------

# Jenkins A Record Set
resource "aws_route53_record" "jenkins" {
  depends_on = [aws_eip_association.jenkins_eip_assoc]
  zone_id    = var.zone_id
  name       = "https://jenkins.${var.dnsprefix}.${var.dnszone}"
  type       = "A"
  ttl        = "20"
  records    = [aws_eip.jenkins_eip.public_ip]
}
