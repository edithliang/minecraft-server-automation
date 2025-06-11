output "minecraft_server_ip" {
  description = "The public IP of the Minecraft server"
  value       = aws_instance.minecraft.public_ip
}
