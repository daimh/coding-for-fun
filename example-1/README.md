# run it
```
make
```

# description
This program generate a test web server at localhost:8000, and then generate 1024 small files under it.

Then 'client.sh' takes the 1024 urls as input, download them in parallel, and save the result to to a hash table "result", and also prints it.

