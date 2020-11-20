#!/bin/sh

i=`kubectl get svc | grep pyweb-service | awk '{print $4}'`
z="$i:5000"
echo {\"ip\":\"$z\"}
