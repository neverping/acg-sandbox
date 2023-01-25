resource "tls_private_key" "azal" {
  algorithm = "ED25519"
}

resource "tls_self_signed_cert" "azal" {
  private_key_pem       = tls_private_key.azal.private_key_pem
  validity_period_hours = 12

  subject {
    common_name         = "azal.com"
    organization        = "Aztec Alpaca"
    organizational_unit = "The A Team"
    country             = "DK"
    locality            = "Copenhagen"
    postal_code         = "2450"
    province            = "Hovedstaden"
  }

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "client_auth",
  ]
}
