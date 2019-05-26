#!/bin/bash

echo acb
~/labo/ANA/build/ANA2 ../modos/5wi4.pdb -c acb.cfg -M ../modos/5wi4.mods -S scl -F frq_5wi4 -Z 5
echo adb
~/labo/ANA/build/ANA2 ../modos/5wi4.pdb -c adb.cfg -M ../modos/5wi4.mods -S scl -F frq_5wi4 -Z 5
