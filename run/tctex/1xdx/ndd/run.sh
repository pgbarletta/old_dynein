#!/bin/bash

echo acb
~/labo/ANA/build/ANA2 ../modos/1xdx.pdb -c acb.cfg -M ../modos/1xdx.mods -S scl -F frq_1xdx -Z 5
echo adb
~/labo/ANA/build/ANA2 ../modos/1xdx.pdb -c adb.cfg -M ../modos/1xdx.mods -S scl -F frq_1xdx -Z 5
