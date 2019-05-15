#!/bin/bash

echo acb
~/labo/ANA/build/ANA2 ../modos/3ftt.pdb -c acb.cfg -M ../modos/3ftt.mods -S scl -F frq_3ftt -Z 5
echo adb
~/labo/ANA/build/ANA2 ../modos/3ftt.pdb -c adb.cfg -M ../modos/3ftt.mods -S scl -F frq_3ftt -Z 5
