How to run it:

dido@debian:~$ git clone git@github.com:deqnstoqnov/collision_detection.git
dido@debian:~$ cd collision_detection
dido@debian:~/collision_detection$ erlc *.erl
dido@debian:~/collision_detection$ erl
Erlang R15B01 (erts-5.9.1) [source] [64-bit] [smp:2:2] [async-threads:0] [kernel-poll:false]

Eshell V5.9.1  (abort with ^G)
1> c(ignite). 
{ok,ignite}
2> ignite:start().
