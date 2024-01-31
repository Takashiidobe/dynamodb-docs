#!/usr/bin/env bash

for f in $(cat links.txt); do
  curl $f -L -O
done
