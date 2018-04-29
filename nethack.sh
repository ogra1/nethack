#! /bin/sh

export PATH="$PATH:$SNAP/games/lib/nethackdir"
export HOME="$SNAP_USER_DATA"
export HACKDIR="$SNAP_USER_DATA"
export NETHACKOPTIONS="$SNAP_USER_DATA/.nethackrc"

export I18NPATH="$SNAP/usr/share/i18n"
export LOCPATH="$SNAP_USER_DATA"

GAMELANG=en_US
GAMEENC=UTF-8
GAMELOC="$GAMELANG.$GAMEENC"

# generate a locale so we get properly working charsets and graphics
if [ ! -e "$SNAP_USER_DATA/$GAMELOC" ]; then
  localedef --prefix="$SNAP_USER_DATA" -f "$GAMEENC" -i "$GAMELANG" "$SNAP_USER_DATA/$GAMELOC"
fi

export LC_ALL="$GAMELOC"
export LANG="$GAMELOC"
export LANGUAGE="${GAMELANG%_*}"

if [ ! -e "$SNAP_USER_DATA/.nethackrc" ]; then
  cat << EOF >"$SNAP_USER_DATA/.nethackrc"
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

export LEVELDIR="$SNAP_USER_DATA/levels"
export SAVEDIR="$SNAP_USER_DATA/save"
export BONESDIR="$SNAP_USER_DATA/save"
export LOCKDIR="$SNAP_USER_DATA/levels"


if [ -e "$SNAP_USER_DATA/nhdat" ]; then
    # make sure nhdat matches the binary, copy the new one in place if not
    MATCH="    NetHack version "
    NHFILE_NEW="$SNAP/games/lib/nethackdir/nhdat"
    NHFILE_OLD="$SNAP_USER_DATA/nhdat"
    CUR_VER="$(strings "$NHFILE_OLD" | grep "${MATCH}" | sed "s/^${MATCH}//")"
    NEW_VER="$(strings "$NHFILE_NEW" | grep "${MATCH}" | sed "s/^${MATCH}//")"
    if [ "$CUR_VER" != "$NEW_VER" ]; then
        cp "$NHFILE_NEW" "$SNAP_USER_DATA/"
    fi
else
    cp "$SNAP/games/lib/nethackdir/nhdat" "$SNAP_USER_DATA/"
fi
[ -e "$SNAP_USER_DATA/symbols" ] || cp "$SNAP/games/lib/nethackdir/symbols" "$SNAP_USER_DATA/"
[ -e "$SNAP_USER_DATA/perm" ] || touch "$SNAP_USER_DATA/perm"
[ -e "$SNAP_USER_DATA/save" ] || mkdir "$SNAP_USER_DATA/save"
[ -e "$SNAP_USER_DATA/levels" ] || mkdir "$SNAP_USER_DATA/levels"

cd "$SNAP_USER_DATA"

"$SNAP"/games/lib/nethackdir/nethack -d . "$@"
