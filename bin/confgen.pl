
# がっつり社内システムに依存してるので秘密で…


=head1 NAME

 munin-manager

=head1 SYNOPSIS

  */10 * * * *  root  /usr/local/munin-manager/bin/confgen.pl

対象ホストが増減した時だけ叩くようにするのもアリ。

=head1 DESCRIPTION

muninのconfigジェネレータスクリプト

各クラスタノード用のconfigはこの下にホスト名をファイル名にして作成

    /usr/local/munin-manager/var/conf.d/

munin-manger用のconfigはこここに

    /etc/munin/munin-manager.conf

configのテンプレート(Text::Xslate用)はtemplates以下にあるので参考にしてください。

=cut
