e scr.color=0
e scr.interactive=false

?e === Searching for Network framework (NWConnection) usage ===
afl~NWConnection

?e
?e === Searching for CFNetwork/CFSocket APIs ===
afl~CFSocket
afl~CFStream
afl~CFHTTPStream

?e
?e === Strings referencing Network framework ===
izz~NWConnection
izz~NWParameters
izz~Network.framework

?e
?e === Imported symbols from Network framework ===
ii~Network
