#/bin/bash
if (($(curl "http://localhost:81/somefile.php?someparam=../../../etc" -s -f -w %{http_code} -o /dev/null)  == 403)); then echo "Request blocked by WAF, Noice!" ;else exit 1; fi