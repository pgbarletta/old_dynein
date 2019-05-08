import pytraj as pt

trj = pt.load("5jpw.pdb")

avg = pt.mean_structure(trj(autoimage=True, rmsfit = (0, ':21-111@CA')), ':21-111@CA')

with open('avg_5jpw', 'w') as f:
    for item in avg.coordinates:
        print >> f, item
