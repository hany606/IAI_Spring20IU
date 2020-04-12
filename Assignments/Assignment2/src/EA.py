# This file related to the implementation of the evolutionary algorithm
import utils
import numpy as np
from tqdm import tqdm


class EA:
    def __init__(self, input_img):
        self.input_img = input_img
        self.current_population = self.generate_population()
        self.threshold = None   # To be chosen, the threshold that the fitness score is acceptable
        self.progress_imgs = []
        self.num_iterations = 100
        self.population_size = 50

    # Generate the initial image
    def generate_population(self, parent=None):
        if(parent is None):
            return 0    # Totally random population
        else:
            return 0    # According to the parent

    # This is the fitness function that return how close the input image
    def fitness(self):
        # Sum the color difference for every pixel.
        return 0

    def selection(self, scores):
        # Sort and select the best ##
        self.progress_imgs.append([])
        pass

    def mutation(self):
        pass

    def crossover(self):
        pass


    def termination(self):
        scores = self.fitness()
        mx, argmx = max(scores), np.argmax(scores)
        if(self.threshold > mx):
            return (True,argmx)
        return (False,None)

    # The impelmentation of the algorithm
    def train(self):
        self.output_img = None
        for i in tqdm(range(self.num_iterations)):
            print("#{:} iteration".format(i+1))
            scores = self.fitness()
            self.selection(scores)
            self.crossover()
            self.mutation()
            termination = self.termination()
            if(termination[0]):
                self.output_img = self.current_population[termination[1]]
            self.current_population = self.generate_population(parent=self.current_population)            
        return self.progress_imgs, self.output_img
    
if __name__ == "__main__":
    pass