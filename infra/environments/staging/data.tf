data "local_file" "start_openvpn_sh" {
  filename = "${path.module}/start_openvpn.sh"
}