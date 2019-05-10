from modeller import *
from modeller.automodel import *    # Load the automodel class

log.verbose()
env = environ()

# directories for input atom files
env.io.atom_files_directory = ['.', '../atom_files']

class MyModel(automodel):
	def select_atoms(self):
		return selection(self.residue_range('68', '100'),
                        self.residue_range('208', '240'))


a = MyModel(env, alnfile = '/home/pbarletta/labo/19/dynein/data/tctex_pdbs/model/5hxl/to_model',
	knowns = 'pro_5hxl', sequence = 'model_5hxl',
	assess_methods=(assess.DOPE,
		assess.GA341))
a.starting_model= 1
a.ending_model  = 50

a.make()
