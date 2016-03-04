#!/bin/bash
rm nohup.out
javac LoadGenForMixApp.java
nohup java LoadGenForMixApp &

exit 0
