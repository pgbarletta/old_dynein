from pymol import cmd


cmd.load("proto_3flf.pdb")
cmd.load("proto_3flb.pdb")

cmd.load("nrot_1xdx.pdb")
cmd.load("nrot_1ygt.pdb")
cmd.load("nrot_2plf.pdb")
cmd.load("nrot_2plb.pdb")
cmd.load("nrot_5jpw.pdb")
cmd.load("nrot_5vky.pdb")
cmd.load("nrot_5wlf.pdb")
cmd.load("nrot_5wlb.pdb")

cmd.align("nrot_1xdx", "proto_3flf")
cmd.align("nrot_1ygt", "proto_3flf")
cmd.align("nrot_2plf", "proto_3flf")
cmd.align("nrot_2plb", "proto_3flb")
cmd.align("nrot_5jpw", "proto_3flf")
cmd.align("nrot_5vky", "proto_3flf")
cmd.align("nrot_5wlf", "proto_3flf")
cmd.align("nrot_5wlb", "proto_3flb")


cmd.save("proto_1xdx.pdb", "nrot_1xdx")
cmd.save("proto_1ygt.pdb", "nrot_1ygt")
cmd.save("proto_5jpw.pdb", "nrot_5jpw")
cmd.save("proto_5vky.pdb", "nrot_5vky")

cmd.save("proto_5wlf.pdb", "nrot_5wlf")
cmd.save("proto_5wlb.pdb", "nrot_5wlb")

cmd.save("proto_2plf.pdb", "nrot_2plf")
cmd.save("proto_2plb.pdb", "nrot_2plb")

cmd.save("proto_3flf.pdb", "proto_3flf")
cmd.save("proto_3flb.pdb", "proto_3flb")
