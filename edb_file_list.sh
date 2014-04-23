#!/bin/bash

echo > edb_file_list.html

(
for (( i = 0 ; i <= 4000; ++i )); do
    # echo processing $i
    curl -I http://sbp.enterprisedb.com/getfile.jsp?fileid=$i > /tmp/edb.getfile
    if ! grep '404 Not Found' /tmp/edb.getfile; then
        link=$(grep 'Location: ' /tmp/edb.getfile | cut -d ' ' -f 2-)
        # Convert download.enterprisedb.com to get.enterprisedb.com
        link=${link/download/get}
        echo '<a href="'$link'">'$link'</a><br>' >> edb_file_list.html
    fi
done
) >/dev/null 2>&1
