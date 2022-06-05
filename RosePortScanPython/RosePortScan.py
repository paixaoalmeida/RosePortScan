#Meu primeiro programa em Python, um portscan básico que é baseado numa lista de portas TCP populares
#Comecei dia 26 e enrrolei, dia 03 de Junho dei uma pesquisado num problema e consegui arrumar o timeout etc
#Apenas diz se a porta está aberta e se tiver, passa um banner do serviço rodando na porta
#GitHub: github.com/paixaoalmeida
#Todo o código está comentado pois preciso lembrar das coisas mais básicas!
#Ultima alteração dia 03 de Junho ás 17:02


import socket
import sys
import time

ip = sys.argv[1]

listaportas = [20, 21, 22, 23, 25, 80, 110, 139, 443, 445]  #Lista para as portas

print("O script tem um intervalo de 10 segundos em cada porta! \n")
for portas in listaportas:  #For loop para ler a lista e fazer as conexões
    meusocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)   #biblioteca socket
    meusocket.settimeout(10)  #Timeout para conectar nas portas (p nao ficar eternamente tentando conectar)
    res = meusocket.connect_ex((ip, portas))  #Conetar o socket no host desejado, modo TCP, endereço e porta
    time.sleep(10)    #No For loop vai dar um sleep de 10 sec, para tentar evitar ser bloqueado

    if (res == 0):   #Se for 0 então a porta está ativa
        print("Porta" ,portas, "Aberta \n")

        try:
            servico = meusocket.recv(1024)   #Receber a resposta (no caso o banner da porta)
            encodado = servico.decode("utf-8")  #Decodando a variavel de bytes para string, saida sem sujeira!
            print(f"Serviço rodando na porta {portas} ------> {encodado} \n")
        except:
            print(f"Sem banner capturado na porta {portas} \n")
meusocket.close()
print("Sem mais portas abertas encontradas!")


