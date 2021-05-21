output "private_key" {
  value     = tls_private_key.key.private_key_pem
  sensitive = true
}


output "vm_ip" {
  value     = azurerm_linux_virtual_machine.vm_tf.*.public_ip_address
  sensitive = false
}