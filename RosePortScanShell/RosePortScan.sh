#!/usr/bin/env bash
#dia 24 de maio ás 11:18
#Script que analisa portas populares de um host na internet com uma lista
#Pode ser feito direto no bash sem IDE, mas eu gosto de documentar tudo e deixar colorido rs
#Modo de uso: sudo bash script.sh IP do host alvo

#Dia 3 de junho ás 22:44
#Adicionei um menu de ajuda personalizado, um case para o primeiro parametro (organização do código)
#Amanha pretendo colocar as funções novas no programa!

#Dia 4 de junho
#Adicionei os scans de portas populares com -a e de todas as portas com o -l
#Menu de ajuda, menu se der algum parametro inválido e também quando não houver parametro
#Alguns ajustes estéticos da saída do programa forama ajustados
#Coloquei delay no scan popular para tentar evitar bloqueio por ip (v1.0)

#Dia 14 de junho #Produção da versão v1.1 (começo)
#Adicionei validacao do pacote hping3 (necessário para rodar o programa)
#Validação de root para rodar o scan
#Nova Message help  (Só irei atualizar o código no github quando a v1.1 estiver full pronta!)

#-----------------------------------------------------------------------------------------

#VARIAVEIS

COR_VERMELHO="\e[31;1m"

COR_AMARELO="\e[33;1m"

COR_BRANCO="\e[37;1;5m"

MENSAGEM_HELP="

  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  >      SCAN DE PORTAS TCP POPULARES!                    <
  >      $(basename $0)                               <
  >                                                       <
  >                                                       <
  >      .......                                          < ---> MENU DE AJUDA! VEJA O MODO DE USO ABAIXO!
  >      .     .         .......         SCAN             <
  >      ....... ......  .    .   ......                  < ---------> MODOO DE USO
  >      .       .    .  .   .      .                     <
  >      .       ......  .    ..    .                     < ---> PopularTcpPorts.sh -a [ipdohost] (Scan portas TCP populares E com delay)
  >                                                       <
  >                                                       < ---> PopularTcpPorts.sh -l [ipdohost] (Scan de todas as portas TCP e sem delay)
  >                                                       <
  >      v1.0 (05/06/22)                                  <
  >                                                       <
  > By:Whiterose / Github.com/paixaoalmeida               <
  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

"

MENSAGEM_HELP_INVALIDO="

  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  >      SCAN DE PORTAS TCP POPULARES!                    <
  >      $(basename $0)                               <
  >                                                       <
  >                                                       <
  >      .......                                          <
  >      .     .         .......         SCAN             <
  >      ....... ......  .    .   ......                  < ---------> MODOO DE USO
  >      .       .    .  .   .      .                     <
  >      .       ......  .    ..    .                     < ---> PopularTcpPorts.sh -a [ipdohost] (Scan portas TCP populares E com delay)
  >                                                       <
  >                                                       < ---> PopularTcpPorts.sh -l [ipdohost] (Scan de todas as portas TCP e sem delay)
  > --->   PARAMETRO INVÁLIDO! VEJA O MODO DE USO!   <--- <
  >                                                       <
  >                                                       <
  > By:Whiterose / Github.com/paixaoalmeida               <
  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"
MENSAGEM_HELP_HPING="
  VOCÊ NÃO TEM O PACOTE hping3 instalado!
  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  >      SCAN DE PORTAS TCP POPULARES!                    <
  >      $(basename $0)                                   <
  >                                                       <
  >                                                       <
  >      .......                                          <
  >      .     .         .......         SCAN             <
  >      ....... ......  .    .   ......                  < ---------> MODOO DE USO
  >      .       .    .  .   .      .                     <
  >      .       ......  .    ..    .                     < ---> PopularTcpPorts.sh -a [ipdohost] (Scan portas TCP populares E com delay)
  >                                                       <
  >                                                       < ---> PopularTcpPorts.sh -l [ipdohost] (Scan de todas as portas TCP e sem delay)
  > --> INSTALE O PACOTE hping3 | sudo apt install hping3 <
  > --> Ou qualquer outro instalador do seu sistema! <--- <
  >                                                       <
  > By:Whiterose / Github.com/paixaoalmeida               <
  >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
"


#------------------------------------------------------------------------------------------------
#VERIFICACOES DO PROGRAMA

if [ ! "$(which hping3)" == /usr/sbin/hping3 ]; then            #hping3 está instalado?
  echo "$MENSAGEM_HELP_HPING"
  exit 1
elif [ ! "$(id -u)" == 0 ]; then                                #está rodando como root?
  echo -e ${COR_BRANCO}"A PARTE DO SCAN SÓ FUNCIONA RODANDO COMO ROOT! APERTE SUDO! \e[m \n"
  exit 1
fi

#----------------------------------------------------------------------------------------------------

case "$1" in
  -h) echo "$MENSAGEM_HELP"                                                         && exit 0                         ;;

  -a) echo -e ${COR_BRANCO}"OBS: ESSE MODO DO SCAN TEM DELAY PARA TENTAR EVITAR BLOQUEIO POR IP! \e[m \n"
        while read portas;do
          if [ $(hping3 -S -p $portas -c 1 $2 2> /dev/null | grep flags=SA | cut -d " " -f 6 | cut -d = -f 2) ];then
            echo -e ${COR_VERMELHO}"Porta $portas ABERTA no host com"${COR_AMARELO} "IP $2 \n"
            sleep 10             #Sleep para tentar evitar bloqueio
          fi                     #Port scan portas TCP populares
        done < portas.txt                                                           && exit 0                         ;;

  -l) for ip in $(seq 1 65536);do
    if [ $(hping3 -S -p $ip -c 1 $2 2> /dev/null | grep flags=SA | cut -d " " -f 2 | cut -d = -f 2) ];then
      echo -e ${COR_VERMELHO}"Porta $ip ABERTA no host com"${COR_AMARELO} "IP $2 \n"
    fi                          #Full port-scan, com todas as portas  TCP
  done                                                                              && exit 0                         ;;


  *) echo "$MENSAGEM_HELP_INVALIDO"                                                 && exit 1                         ;;
esac
