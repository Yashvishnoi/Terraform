resource "local_file" "tf_example1" {
  filename = "${path.module}/example1.txt"
  content  = "hey, this is a terraform course!"
}
