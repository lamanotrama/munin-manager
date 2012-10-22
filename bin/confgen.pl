muninのconfigジェネレータスクリプト

がっつり社内システムに依存してるので秘密で…

 * 各クラスタノード用のconfigはこの下にホスト名をファイル名にして作成

   /usr/local/munin-manager/var/conf.d/

 * munin-manger用のconfigはこここに

   /etc/munin/munin-manager.conf

configのテンプレート(Text::Xslate用)はtemplates以下にあるので参考にしてください。
