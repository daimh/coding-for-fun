client : server
	./client.sh < $<.urls

server :
	-fuser -k 8000/tcp
	rm -rf $@.d
	mkdir -p $@.d
	cd $@.d && seq 1024 | split --numeric-suffixes=1 -l 1 -a 4
	ls $@.d | sed "s@^@http://localhost:8000/@" > $@.urls
	cd $@.d && python -m http.server 8000 &
	sleep 1
