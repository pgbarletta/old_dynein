#!/bin/bash

echo acb
~/labo/ANA/build/ANA2 ../modos/2ptt.pdb -c acb.cfg -M ../modos/2ptt.mods -S scl -F frq_2ptt -Z 5
echo adb
~/labo/ANA/build/ANA2 ../modos/2ptt.pdb -c adb.cfg -M ../modos/2ptt.mods -S scl -F frq_2ptt -Z 5
