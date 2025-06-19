#!/bin/bash

banner()
{
	echo "Selecione o ataque a ser detectado: "
	echo "1. Analisar ataques de XSS."
	echo "2. Analisar ataques de SQL Injection."
	echo "3. Analisar ataques de Directory Traversal."
	echo "4. Analisar User-Agents suspeitos."
	echo "5. Analisar tentativas de acesso a arquivos sensíveis."
	echo "6. Analisar possíveis ataques de força bruta"
	echo "7. Analisar primeiro e último acesso de IP suspeito."
	echo "8. Analisar User-Agent utilizado por um IP suspeito."
	echo "9. Listar IPs e verificar número de requisições."
	echo "10. Localizar acesso a um determinado arquivo sensível."
}

banner

read -r detect
case $detect in
	1 ) 
		grep -iE "<script%3Cscript" access.log
		;;
	2 )
		grep -iE "union|select|insert|drop|%27|%22" access.log
		;;
	3 )
		grep -E "\.\./|\.\.%2f" access.log
		;;
	4 )
		grep -iE "nikto|nmap|sqlmap|acunetix|curl|masscan|python" access.log
		;;
	5 )
		grep -iE "\.env|\.git|\.htaccess|\.bak" access.log
		;;
	6 )
		grep " 404 " access.log | cut -d " " -f 1 | sort | uniq -c | sort -nr | head
		;;
	7 )
		grep "IP" access.log | head -n1
		grep "IP" access.log | tail -n1
		;;
	8 )
		grep "IP_SUSPEITO" access.log | cut -d '"' -f 6 | sort | uniq
		;;
	9 )
		cat access.log | cut -d " " -f 1 | sort | uniq -c
		;;
	10)	
		grep "arquivosensivel" access.log
		;;
	esac
