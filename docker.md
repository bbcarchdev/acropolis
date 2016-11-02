```
                                  _ _     
                                 | (_)    
  __ _  ___ _ __ ___  _ __   ___ | |_ ___ 
 / _` |/ __| '__/ _ \| '_ \ / _ \| | / __|
| (_| | (__| | | (_) | |_) | (_) | | \__ \
 \__,_|\___|_|  \___/| .__/ \___/|_|_|___/
                     | |                  
                     |_|                  
```
                  
This image does not run any service by default.

# Services

Here are the different services you can run. You may run them all individualy
or use supervisord which is pre-configured to run an instance of each of them.
You can also use docker-compose to have each service running in a dedicated
container.

## Spindle processing engine (you can start multiple of those)
```
/usr/sbin/twine-writerd -d -c /usr/etc/twine.conf -f
```

## Web crawler Anansi
```
/usr/sbin/crawld -d -c /usr/etc/crawl.conf -f
```

## Connection between Anansi and Spindle
```
/usr/sbin/twine-writerd -d -c /usr/etc/twine-anansi.conf -f
```

## Linked Data frontend
```
/usr/sbin/apache2 -D FOREGROUND
```

## Remote control for externaly ingesting data via HTTP (used by Cucumber)
```
/usr/bin/python3 /usr/local/src/docker/remote.py
```

# Usage 

## Ingesting some data as a dump
To ingest a NQuads dump do
```
/usr/bin/twine -d -c /usr/etc/twine.conf dump.nq
```
This bypass Anansi and schedule a payload ready to be processed by the 
processing engine Spindle (via the workflow engine Twine)

## Adding a URI to the queue
```
/usr/bin/crawler-add -c /usr/etc/crawl.conf http://example.org
```


