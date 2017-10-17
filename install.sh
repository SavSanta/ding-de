#!/bin/sh

DEFBINDIR="/usr/local/bin"
DEFLIBDIR="/usr/local/lib"

if [ "x`echo -n`" = "x-n" ]; then
    ECHO=echo
    END="\c"
else
    ECHO="echo -n"
    END=""
fi

echo "   --------------- Installation of Ding ---------------"
echo "A Dictionary lookup program and a German-English Dictionary"
echo ""

NEEDPROG="wish"

for f in $NEEDPROG; do
 
  $ECHO "Looking for $f ... $END"
  FOUND=0
  OIFS="$IFS"
  IFS=":"

  for d in $PATH; do
    if [ -x "$d/$f" ]; then
        FOUND=1
        break
    fi
  done

  if [ $FOUND -eq 0 ]; then
    echo  "Hmm, $f not found. You will need it to run 'ding'!"
  eval $ECHO "Install anyway?  [y]/n: $END"
    read yn
    if [ "x$yn" = "xn" -o "x$yn" = "xN" ]; then
        exit 1
    fi
  else
    echo "found in $d"
  fi
  IFS="$OIFS"
done

echo ""

OK=0
while [ $OK -eq 0 ] ; do
    $ECHO "Where do you want to install the program 'ding' [$DEFBINDIR]: $END"
    read BINDIR
    if [ "x$BINDIR" = "x" ]; then
        BINDIR=$DEFBINDIR
    fi
    if [ ! -d $BINDIR ]; then
        echo "Directory does not exist: $BINDIR"
    elif [ ! -w $BINDIR ]; then
        echo "Can't write to $BINDIR - no permissions!"
    else
        OK=1
    fi
done
OK=0
while [ $OK -eq 0 ] ; do
    $ECHO "Where do you want to install the dictionary [$DEFLIBDIR]: $END"
    read LIBDIR
    if [ "x$LIBDIR" = "x" ]; then
        LIBDIR=$DEFLIBDIR
    fi 
    if [ ! -d $LIBDIR ]; then
        echo "Directory does not exist: $LIBDIR"
    elif [ ! -w $LIBDIR ]; then
        echo "Can't write to $LIBDIR - no permissions!"
    else
        OK=1
    fi
done                     

echo ""
$ECHO "Ready to install to $BINDIR and $LIBDIR? [y]/n: $END"
read yn
if [ "x$yn" != "xn" -a "x$yn" != "xN" ]; then
    sed -e "s#/usr/share/dict/de-en.txt#$LIBDIR/de-en.txt#" ding > /tmp/ding.$$
 
    echo /bin/cp ding "$BINDIR/ding"
    /bin/mv /tmp/ding.$$ "$BINDIR/ding"
    chmod 755 "$BINDIR/ding"
    echo /bin/cp de-en.txt "$LIBDIR/de-en.txt"
    /bin/cp de-en.txt "$LIBDIR/de-en.txt"
    chmod 644 "$LIBDIR/de-en.txt"
else
    echo "Install aborted."
    exit 1
fi
echo ""
if [ $? = 0 ]; then
    echo "Installation seems to be ok, have fun using $BINDIR/ding"
fi
