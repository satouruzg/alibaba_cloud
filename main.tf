#-------------------------------------------------------
# provider設定
#-------------------------------------------------------

provider "alicloud" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "ap-northeast-1"
}

#-------------------------------------------------------
# VPC
#-------------------------------------------------------

# VPC作成
resource "alicloud_vpc" "vpc" {
  cidr_block  = "${var.vpc_cidr}"
  name        = "${var.vpc_name}"
  description = "${var.vpc_description}"
}

# Aゾーン用VSwitch作成
resource "alicloud_vswitch" "vsw_a" {
  availability_zone = "ap-northeast-1a"
  vpc_id            = "${alicloud_vpc.vpc.id}"
  cidr_block        = "${var.vsw_a_cidr}"
  name              = "${var.vsw_a_name}"
  description       = "${var.vsw_a_description}"
}

# Bゾーン用VSwitch作成
resource "alicloud_vswitch" "vsw_b" {
  availability_zone = "ap-northeast-1b"
  vpc_id            = "${alicloud_vpc.vpc.id}"
  cidr_block        = "${var.vsw_b_cidr}"
  name              = "${var.vsw_b_name}"
  description       = "${var.vsw_b_description}"
}


#-------------------------------------------------------
# NAS
#-------------------------------------------------------
# ファイルサーバストレージ用NAS作成
resource "alicloud_nas_file_system" "nas_fs" {
  protocol_type = "NFS"
  storage_type  = "Capacity"
  description   = "${var.nas_fs_name}"
}

# バックアップ用NAS作成
resource "alicloud_nas_file_system" "nas_bk" {
  protocol_type = "NFS"
  storage_type  = "Capacity"
  description   = "${var.nas_bk_name}"
}

# ファイルサーバ Aゾーン用マウントポイント作成
resource "alicloud_nas_mount_target" "mp_fs_zone_a" {
  file_system_id    = "${alicloud_nas_file_system.nas_fs.id}"
  access_group_name = "DEFAULT_VPC_GROUP_NAME"
  vswitch_id        = "${alicloud_vswitch.vsw_a.id}"
}

# ファイルサーバ Bゾーン用マウントポイント作成
resource "alicloud_nas_mount_target" "mp_fs_zone_b" {
  file_system_id    = "${alicloud_nas_file_system.nas_fs.id}"
  access_group_name = "DEFAULT_VPC_GROUP_NAME"
  vswitch_id        = "${alicloud_vswitch.vsw_b.id}"
}

# バックアップ用マウントポイント作成
resource "alicloud_nas_mount_target" "mp_bk" {
  file_system_id    = "${alicloud_nas_file_system.nas_bk.id}"
  access_group_name = "DEFAULT_VPC_GROUP_NAME"
  vswitch_id        = "${alicloud_vswitch.vsw_a.id}"
}

#-------------------------------------------------------
# Security Group
#-------------------------------------------------------

# Security Grouop作成
resource "alicloud_security_group" "security_group" {
  name        = "${var.sg_name}"
  description = "${var.sg_description}"
  vpc_id      = "${alicloud_vpc.vpc.id}"
}


# SSH用ルール追加
resource "alicloud_security_group_rule" "sg_ssh_rule" {

  count = "${length(var.client_ipaddresses)}"

  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  security_group_id = "${alicloud_security_group.security_group.id}"
  nic_type          = "intranet"
  cidr_ip           = "${element(var.client_ipaddresses, count.index)}"
}

# RDP用ルール追加
resource "alicloud_security_group_rule" "sg_rdp_rule" {

  count = "${length(var.client_ipaddresses)}"

  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "3389/3389"
  security_group_id = "${alicloud_security_group.security_group.id}"
  nic_type          = "intranet"
  cidr_ip           = "${element(var.client_ipaddresses, count.index)}"
}

# SMB用ルール追加
resource "alicloud_security_group_rule" "sg_smb_rule" {

  count = "${length(var.client_ipaddresses)}"

  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "445/445"
  security_group_id = "${alicloud_security_group.security_group.id}"
  nic_type          = "intranet"
  cidr_ip           = "${element(var.client_ipaddresses, count.index)}"
}

