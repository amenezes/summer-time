#!/bin/bash
#
# BSECteam
# author: alexandre menezes
# contact: alexandre.fmenezes@gmail.com
#
# date: 2013-10-03
# version: 0.2
#
# Usage:
# sh summer-time.sh
#
 
LOCALTIME=$(date | grep -ci brt)
BRT_ZONEINFO="/usr/share/zoneinfo/Brazil/East"
ZDUMP=$(find /usr -maxdepth 2 -name zdump)
 
show_current_summer_time()
{
    CURRENT_YEAR=$(date | cut -d' ' -f5)
    echo "$(zdump -v "$BRT_ZONEINFO" | grep "$CURRENT_YEAR" | grep -i oct)"
    NEXT_YEAR=$(($CURRENT_YEAR+1))
    echo "$(zdump -v "$BRT_ZONEINFO" | grep "$NEXT_YEAR" | grep -i feb)"
}
 
config_test()
{
    case "$LOCALTIME" in
    1)
        echo "[*] alteracoes de timezone NAO sao necessarias!"
        if [ -a "$ZDUMP" ]
        then
            echo "[*] mudancas do horario de verao entram em vigor em:"
            show_current_summer_time
        fi
        ;;
    *)
        echo "[*] alteracoes de timezone necessarias!"
        echo "[*] timezone atual:"
        echo "[*] $(date | cut -d' ' -f5)"
        ;;
    esac
}
 
make_adjust()
{
    echo "[*] efetuando verificacao de dependencias..."
    if [ -a "$BRT_ZONEINFO" ]
    then
        echo "[*] arquivo zoneinfo <brazil/east> localizado"
        echo "[*] inicializando alteracoes..."
        rm /etc/localtime; ln -s $BRT_ZONEINFO /etc/localtime
        echo "[*] alteracoes efetuadas com sucesso!"
        TIMEZONE=$(date | cut -d' ' -f5)
        echo "[*] timezone ajustado para <$TIMEZONE>"
        if [ -a "$ZDUMP" ]
        then
            echo "[*] horario de verao entra em vigor em:"
            show_current_summer_time
        fi
    else
        echo "[-] arquivo zoneinfo <brazil/east> nao localizado!"
        echo "[-] alteracoes NAO efetuadas, a dependencia nao foi satisfeita :-/"
    fi
}
 
show_help_menu()
{
    echo ">> $0"
    echo "Usage:"
    echo "Sample: sh $0"
    echo ""
    echo "Options:"
    echo "-s  efetua as mudancas necessarias de timezone para o horario de verao"
    echo "-t  verifica se ha mudancas necessarias para adequacao ao horario de verao no sistema"
    echo "-h  exibe este menu de ajuda"
    echo ""
    echo "contact: alexandre.fmenezes@gmail.com"
    echo "bsecteam (C) [2013-2016] - <http://www.bsecteam.com/>"
}
 
while getopts "sth" opt; do
case $opt in
t)
    echo "[*] inicializando teste de compatibilidade"
    config_test
    ;;
s)
    echo "[*] inicializando alteracoes"
    make_adjust
    ;;
h)
    show_help_menu
    ;;
esac
done
 
if [ "$1" == "" ]
then
    show_help_menu
fi
