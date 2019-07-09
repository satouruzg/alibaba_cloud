#-------------------------------------------------------
# Profile
#-------------------------------------------------------
variable "access_key" {
  type        = "string"
  description = "AccessKeyを定義してください。"
}

variable "secret_key" {
  type        = "string"
  description = "SecretAccessKeyを定義してください。"
}

#-------------------------------------------------------
# Common
#-------------------------------------------------------
variable "ecs_windows_password" {
  type        = "string"
  description = "Windowsサーバ共通のパスワードを定義してください。"
}


#-------------------------------------------------------
# VPC
#-------------------------------------------------------
variable "vpc_cidr" {
  type        = "string"
  default     = "192.168.0.0/16"
  description = "VPCのIPアドレス範囲を定義してください。有効値は「10.0.0.0/8」「172.16.0.0/12」「192.168.0.0/16」の何れかです。"
}

variable "vpc_name" {
  type        = "string"
  default     = "vpc_fileserver"
  description = "VPCのリソース名を定義してください。"
}

variable "vpc_description" {
  type        = "string"
  default     = "VPC for FileServer"
  description = "VPCの説明を定義してください。"
}

#-------------------------------------------------------
# VSwitch
#-------------------------------------------------------
variable "vsw_a_cidr" {
  type        = "string"
  default     = "192.168.0.0/24"
  description = "Aゾーン用VSwitchのCIDRを定義してください。"
}

variable "vsw_a_name" {
  type        = "string"
  default     = "vsw_zone_a"
  description = "Aゾーン用VSwitchの名前を定義してください。"
}

variable "vsw_a_description" {
  type        = "string"
  default     = "VSwitch for Tokyo Zone A"
  description = "Aゾーン用VSwitchの説明を定義してください。"
}

variable "vsw_b_cidr" {
  type        = "string"
  default     = "192.168.1.0/24"
  description = "Bゾーン用VSwitchのCIDRを定義してください。"
}

variable "vsw_b_name" {
  type        = "string"
  default     = "vsw_zone_b"
  description = "Bゾーン用VSwitchの名前を定義してください。"
}

variable "vsw_b_description" {
  type        = "string"
  default     = "VSwitch for Tokyo Zone B"
  description = "Bゾーン用VSwitchの説明を定義してください。"
}


#-------------------------------------------------------
# NAS File System
#-------------------------------------------------------
variable "nas_fs_name" {
  type        = "string"
  default     = "nas_fs"
  description = "ファイルサーバストレージ用のNASファイルシステムの説明を定義してください。"
}

variable "nas_bk_name" {
  type        = "string"
  default     = "nas_bk"
  description = "バックアップ用のNASファイルシステムの説明を定義してください。"
}


#-------------------------------------------------------
# Security Group
#-------------------------------------------------------
variable "sg_name" {
  type        = "string"
  default     = "sg_fileserver"
  description = "Security Groupの名前を定義してください。"
}

variable "sg_description" {
  type        = "string"
  default     = "Security Group for FileServer"
  description = "Security Groupの説明を定義してください。"
}

variable "client_ipaddresses" {
  type = "list"
  default = [
    "0.0.0.0/0"
  ]
  description = "クライアントのIPアドレスをCIDR形式で定義してください。（複数可）"
}


#-------------------------------------------------------
# SSHキーペア
#-------------------------------------------------------
variable "keypair_name" {
  type        = "string"
  default     = "keypair_fileserver"
  description = "SSHキーペアの名前を定義してください。"
}

variable "keypair_file_path" {
  type        = "string"
  default     = "./private_key.pem"
  description = "秘密鍵の保存先を定義してください。"
}


#-------------------------------------------------------
# ECS
#-------------------------------------------------------
variable "instance_type_addc" {
  type        = "string"
  default     = "ecs.t5-c1m4.large"
  description = "Active Directoryドメインコントローラ用ECSインスタンスのインスタンススペックを定義してください。"
}

