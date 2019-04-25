#/bin/bash
sleep 30s
http_code=$(curl "http://localhost:81/somefile.php?someparam=../../../etc" -s -f -w %{http_code} -o /dev/null)
if (($http_code == 40)); then exit 0 ;else echo "$http_code"; exit 200; fi