resource "local_file" "example1" {
  content  = "This is example 1 ."
  filename = "${path.module}/example1.txt"
}

resource "local_file" "example2" {
  content  = "This is example 2"
  filename = "${path.module}/example2.txt"
}

resource "local_file" "Senstive" {
  content  = "Senstive Information ."
  filename = "${path.module}/senstive.md"
}