#! /bin/sh

export HOME=$SNAP_USER_DATA
export HACKDIR=$SNAP_USER_DATA
export NETHACKOPTIONS=$SNAP_USER_DATA/.nethackrc

export I18NPATH=$SNAP/usr/share/i18n
export LOCPATH=$SNAP_USER_DATA

GAMELANG=en_US
GAMEENC=UTF-8
GAMELOC="$GAMELANG.$GAMEENC"

# generate a locale so we get properly working charsets and graphics
if [ ! -e $SNAP_USER_DATA/$GAMELOC ]; then
  localedef --prefix=$SNAP_USER_DATA -f $GAMEENC -i $GAMELANG $SNAP_USER_DATA/$GAMELOC
fi

export LC_ALL=$GAMELOC
export LANG=$GAMELOC
export LANGUAGE=${GAMELANG%_*}

if [ ! -e $SNAP_USER_DATA/.nethackrc ]; then
  cat << EOF >$SNAP_USER_DATA/.nethackrc
OPTIONS=windowtype:tty,toptenwin,hilite_pet,!number_pad
OPTIONS=fixinv,safe_pet,sortpack,tombstone,color
OPTIONS=verbose,news,fruit:potato
OPTIONS=dogname:Slinky
OPTIONS=catname:Rex
OPTIONS=pickup_types:$
OPTIONS=nomail
OPTIONS=DECgraphics
EOF
fi

[ -e $SNAP_USER_DATA/nhdat ] || cp $SNAP/nhdat $SNAP_USER_DATA/
[ -e $SNAP_USER_DATA/perm ] || touch $SNAP_USER_DATA/perm
[ -e $SNAP_USER_DATA/save ] || mkdir $SNAP_USER_DATA/save

cd $SNAP_USER_DATA

$SNAP/nethack -d . "$@"
