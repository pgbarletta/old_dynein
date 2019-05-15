from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("4_porc.pdb")
cmd.load("modevectors.py")
rgb="0.9247533735460898, 0.9161507204854669, 0.6224288056004166"
modevectors("3fm7", "4_porc", outname="4_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("4_porc")
