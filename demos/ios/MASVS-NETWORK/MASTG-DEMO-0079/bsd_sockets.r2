e scr.color=0
e scr.interactive=false

?e === Searching for BSD socket APIs ===
afl~socket
afl~connect
afl~send
afl~recv

?e
?e === Searching for getaddrinfo (hostname resolution) ===
afl~getaddrinfo

?e
?e === Strings referencing socket operations ===
izz~socket
izz~SOCK_STREAM

?e
?e === Imported symbols for socket operations ===
ii~socket
ii~connect
ii~send
ii~recv
