# munin-manager

muninでnode数が大杉で一台で処理しきれ無くなったのででっちあげた。

複数台のmunin serverへの処理の振り分けと定期的なデータ収集を、munin本体には(ほぼ)手を加えずに出来るようにしてます。


## Files

muninとmunin_managerは同居もできるが、別に考える。

### munin (クラスタノード)

* config  `/etc/munin/munin.conf -> /var/lib/munin/munin.conf # symlink`
* dbdir   `/var/lib/munin`
* htmldir `/var/lib/munin/html`

### munin-manager

* config  `/etc/munin/munin-manager.conf`
* dbdir   `/usr/local/munin-manager/lib`
* htmldir `/var/www/munin/html`


## How to Setup

### munin (クラスタノード)

1. muninをインストール
1. munin.conf は /var/lib/munin 以下に自動生成されるようになるのでリンクを貼っておく
```
mv /etc/munin/munin.conf{,.orig}
ln -s /var/lib/munin/munin.conf /etc/munin/munin.conf
```

1. `/usr/bin/munin-cron` からmunin-htmlの実行をコメントアウトして、実行されないようにしておく(作っても使われないので無駄)
```
# nice /usr/share/munin/munin-html $@ || exit 1
```

1. 各muninサーバのデータを集めるのとconfを配布する用にrsyncdを使えるようにしておく
  * `cat /usr/local/munin-manager/misc/rsyncd.conf >> /etc/rsyncd.conf`
  * `service xinetd restart`
1. あとは、managerがconfigの生成とデータ収集を勝手にやってくれる

### munin-manager

1. muninをインストール
1. このプロジェクトをmanagerサーバ /usr/local/munin-manager に置く
```
cd /usr/local
git clone git@github.com:lamanotrama/munin-manager.git
chown -R munin. munin-manager
```

1. crontabファイルを設置
```
cp munin-manager/misc/crontab /etc/cron.d/munin-manager
```

1. 可能ならhtmldir(`/var/www/munin/html`)はtmpfsを使う




