from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("8_porc.pdb")
cmd.load("modevectors.py")
rgb="0.9929474972828216, 0.6172792578628397, 0.4136955351840892"
modevectors("3fm7", "8_porc", outname="8_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("8_porc")
