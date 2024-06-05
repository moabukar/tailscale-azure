module "subnet_router" {
  source = "../.."

  resource_group_name               = "tailscale-dev"
  vnet_name                         = "tailscale-dev"
  subnet_name                       = "tailscale-sub1"
  storage_account_name              = "tailscaledev"
  container_name                    = "tailscale"
  container_size                    = "small"
  container_group_name              = "tailscale-dev"
  container_source                  = "ACR"
  tailscale_ACR_repository          = "myacr.azurecr.io/tailscale"
  tailscale_image_tag               = "latest"
  tailscale_ACR_repository_username = "myacrusername"
  tailscale_ACR_repository_password = "supersecretP@ssw0rd"
  tailscale_hostname                = "tailscale-azure"
  tailscale_advertise_routes        = "10.0.0.0/21"
  tailscale_auth_key                = "<>"
}
