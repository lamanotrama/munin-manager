#!/bin/sh
# Originally by kuroda
#
# 複数のmunin-serverに処理させたデータを集めたり、一元管理されたconfを配布します。

[ $( whoami ) = 'munin' ] || {
    echo "Please run it as user 'munin'."  1>&2
    exit 1
}

GROUP=xxxx  # service名を入れる

BASEDIR=/usr/local/munin-manager
CONFS=$BASEDIR/var/conf.d
DBS=$BASEDIR/var/lib.d

HTMLDIR=/var/www/html/munin
DBDIR=$BASEDIR/lib

RETRY=0
RSYNC_OPTS='-au'
MUNIN_SERVERS=$( ls $CONFS )
SYNC_RRD=0

while getopts h:rav OPT
do
    case $OPT in
    "h")
        MUNIN_SERVERS="$OPTARG"
        ;;
    "r")
        RETRY=-1
        ;;
    "a")
        SYNC_RRD=1
        ;;
    "v")
        RSYNC_OPTS="$RSYNC_OPTS -v"
        ;;
    *)
        (
        echo "Usage: $( basename $0 ) [OPTION]..."
        echo "  -r retry lockfile forever"
        echo "  -a sync rrd"
        echo "  -v verbose"
        echo "  -h=SERVER spec target munin-server"
        ) 1>&2
        exit 1
        ;;
    esac
done

# try lock
SEM=/var/run/munin/$( basename $0 ).lock
lockfile -10 -r "$RETRY" -l 3600 $SEM || exit $?
trap "rm -f $SEM; exit 1" 2 3 15


mkdir -p $CONFS $DBS $DBDIR

for MUNIN_SERVER in $MUNIN_SERVERS
do
    (
    # send conf
    rsync $RSYNC_OPTS $CONFS/$MUNIN_SERVER $MUNIN_SERVER::munin/munin.conf

    # receive graph
    rsync $RSYNC_OPTS $MUNIN_SERVER::munin/html/$GROUP/ $HTMLDIR/$GROUP/

    # receive datafile
    rsync $RSYNC_OPTS $MUNIN_SERVER::munin/datafile $DBS/$MUNIN_SERVER/

    # receive rrd
    [ $SYNC_RRD = 1 ] &&
        rsync $RSYNC_OPTS $MUNIN_SERVER::munin/$GROUP $DBDIR/
    ) &
done

wait

# merge datafile
cat $DBS/*/datafile > $DBDIR/datafile

# unlock
rm -f $SEM

exit 0