variable "custom_image_addc_primary" {
  type        = "string"
  default     = "m-6we6gw6mzq7ydkpz8gcd"
  description = "Active Directoryドメインコントローラ プライマリサーバ用のイメージIDを定義してください。"
}

variable "instance_name_addc_primary" {
  type        = "string"
  default     = "ecs_addc_primary"
  description = "Active Directoryドメインコントローラ プライマリサーバ用のインスタンス名を定義してください。"
}

variable "host_name_addc_primary" {
  type        = "string"
  default     = "addc-primary"
  description = "Active Directoryドメインコントローラ プライマリサーバ用のホスト名を定義してください。"
}

variable "description_addc_primary" {
  type        = "string"
  default     = "ECS for Active Directory Domain Controller Primary Server"
  description = "Active Directoryドメインコントローラ プライマリサーバ用のECSインスタンスの説明を定義してください。"
}

variable "custom_image_addc_secondary" {
  type        = "string"
  default     = "m-6we4luaw7vjjwlb42a0a"
  description = "Active Directoryドメインコントローラ セカンダリサーバ用のイメージIDを定義してください。"
}

variable "instance_name_addc_secondary" {
  type        = "string"
  default     = "ecs_addc_secondary"
  description = "Active Directoryドメインコントローラ セカンダリサーバ用のインスタンス名を定義してください。"
}

variable "host_name_addc_secondary" {
  type        = "string"
  default     = "addc-secondary"
  description = "Active Directoryドメインコントローラ セカンダリサーバ用のホスト名を定義してください。"
}

variable "description_addc_secondary" {
  type        = "string"
  default     = "ECS for Active Directory Domain Controller Secondary Server"
  description = "Active Directoryドメインコントローラ セカンダリサーバ用のECSインスタンスの説明を定義してください。"
}

variable "custom_image_manager" {
  type        = "string"
  default     = "m-6we6gw6mzq7ydkpz8gce"
  description = "運用サーバ用のイメージIDを定義してください。"
}

variable "instance_type_manager" {
  type        = "string"
  default     = "ecs.t5-lc1m2.small"
  description = "運用サーバ用のECSインスタンス名を定義してください。"
}

variable "instance_name_manager" {
  type        = "string"
  default     = "ecs_manager"
  description = "運用サーバ用のECSインスタンス名を定義してください。"
}

variable "host_name_manager" {
  type        = "string"
  default     = "manager"
  description = "運用サーバ用のホスト名を定義してください。"
}

variable "description_addc_manager" {
  type        = "string"
  default     = "ECS for Manager Server"
  description = "運用サーバ用の説明を定義してください。"
}

#-------------------------------------------------------
# SLB
#-------------------------------------------------------
variable "slb_name" {
  type        = "string"
  default     = "slb_fileserver"
  description = "SLBの名前を定義してください。"
}

variable "slb_spec" {
  type        = "string"
  default     = "slb.s1.small"
  description = "SLBのスペックを定義してください。"
}

#-------------------------------------------------------
# Auto Scaling
#-------------------------------------------------------
variable "asg_name" {
  type        = "string"
  default     = "asg_fileserver"
  description = "Scaling Groupの名前を定義してください。"
}

variable "asg_config_name" {
  type        = "string"
  default     = "asg_config_fileserver"
  description = "Scaling Configrationの名前を定義してください。"
}

variable "custom_image_fileserver" {
  type        = "string"
  default     = "m-6we6q0jns1mfulabv9fb"
  description = "ファイルサーバ用のイメージIDを定義してください。"
}

variable "instance_type_fileserver" {
  type        = "string"
  default     = "ecs.t5-c1m2.large"
  description = "ファイルサーバ用インスタンスタイプを定義してください。"
}

variable "instance_name_fileserver" {
  type        = "string"
  default     = "ecs_fileserver"
  description = "ファイルサーバ用インスタンスタイプを定義してください。"
}
