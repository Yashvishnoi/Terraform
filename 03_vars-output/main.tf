# resource "local_file" "example1" {
#   content  = "foo!"
#   filename = "${path.module}/${var.filename_1}.txt"
#   count = var.count_num
# }

# locals {
#   base_path = "${path.module}/files"   
# }

# resource "local_file" "example2" {
#   content  = "foo!"
#   filename = "${local.base_path}/example2.md"
# }

# resource "local_file" "example3" {
#   content  = "foo!"
#   filename = "${local.base_path}/example3.md"
# }

# resource "local_file" "example4" {
#   content  = "foo!"
#   filename = "${local.base_path}/example4.md"
# }

# # resource "local_file" "example1" {
# #   content  = "foo!"
# #   filename = "${path.module}/${var.filename_2}.md"
# #   count = var.count_num
# # }

# # resource "local_file" "example1" {
# #   content  = "foo!"
# #   filename = "${path.module}/${var.filename_3}.demo"
# #   count = var.count_num
# # }

locals {
  environment = "dev" // dev, staging, prod
  upper_case  = upper(local.environment)
  base_path   = "${path.module}/configs/${local.upper_case}"
}

resource "local_file" "service_configs" {
  filename = "${local.base_path}/service.sh"
  content  = <<EOT
  environment = ${local.environment}
  port=3000
  EOT
}
