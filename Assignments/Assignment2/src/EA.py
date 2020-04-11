# This file related to the implementation of the evolutionary algorithm
import utils
from tqdm import tqdm


class EA:
    def __init__(self, input_img):
        self.input_img = input_img
        self.current_img = self.gen_initial_img()
        self.threshold = None   # To be chosen, the threshold that the fitness score is acceptable
        self.progress_imgs = []

    # Generate the initial image
    def gen_initial_img(self):
        return 0
        
    def mutation(self):
        pass

    def crossover(self):
        pass
    
    # This is the fitness function that return how close the input image
    def fitness(self):
        return 0

    # The impelmentation of the algorithm
    def run(self):
        output_img = []
        self.progress_imgs.append([])   # With every iteration
        return self.progress_imgs, output_img
    
if __name__ == "__main__":
    pass