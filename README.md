# ファイルサーバ構築用Terraformテンプレート
### main.tf
Alibaba Cloudリソースの構築を行うメインテンプレートファイルです。  
原則的に、編集する必要はありません。

### variables.tf
変数の宣言を行うファイルです。  
各変数のデフォルトが定義されています。

### terraform.tfvars
variables.tfで定義したデフォルト値を変更したい場合に設定するファイルです。  
アンコメントアウトし、任意の値を設定してください。

### credential.tfvars
認証情報を設定するファイルです。  
必ず設定する必要があります。

### output.tf
作成したリソースの情報を出力するファイルです。  
必要に応じて、出力対象を追加してください。

## 実行方法

* ドライラン
		terraform plan -var-file=credential.tfvars


* リソース作成
                terraform apply -var-file=credential.tfvars


* リソース削除
                terraform destory -var-file=credential.tfvars

