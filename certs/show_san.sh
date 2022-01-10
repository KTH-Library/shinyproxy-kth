#!/bin/bash

openssl x509 -in $1 -noout -text | grep "Subject Alternative Name" -A2


