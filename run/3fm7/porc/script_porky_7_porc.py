from pymol.cgo import *
from pymol import cmd

cmd.load("3fm7.pdb")
cmd.load("7_porc.pdb")
cmd.load("modevectors.py")
rgb="0.06816170560164614, 0.4638332230012048, 0.006044402968299556"
modevectors("3fm7", "7_porc", outname="7_porc_porky", head=0.5, tail=0.3, headrgb = rgb, tailrgb = rgb, cutoff=3.0)
cmd.delete("7_porc")
