O SCRIPT FOI FEITO PARA AUTOMAÇÕES DE PADRONIZAÇÃO DOS COMPUTADORES DA EMPRESA. 

GARANTINDO RAPIDEZ E EFICÁCIA EM TODAS AS FORMATAÇÕES. 

Como fazer a implementação do script para padronização de máquinas novas com o sistema operacional Linux Mint Cinnamon.



Tendo a pasta aberta no terminal rode os comandos:
sudo chmod +x main.sh
Esse comando serve para dar permissão de execução para o arquivo main.sh através das permissões de administrador.
sudo ./main.sh
Esse comando serve para executar o arquivo com permissões de administrador.
O script irá começar a rodar, e lhe dará opções de procedimentos. 

1. Padronizar 
Ele começará a padronizar a máquina, deixando-a pronta para qualquer colaborador que for usar 

2. CID 
Faz a instalação do CID, o CID é utilizado para inserir a máquina no AD, permitindo que cada um acesse com o seu usuário do sistema. 

3. WINE
Faz a instalação completa do Wine, utilizamos essa ferramenta para executar o baldussi. 

4. OCS
Implementa o computador no OCS Inventory, nos permitindo inventariar cada computador e assim mantendo um controle. 

5. FONTES
Faz a instalação de todas as fontes e tipografias necessárias no computador. 

6. INSTALAR USBguard
O USBguard faz a implementação de um sistema de segurança onde não é possível adicionar nenhum USB externo ou algum plug malicioso. 

7. REMOVER USBguard 
Faz a remoção do sistema de segurança. 

8. APLICAR O SKEL
Todo o esqueleto e configurações do usuário são copiadas e coladas para todos os outros usuários do computador. 

9. REMOVER SOFTWARES ANTIGOS
Remove os softwares instalados pelo script antigo e padroniza na versão mais atual que possuímos.
10. INSTALAR O DRIVE PARA A IMPRESSORA M4020
Instala o driver de uma impressora específica, só é necessário em alguns casos. 

11.CORRIGIR AUTENTICAÇÃO DO KERBEROS PARA A IMPRESSÃO VIA SAMBA
Corrige o problema de autenticação ao tentar imprimir. 

12. REMOVER DESCANSO DE TELA

PADRONIZAÇÃO

Como dito acima, clique na opção 1. 
Ele irá pedir para informar o usuário. É só colocar nome.sobrenome como por exemplo o meu nome: victor.jaber  
Logo depois, irá pedir para apertar o enter e ler o contrato, desça tudo e aceite o contrato com o Y e aperte enter novamente. 

A configuração do ocs está no tópico abaixo. 

Ao configurar a autenticação via Kerberos digite jati.local e pressione enter. Nas 3 vezes que aparecer. Ele vai pedir a senha do usuário do domínio, por exemplo a minha senha. 

Por fim, digite a senha do root também, que é a senha H padrão.
Durante a execução do script será necessário realizar um procedimento manual da configuração do OCS inventory, segue um passo a passo para a configuração correta dele:


CONFIGURANDO O OCS
No meio do script de padronização você terá de configurar o OCS, então quando chegar nessas perguntas, responda de acordo abaixo: 

Do you want to configure the agent? 
	> Digite: y [Enter]

Should the old unix_agent settings be imported ?

	> Digite: n [Enter]

What is the address of your ocs server?

> Digite: http://192.168.0.250/ocsinventory [Enter]  

Do you need credential for the server? (You probably don't)

	> Digite: n [Enter]

Do you want to apply an administrative tag on this machine?

	> Digite: n [Enter]

Do you want to install the cron task in /etc/cron.d

	> Digite: y [Enter]

Where do you want the agent to store its files? (You probably don't need to change it)?

	> Digite: /var/lib/ocsinventory-agent [Enter]

Should I remove the old unix_agent

	> Digite: y [Enter]

Do you want to activate debug configuration option ?

	> Digite: n [Enter]

Do you want to use OCS Inventory NG UNix Unified agent log file ?

	> Digite: n [Enter]

Do you want disable SSL CA verification configuration option (not recommended) ?

	> Digite: n [Enter]

Do you want to set CA certificate chain file path ?

	> Digite: n [Enter]

Do you want disable software inventory?

> Digite: n [Enter]

Do you want to use OCS-Inventory software deployment feature?

	> Digite: y [Enter]
Do you want to send an inventory of this machine?
	> Digite: y [Enter]

