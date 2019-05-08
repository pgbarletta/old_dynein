import pytraj as pt

trj = pt.load("1xdx.pdb")

avg = pt.mean_structure(trj(autoimage=True, rmsfit = (0, ':20-110@CA')), ':20-110@CA')

with open('avg_1xdx', 'w') as f:
    for item in avg.coordinates:
        print >> f, item
