#!/bin/bash

echo acb
~/labo/ANA/build/ANA2 ../modos/1ygt.pdb -c acb.cfg -M ../modos/1ygt.mods -S scl -F frq_1ygt -Z 5
echo adb
~/labo/ANA/build/ANA2 ../modos/1ygt.pdb -c adb.cfg -M ../modos/1ygt.mods -S scl -F frq_1ygt -Z 5
