resource "random_password" "vm-passwords" {
  count            = 3
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "vault_mount" "avinash" {
  path        = "avinash"
  type        = "kv-v2"
  description = "This Container avinash Family Secrets"
}

resource "vault_mount" "suryaprasad" {
  path        = "suryaprasad"
  type        = "kv-v2"
  description = "This Container suryaprasad Family Secrets"
}


resource "vault_kv_secret_v2" "Prod-secrets" {
  count               = 3
  mount               = vault_mount.avinash.path
  name                = "linux-machine-${count.index + 1}"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      username = "adminsai",
      password = element(random_password.vm-passwords.*.result, count.index)
    }
  )
  custom_metadata {
    max_versions = 5
    data = {
      foo = "vault@avinash.com"
    }
  }
}


#Creating suryaprasad Secrets
resource "vault_kv_secret_v2" "super-secrets" {
  count               = 3
  mount               = vault_mount.suryaprasad.path
  name                = "super-linux-machine-${count.index + 1}"
  cas                 = 1
  delete_all_versions = true
  data_json = jsonencode(
    {
      username = "adminsai",
      password = element(random_password.vm-passwords.*.result, count.index)
    }
  )
  custom_metadata {
    max_versions = 5
    data = {
      foo = "vault@suryaprasad.com"
    }
  }
}