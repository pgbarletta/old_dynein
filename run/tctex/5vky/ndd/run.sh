#!/bin/bash

echo acb
~/labo/ANA/build/ANA2 ../modos/5vky.pdb -c acb.cfg -M ../modos/5vky.mods -S scl -F frq_5vky -Z 5
echo adb
~/labo/ANA/build/ANA2 ../modos/5vky.pdb -c adb.cfg -M ../modos/5vky.mods -S scl -F frq_5vky -Z 5
