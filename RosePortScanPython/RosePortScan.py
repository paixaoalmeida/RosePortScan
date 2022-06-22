#GitHub: github.com/paixaoalmeida
#Meu primeiro programa em Python, um portscan básico que é baseado numa lista de portas TCP populares
#Comecei dia 26 e enrrolei, dia 03 de Junho dei uma pesquisado num problema e consegui arrumar o timeout etc
#Apenas diz se a porta está aberta e se tiver, passa um banner do serviço rodando na porta
#Ultima alteração dia 03 de Junho ás 17:02
#Alterações minímas no código: dia 19 de junho
#alterações nas saídas do programa e 3 portas adicionadas no array de portas (prod v1.1) (21 de junho)
#-----------------------------------------------------------------------------------------------------------------
#Variáveis

import socket
import sys
import time

ip = sys.argv[1]

listaportas = [20, 21, 22, 23, 25, 80, 110, 139, 143, 194, 443, 445, 3389]
#----------------------------------------------------------------------------------------------------------
#Código do programa

print(f"\033[4;31m----> Escaneando portas no host ----->\033[m {ip}\n")

for portas in listaportas:
    meusocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    meusocket.settimeout(5)  #Timeout para conectar nas portas
    res = meusocket.connect_ex((ip, portas))
    time.sleep(1)

    if res == 0:   #Código 0, socket ativo
        print(f"\033[1;33mPorta {portas} aberta\033[m \n")

        try:
            servico = meusocket.recv(1024)   #Receber dados da porta
            encodado = servico.decode("utf-8")  #Decodando de bytes para utf-8
            print(f"\033[1mServiço rodando na\033[m \033[1;33mporta {portas}\033[m ------> {encodado}\n")
        except:
            print(f"\033[1mSem banner capturado na porta {portas}\033[m \n")
    meusocket.close()

print("\033[1mSem mais portas abertas encontradas!\033[m")