#-------------------------------------------------------
# SSHキーペア
#-------------------------------------------------------
# SSHキーペア作成
resource "alicloud_key_pair" "keypair" {
  key_name = "${var.keypair_name}"
  key_file = "${var.keypair_file_path}"
}

#-------------------------------------------------------
# SLB
#-------------------------------------------------------
resource "alicloud_slb" "slb" {
  name           = "${var.slb_name}"
  specification  = "${var.slb_spec}"
  vswitch_id     = "${alicloud_vswitch.vsw_a.id}"
  master_zone_id = "ap-northeast-1a"
  slave_zone_id  = "ap-northeast-1b"
}

resource "alicloud_slb_listener" "slb_listener" {
  load_balancer_id = "${alicloud_slb.slb.id}"
  protocol         = "tcp"
  frontend_port    = 445
  backend_port     = 445
  bandwidth        = -1
}

#-------------------------------------------------------
# Auto Scaling
#-------------------------------------------------------
resource "alicloud_ess_scaling_group" "scaling_group" {
  scaling_group_name = "${var.asg_name}"
  min_size           = 1
  max_size           = 1
  vswitch_ids        = ["${alicloud_vswitch.vsw_a.id}", "${alicloud_vswitch.vsw_b.id}"]
  multi_az_policy    = "BALANCE"
  loadbalancer_ids   = ["${alicloud_slb.slb.id}"]
  depends_on         = [alicloud_slb_listener.slb_listener]
}

resource "alicloud_ess_scaling_configuration" "scaling_config" {
  scaling_configuration_name = "${var.asg_config_name}"
  scaling_group_id           = "${alicloud_ess_scaling_group.scaling_group.id}"
  image_id                   = "${var.custom_image_fileserver}"
  instance_type              = "${var.instance_type_fileserver}"
  instance_name              = "${var.instance_name_fileserver}"
  security_group_id          = "${alicloud_security_group.security_group.id}"
  key_name                   = "${alicloud_key_pair.keypair.id}"
  internet_charge_type       = "PayByTraffic"
  enable                     = true
  active                     = true
  force_delete               = true
}

#-------------------------------------------------------
# ECS
#-------------------------------------------------------

resource "alicloud_instance" "addc_primary" {
  image_id          = "${var.custom_image_addc_primary}"
  instance_type     = "${var.instance_type_addc}"
  availability_zone = "ap-northeast-1a"
  vswitch_id        = "${alicloud_vswitch.vsw_a.id}"
  security_groups   = "${alicloud_security_group.security_group.*.id}"
  instance_name     = "${var.instance_name_addc_primary}"
  host_name         = "${var.host_name_addc_primary}"
  password          = "${var.ecs_windows_password}"
  description       = "${var.description_addc_primary}"
}

resource "alicloud_instance" "addc_secondary" {
  image_id          = "${var.custom_image_addc_secondary}"
  instance_type     = "${var.instance_type_addc}"
  availability_zone = "ap-northeast-1b"
  vswitch_id        = "${alicloud_vswitch.vsw_b.id}"
  security_groups   = "${alicloud_security_group.security_group.*.id}"
  instance_name     = "${var.instance_name_addc_secondary}"
  host_name         = "${var.host_name_addc_secondary}"
  password          = "${var.ecs_windows_password}"
  description       = "${var.description_addc_secondary}"
}

resource "alicloud_instance" "manager" {
  image_id          = "${var.custom_image_manager}"
  instance_type     = "${var.instance_type_manager}"
  availability_zone = "ap-northeast-1a"
  vswitch_id        = "${alicloud_vswitch.vsw_a.id}"
  security_groups   = "${alicloud_security_group.security_group.*.id}"
  instance_name     = "${var.instance_name_manager}"
  host_name         = "${var.host_name_manager}"
  key_name          = "${alicloud_key_pair.keypair.id}"
  description       = "${var.description_addc_manager}"
}

#-------------------------------------------------------
# ファイルサーバ情報取得
#-------------------------------------------------------
data "alicloud_instances" "file_server" {
  name_regex = "${var.instance_name_fileserver}"
}

