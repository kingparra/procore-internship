output "lb_endpoint" {
  value = "http://${module.alb.alb_dns_name}"
}