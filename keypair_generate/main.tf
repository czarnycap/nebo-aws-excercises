provider "aws" {
  region = "us-east-1"
}

# Generate a key pair
resource "tls_private_key" "nebo_key" {
  algorithm = "RSA"
  rsa_bits = 2048 

}

output "key_private" {
  value = tls_private_key.nebo_key.private_key_pem
  sensitive = true
}
