#!/bin/bash
curl -s --head http://localhost | grep "200 OK" > /dev/null
