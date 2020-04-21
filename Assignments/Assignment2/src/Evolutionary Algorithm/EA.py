# This file related to the implementation of the evolutionary algorithm
import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

import numpy as np
from tqdm import tqdm
import random


class EA:
    def __init__(self, input_img, small_imgs_assets_path="../../assets/mnist_png/mnist_png/testing/All_resized8x8/", small_imgs_num=10000):
        self.input_img = utils.to_numpy(input_img)
        self.threshold = 100   # To be chosen, the threshold that the fitness score is acceptable
        self.progress_imgs = []
        self.num_iterations = 100
        self.population_size = 50
        self.selection_percentage = 0.2

        # Configurations for the small images
        self.max_index_imgs = 10000
        self.size_imgs = (64,64)

        self.imgs = utils.read_small_imgs(assets_dir=small_imgs_assets_path, size=small_imgs_num)

        self.current_population = self._generate_population()

    # Generate the initial image
    def _generate_population(self, parent=None):
        # Totally random population
        population = []
        if(parent is None):
            for _ in range(self.population_size):
                chromosome_indexes = np.random.randint(self.max_index_imgs, size=self.size_imgs)
                chromosome_img = utils.Image(imgs=self.imgs, index=chromosome_indexes)
                # img = chromosome_img.construct_img()
                img = chromosome_img
                population.append({"img": img, "score": -1})
        # According to the parent
        else:
            population = None    

        return population

    # This is the fitness function that return how close the input image
    def _fitness_single(self, img_np):
        rows, cols = img_np.shape
        score = 0
        # print(img_np[0,1], self.input_img[0,1])
        for r in range(rows):
            for c in range(cols):
                score += abs(img_np[r,c] - int(self.input_img[r,c]))
        # if(score < self.min_score):
        #     self.min_score = score
        #     self.min_arg_score = i
        return score

    def _fitness(self, population=None):
        print("----------------------- Fitness -----------------------")
        # self.min_score = 255*512*512    # The largest value that could be
        # self.min_arg_score = 0
        # Sum the color difference for every pixel.
        for i,img_dict in enumerate(self.current_population):
            img = img_dict["img"].construct_img()
            score = self._fitness_single(img)
            img_dict["score"] = score
        print("--------------------------------------------------------")


    def _selection(self):
        print("----------------------- Selection -----------------------")
        # Sort and select the best ##
        # print(self.current_population)
        self.current_population = sorted(self.current_population, key=lambda img: img["score"])
        # print("----------------------------")
        # print(self.current_population)
        population_limit = int(self.selection_percentage * len(self.current_population))
        self.current_population = self.current_population[:population_limit]
        print("--------------------------------------------------------")


    def _crossover(self):
        print("----------------------- CrossOver -----------------------")
        offspring = []
        population_size_missed = int((self.population_size - len(self.current_population)))
        for i in range(population_size_missed):
            parent1 = random.choice(self.current_population)["img"]
            parent2 = random.choice(self.current_population)["img"]
            child = {"img":utils.Image(imgs=self.imgs), "score":-1}
            
            threshold = np.random.uniform(0,1)

            child_indexes = []
            old_child_indexes = child_indexes
            size = parent1.get_index().shape
            rows_mid = size[0]//2
            cols_mid = size[1]//2
            # print(threshold)
            # The 1st half is from 1st half parent1, the 2nd half is from 2nd half of parent2
            # if(threshold < 0.125):
            if(threshold <= 1):
                print("1")
                print("###############")
                # BUG BUG BUG
                child_indexes = np.concatenate((parent1.get_index()[:rows_mid,:cols_mid],parent2.get_index()[rows_mid:,cols_mid:]))
                # for r in range(rows_mid):
                #     for c in range(cols_mid):
                #         child_indexes[rows_mid+r][cols_mid+c] = parent2.get_index()[rows_mid+r][cols_mid+c]

                print("###############")
                print(parent1.get_index()[0])
                print(parent1.get_index()[-1])
                print(parent2.get_index()[-1])
                print(child_indexes[-1])
            # The 1st half is from 2nd half parent1, the 2nd half is from 1st half of parent2
            elif(threshold < 0.25):
                print("2")
                child_indexes[rows_mid:,cols_mid:] = parent1.get_index()[:rows_mid,cols_mid]
                child_indexes[:rows_mid,:cols_mid] = parent2.get_index()[rows_mid:,cols_mid:]


            # The 1st half is from 2nd half parent2, the 2nd half is from 1st half of parent1
            elif(threshold < 0.375):
                print("3")
                child_indexes[:rows_mid,:cols_mid] = parent2.get_index()[rows_mid:,cols_mid:]
                child_indexes[rows_mid:,cols_mid:] = parent1.get_index()[:rows_mid,:cols_mid]

            # The 1st half is from 1st half parent2, the 2nd half is from 2nd half of parent1
            elif(threshold < 0.5):
                print("4")
                child_indexes[:rows_mid,:cols_mid] = parent2.get_index()[:rows_mid,:cols_mid]
                child_indexes[rows_mid:,cols_mid:] = parent1.get_index()[rows_mid:,cols_mid:]

            # The 1st half is from 2nd half parent1, the 2nd half is from 2nd half of parent2
            elif(threshold < 0.625):
                print("5")
                child_indexes[:rows_mid,:cols_mid] = parent1.get_index()[rows_mid:,cols_mid:]
                child_indexes[rows_mid:,cols_mid:] = parent2.get_index()[rows_mid:,cols_mid:]

            # The 1st half is from 1st half parent1, the 2nd half is from 1st half of parent2
            elif(threshold < 0.75):
                print("6")
                child_indexes[:rows_mid,:cols_mid] = parent2.get_index()[rows_mid:,cols_mid:]
                child_indexes[rows_mid:,cols_mid:] = parent1.get_index()[:rows_mid,:cols_mid]

            # The 1st half is from 2nd half parent2, the 2nd half is from 2nd half of parent1
            elif(threshold < 0.875):
                print("7")
                child_indexes[:rows_mid,:cols_mid] = parent2.get_index()[rows_mid:,cols_mid:]
                child_indexes[rows_mid:,cols_mid:] = parent1.get_index()[rows_mid:,cols_mid:]

            # The 1st half is from 1st half of parent2, the 2nd half is from 1st half of parent1            
            else:
                print("8")
                child_indexes[:rows_mid,:cols_mid] = parent2.get_index()[:rows_mid,:cols_mid]

            child["img"].set_index(child_indexes)
            child["score"] = self._fitness_single(child["img"].construct_img())
            
            print("################")
            print(child_indexes[-1])
            # Error child indexes is not changing
            s = 0
            for i in range(len(child_indexes)):
                s += abs(child_indexes[i]-old_child_indexes[i])
                # s += abs(parent1.get_index()[i]-parent2.get_index()[i])
            print("s=",s)
            
            utils.preview_img(utils.to_img(parent1.construct_img()), title="parent1")
            input()
            utils.preview_img(utils.to_img(parent2.construct_img()), title="parent2")
            input()
            utils.preview_img(utils.to_img(child["img"].construct_img()), title="child")
            input()
            offspring.append(child)

        self.current_population.extend(offspring)

        print("--------------------------------------------------------")


    def _mutation(self):
        print("----------------------- Mutation -----------------------")
        print("--------------------------------------------------------")

    def _termination(self):
        print("----------------------- Termination -----------------------")
        self.min_score = 255*512*512    # The largest value that could be
        self.min_arg_score = 0
        for i,img_dict in enumerate(self.current_population):
            score = img_dict["score"]
            if(score < self.min_score):
                self.min_score = score
                self.min_arg_score = i
        mn, argmn = self.min_score, self.min_arg_score
        # print(argmn, mn)
        print("--------------------------------------------------------")
        if(self.threshold > mn):
            return (True,argmn)
        return (False,argmn)

    # The impelmentation of the algorithm
    def train(self):
        self.output_img = None

        for _ in tqdm(range(self.num_iterations)):
            # print("#{:} iteration".format(i+1))
            self._fitness()
            self._selection()
            self._crossover()
            self._mutation()
            termination = self._termination()
            if(termination[0]):
                self.output_img = utils.to_img(self.current_population[termination[1]]["img"].construct_img())
                self.progress_imgs.append(self.output_img)
                print("## Termination satisfied ")
                break
            mn_img_raw = self.current_population[termination[1]]["img"]
            # print(mn_img_raw.get_index())
            mn_img_np = mn_img_raw.construct_img()
            mn_img = utils.to_img(mn_img_np)
            self.output_img = mn_img
            # utils.preview_img(mn_img)
            self.progress_imgs.append(mn_img)
            # self.current_population = self._generate_population(parent=self.current_population)
        return self.progress_imgs, self.output_img
    
if __name__ == "__main__":
    pass