#!/bin/bash

echo acb
~/labo/ANA/build/ANA2 ../modos/5jpw.pdb -c acb.cfg -M ../modos/5jpw.mods -S scl -F frq_5jpw -Z 5
echo adb
~/labo/ANA/build/ANA2 ../modos/5jpw.pdb -c adb.cfg -M ../modos/5jpw.mods -S scl -F frq_5jpw -Z 5
