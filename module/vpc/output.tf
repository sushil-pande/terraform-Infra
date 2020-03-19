output "out_vpc_id" {
  value = "${data.aws_vpc.selected.id}"
}
output "out_vpc_cidr_block" {
  value = "${data.aws_vpc.selected.cidr_block}"
}
output "out_private_sub1_id" {
  value = "${aws_subnet.private_sub1.id}"
}
output "out_private_sub2_id" {
  value = "${aws_subnet.private_sub2.id}"
}
output "out_public_sub1_id" {
  value = "${aws_subnet.public_sub1.id}"
}
output "out_public_sub2_id" {
  value = "${aws_subnet.public_sub2.id}"
}