# ファイルサーバ Aゾーン用マウントポイント
output "mountpoint_fileserver_zone_a" {
  value = "${alicloud_nas_mount_target.mp_fs_zone_a.id}"
}

# ファイルサーバ Bゾーン用マウントポイント
output "mountpoint_fileserver_zone_b" {
  value = "${alicloud_nas_mount_target.mp_fs_zone_b.id}"
}

# バックアップ用マウントポイント
output "mountpoint_backup" {
  value = "${alicloud_nas_mount_target.mp_bk.id}"
}

# SLBプライベートIPアドレス
output "private_ip_address_slb" {
  value = "${alicloud_slb.slb.address}"
}

# ファイルサーバプライベートIPアドレス
output "file_server_private_ip_addresses" {
  value = "${data.alicloud_instances.file_server.instances.*.private_ip}"
}

# Active Directoryドメインコントローラ プライマリサーバ プライベートIPアドレス
output "private_ip_address_addc_primary" {
  value = "${alicloud_instance.addc_primary.private_ip}"
}

# Active Directoryドメインコントローラ セカンダリサーバ プライベートIPアドレス
output "private_ip_address_addc_secondary" {
  value = "${alicloud_instance.addc_secondary.private_ip}"
}

# 運用サーバ プライベートIPアドレス
output "private_ip_address_manager" {
  value = "${alicloud_instance.manager.private_ip}"
}
