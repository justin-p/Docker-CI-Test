#/bin/bash
sleep 2m
if (($(curl "http://localhost:81/somefile.php?someparam=../../../etc" -s -f -w %{http_code} -o /dev/null)  == 403)); then exit 0 ;else exit 200; fi