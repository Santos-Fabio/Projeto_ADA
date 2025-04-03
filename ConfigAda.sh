
#Configuração do Roteador

enable
configure terminal

#========== GENERAL CONFIGURATION ==========
hostname R1
no ip domain-lookup
service password-encryption
banner motd ^Acesso Restrito - Rede Corporativa^

#========== SECURITY ==========
enable secret ada123
username admin privilege 15 secret ada123
line console 0
 password ada123
 login local
 logging synchronous
 exit
line vty 0 4
 transport input ssh
 login local
 exit

#========== VLAN CONFIGURATION ==========
vlan 999
 name NATIVE_UNUSED
 exit

vlan 10
 name TI
 exit
vlan 20
 name HELPDESK
 exit
vlan 30
 name RH
 exit
vlan 40
 name INOVACAO
 exit
vlan 50
 name VENDAS
 exit
vlan 60
 name GERENCIA
 exit

#========== TRUNK PORTS (TO SWITCHES) ==========
interface range FastEthernet1/0 - 5
 switchport trunk encapsulation dot1q
 switchport mode trunk
 switchport trunk native vlan 999
 switchport trunk allowed vlan 1-2,10,20,30,40,50,60,1002-1005
 no shutdown
 exit

#Department-specific trunk adjustments
interface FastEthernet1/0
 description TRUNK-TI
 switchport trunk allowed vlan 1-2,10,1002-1005
 exit

interface FastEthernet1/1
 description TRUNK-HELPDESK
 switchport trunk allowed vlan 1-2,20,1002-1005
 exit

interface FastEthernet1/2
 description TRUNK-RH
 switchport trunk allowed vlan 1-2,30,1002-1005
 exit

interface FastEthernet1/3
 description TRUNK-INOVACAO
 switchport trunk allowed vlan 1-2,40,1002-1005
 exit

interface FastEthernet1/4
 description TRUNK-VENDAS
 switchport trunk allowed vlan 1-2,50,1002-1005
 exit

interface FastEthernet1/5
 description TRUNK-GERENCIA
 switchport trunk allowed vlan 1-2,60,1002-1005
 exit


interface FastEthernet1/6
 description Servidor - Externo
 no switchport
 ip address 152.132.30.2 255.255.255.248
 no shutdown
 exit


#========== LAYER 3 CONFIGURATION ==========
interface Vlan10
 description TI
 ip address 10.100.0.1 255.255.255.128
 no shutdown
 exit

interface Vlan20
 description HELPDESK
 ip address 10.100.0.129 255.255.255.128
 no shutdown
 exit

interface Vlan30
 description RH
 ip address 10.100.1.1 255.255.255.192
 no shutdown
 exit

interface Vlan40
 description INOVACAO
 ip address 10.100.2.1 255.255.255.0
 no shutdown
 exit

interface Vlan50
 description VENDAS
 ip address 10.100.6.1 255.255.254.0
 no shutdown
 exit

interface Vlan60
 description GERENCIA
 ip address 10.100.5.1 255.255.255.192
 no shutdown
 exit

#========== WAN INTERFACE ==========
interface FastEthernet1/6
 description LINK-EXTERNO
 no switchport
 ip address 152.132.30.2 255.255.255.248 
 #ip nat outside
 no shutdown
 exit

#end
#write memory


#Estava dando problema nas portas, pois não as vinculava, isso resolve
#configure terminal

#TI VLAN (10)
interface FastEthernet1/0
 switchport mode access
 switchport access vlan 10
 no shutdown
 exit

#Helpdesk VLAN (20)
interface FastEthernet1/1
 switchport mode access
 switchport access vlan 20
 no shutdown
 exit

#RH VLAN (30)
interface FastEthernet1/2
 switchport mode access
 switchport access vlan 30
 no shutdown
 exit

#Inovação VLAN (40)
interface FastEthernet1/3
 switchport mode access
 switchport access vlan 40
 no shutdown
 exit

#Vendas VLAN (50)
interface FastEthernet1/4
 switchport mode access
 switchport access vlan 50
 no shutdown
 exit

#Gerência VLAN (60)
interface FastEthernet1/5
 switchport mode access
 switchport access vlan 60
 no shutdown
 exit

#end
#write memory
#======================================================================
#Configuração NAT
#configure terminal

#interface FastEthernet1/6
#no switchport
#ip address 152.132.30.2 255.255.255.148
# no shutdown
# exit
#ip route 0.0.0.0 0.0.0.0 152.132.30.1

#ip access-list standard NAT-ACL
# permit 10.100.0.0 0.0.15.255
# exit
#ip nat inside source list NAT-ACL interface FastEthernet1/6 overload

#limpando configurações existentes
no ip nat inside source list NAT-ACL interface FastEthernet1/6 overload
no ip nat inside source list NAT_TRAFFIC interface FastEthernet1/6 overload
no ip access-lis standard NAT_TRAFFIC
#Configurando
ip access-list standard NAT_TRAFFIC
permit 10.100.0.0 0.0.255.255
exit

ip nat inside source list NAT_TRAFFIC interface FastEthernet1/6 overload

interface vlan10
 ip nat inside
 no shutdown
 exit

interface vlan20
 ip nat inside
 no shutdown
 exit
interface vlan30
 ip nat inside
 no shutdown
 exit
interface vlan40
 ip nat inside
 no shutdown
 exit
interface vlan50
 ip nat inside
 no shutdown
 exit
interface vlan60
 ip nat inside
 no shutdown
 exit

interface FastEthernet1/6
 ip nat outside
 no shutdown
 exit

end
write memory


#Configs VPCs
#TI
# VPCS 1
ip 10.100.0.2/25 10.100.0.1
save
# VPCS 2
ip 10.100.0.3/25 10.100.0.1
save
# VPCS 3
ip 10.100.0.4/25 10.100.0.1
save
# VPCS 4
ip 10.100.0.126/25 10.100.0.1
save

#Helpdesk
# VPCS 1
ip 10.100.0.130/25 10.100.0.129
save
# VPCS 2
ip 10.100.0.131/25 10.100.0.129
save
# VPCS 3
ip 10.100.0.132/25 10.100.0.129
save
# VPCS 4
ip 10.100.0.250/25 10.100.0.129
save

#RH
# VPCS 1
ip 10.100.1.2/26 10.100.1.1
save
# VPCS 2
ip 10.100.1.3/26 10.100.1.1
save
# VPCS 3
ip 10.100.1.4/26 10.100.1.1
save
# VPCS 4
ip 10.100.1.42/26 10.100.1.1
save

#Inovação
# VPCS 1
ip 10.100.2.2/24 10.100.2.1
save
# VPCS 2
ip 10.100.2.3/24 10.100.2.1
save
# VPCS 3
ip 10.100.2.4/24 10.100.2.1
save
# VPCS 4
ip 10.100.2.52/24 10.100.2.1
save

#Vendas
# VPCS 1
ip 10.100.6.2/23 10.100.6.1
save
# VPCS 2
ip 10.100.6.3/23 10.100.6.1
save
# VPCS 3
ip 10.100.6.4/23 10.100.6.1
save
# VPCS 4
ip 10.100.7.254/23 10.100.6.1
save

#Gerencia
# VPCS 1
ip 10.100.5.2/26 10.100.5.1
save
# VPCS 2
ip 10.100.5.3/26 10.100.5.1
save
# VPCS 3
ip 10.100.5.4/26 10.100.5.1
save
# VPCS 4
ip 10.100.5.62/26 10.100.5.1
save