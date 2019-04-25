#/bin/bash
sleep 30s
http_code=$(curl "http://localhost:81/somefile.php?someparam=../../../etc" -s -f -w %{http_code} -o /dev/null)
if (($http_code == 403)); then echo "We got a $http_code. Our WAF blocked the reqeust, Noice!"; exit 0 ;else echo "We got a $http_code. Our WAF did NOT block the request :("; exit 200; fi