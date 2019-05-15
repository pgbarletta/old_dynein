from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("5_porc.pdb")
cmd.load("modevectors.py")
rgb="0.8298316587304213, 0.35604359353637394, 0.6974907465448175"
modevectors("3fm7", "5_porc", outname="5_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("5_porc")
