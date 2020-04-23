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
    def __init__(self, input_img, small_imgs_assets_path="../../assets/mnist_png/mnist_png/testing/All_resized8x8/", small_imgs_num=10000, format_str=None):
        self.input_img = utils.to_numpy(input_img)
        self.threshold = 100   # To be chosen, the threshold that the fitness score is acceptable
        self.progress_imgs = []

        # Parameters to be tuned
        self.num_iterations = 100   # 100
        self.population_size = 50     # 50
        self.selection_percentage = 0.2   # 0.2
        self.crossover_percentage = (0.5,0.5)   # ((row, col) in case of two parents
        self.crossover_num_parents = 2  # Not implemented for now for crossover with multiple parent
        self.mutation_probability = 0.2

        self.img_size = (512,512)


        self.imgs = utils.read_small_imgs(assets_dir=small_imgs_assets_path, num=small_imgs_num, format_str=format_str)
        self.imgs = np.array(self.imgs)
        self.small_img_shape = self.imgs.shape[1:]
        # Configurations for the small images
        self.max_index_imgs = small_imgs_num
        self.small_imgs_num_rc = tuple([self.img_size[0]//self.small_img_shape[0], self.img_size[1]//self.small_img_shape[1]])


        self.current_population = self._generate_population()

    def calc_error(self, input_img, gen_img):
        shape = input_img.shape
        error = 0 
        for r in range(shape[0]):
            for c in range(shape[1]):
                for l in range(shape[2]):
                    loc_error = ((float(input_img[r][c][l]) - float(gen_img[r][c][l]))**2)/(shape[0]*shape[1]*shape[2])
                    # print(loc_error)
                    error += loc_error
        # print(error)
        return error

    # Generate the initial image
    def _generate_population(self, parent=None):
        # Totally random population
        population = []
        if(parent is None):
            for _ in range(self.population_size):
                chromosome_indexes = np.random.randint(self.max_index_imgs, size=self.small_imgs_num_rc)
                chromosome_img = utils.Image(imgs=self.imgs, index=chromosome_indexes, imgs_shape=self.small_img_shape)
                # img = chromosome_img.construct_img()
                img = chromosome_img
                population.append({"img": img, "score": -1})
        # According to the parent
        else:
            population = None    

        return population

    # This is the fitness function that return how close the input image
    def _fitness_single(self, img_np):
        rows, cols, channels = img_np.shape
        score = 0
        # print(img_np[0,1], self.input_img[0,1])
        for r in range(rows):
            for c in range(cols):
                for l in range(channels):
                    loc_score = ((float(img_np[r][c][l]) - float(self.input_img[r][c][l]))**2)/(rows*cols*channels)
                    # print(loc_error)
                    score += loc_score
        # if(score < self.min_score):
        #     self.min_score = score
        #     self.min_arg_score = i
        return score

    def _fitness(self, population=None):
        print("----------------------- Fitness -----------------------")
        # self.min_score = 255*512*512    # The largest value that could be
        # self.min_arg_score = 0
        # Sum the color difference for every pixel.
        for _,population_member_dict in enumerate(self.current_population):
            img = population_member_dict["img"].construct_img()
            score = self._fitness_single(img)
            population_member_dict["score"] = score
        print("--------------------------------------------------------")


    def _selection(self):
        print("----------------------- Selection -----------------------")
        # Sort and select the best ##
        # print(self.current_population)
        self.current_population = sorted(self.current_population, key=lambda img: img["score"])
        # print("----------------------------")
        # print(self.current_population)
        population_limit = int(self.selection_percentage * len(self.current_population))
        self.current_population = self.current_population[:population_limit]    # take the best ith according to the selection_percentage
        print("--------------------------------------------------------")


    def _crossover(self):
        print("----------------------- Crossover -----------------------")
        offspring = []
        # Generate offspring from the best from the population to get the missed number of the population of the current population
        population_size_missed = int((self.population_size - len(self.current_population)))
        for i in range(population_size_missed):
            parent1_img = random.choice(self.current_population)["img"]
            parent2_img = random.choice(self.current_population)["img"]
            child = {"img":utils.Image(imgs=self.imgs, imgs_shape=self.small_img_shape), "score":-1}
            
            # threshold = np.random.uniform(0,1)

            child_indexes = parent1_img.get_index().copy()
            # old_child_indexes = child_indexes.copy()
            total_num_rc = parent1_img.get_index().shape
            num_rows_selected = int(total_num_rc[0]*self.crossover_percentage[0])
            num_cols_selected = int(total_num_rc[1]*self.crossover_percentage[1])
            parent1_parts = tuple([parent1_img.get_index()[:num_rows_selected,:num_cols_selected], parent1_img.get_index()[num_rows_selected:,num_cols_selected:]])
            parent2_parts = tuple([parent2_img.get_index()[:num_rows_selected,:num_cols_selected], parent2_img.get_index()[num_rows_selected:,num_cols_selected:]])
            parts_1p = tuple([parent1_parts[0], parent2_parts[0]])
            parts_2p = tuple([parent1_parts[1], parent2_parts[1]])

            # all parts can swapped together
            if(num_rows_selected == total_num_rc[0]-num_rows_selected and num_cols_selected == total_num_rc[1]-num_cols_selected):
                parts = tuple([parts_1p[0], parts_1p[1], parts_2p[0], parts_2p[1]])
                child_indexes[:num_rows_selected, :num_cols_selected] = random.choice(parts)
                child_indexes[num_rows_selected:, num_cols_selected:] = random.choice(parts)

            else:
                child_indexes[:num_rows_selected, :num_cols_selected] = random.choice(parts_1p)
                child_indexes[num_rows_selected:, num_cols_selected:] = random.choice(parts_2p)
            # ------------------------------------ Old -----------------------------------------------
            # # print(threshold)
            # # The 1st part is from 1st part parent1_img, the 2nd part is from 2nd part of parent2_img
            # if(threshold < 0.125):
            # # if(threshold <= 1):
            #     print("1")
            #     child_indexes[:num_rows_selected, :num_cols_selected] = parent1_img.get_index()[:num_rows_selected,:num_cols_selected]
            #     child_indexes[num_rows_selected:, num_cols_selected:] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     # print("###############")
            #     # BUG BUG BUG
            #     # child_indexes = np.concatenate((parent1_img.get_index()[:num_rows_selected,:num_cols_selected],parent2_img.get_index()[num_rows_selected:,num_cols_selected:]))
            #     # for r in range(num_rows_selected):
            #     #     for c in range(num_cols_selected):
            #     #         child_indexes[num_rows_selected+r][num_cols_selected+c] = parent2_img.get_index()[num_rows_selected+r][num_cols_selected+c]

            #     # print("###############")
            #     # print(parent1_img.get_index()[0])
            #     # print(parent1_img.get_index()[-1])
            #     # print(parent2_img.get_index()[-1])
            #     # print(child_indexes[-1])
            # # The 1st part is from 2nd part parent1_img, the 2nd part is from 1st part of parent2_img
            # elif(threshold < 0.25):
            #     print("2")
            #     child_indexes[:num_rows_selected, :num_cols_selected] = parent1_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     child_indexes[num_rows_selected:, num_cols_selected:] = parent2_img.get_index()[:num_rows_selected,:num_cols_selected]
            #     # child_indexes[num_rows_selected:,num_cols_selected:] = parent1_img.get_index()[:num_rows_selected,num_cols_selected]
            #     # child_indexes[:num_rows_selected,:num_cols_selected] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]


            # # The 1st part is from 2nd part parent2_img, the 2nd part is from 1st part of parent1_img
            # elif(threshold < 0.375):
            #     print("3")
            #     child_indexes[:num_rows_selected, :num_cols_selected] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     child_indexes[num_rows_selected:, num_cols_selected:] = parent1_img.get_index()[:num_rows_selected,:num_cols_selected]
            #     # child_indexes[:num_rows_selected,:num_cols_selected] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     # child_indexes[num_rows_selected:,num_cols_selected:] = parent1_img.get_index()[:num_rows_selected,:num_cols_selected]

            # # The 1st part is from 1st part parent2_img, the 2nd part is from 2nd part of parent1_img
            # elif(threshold < 0.5):
            #     print("4")
            #     child_indexes[:num_rows_selected, :num_cols_selected] = parent2_img.get_index()[:num_rows_selected,:num_cols_selected]
            #     child_indexes[num_rows_selected:, num_cols_selected:] = parent1_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     # child_indexes[:num_rows_selected,:num_cols_selected] = parent2_img.get_index()[:num_rows_selected,:num_cols_selected]
            #     # child_indexes[num_rows_selected:,num_cols_selected:] = parent1_img.get_index()[num_rows_selected:,num_cols_selected:]

            # # The 1st part is from 2nd part parent1_img, the 2nd part is from 2nd part of parent2_img
            # elif(threshold < 0.625):
            #     print("5")
            #     child_indexes[:num_rows_selected, :num_cols_selected] = parent1_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     child_indexes[num_rows_selected:, num_cols_selected:] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     # child_indexes[:num_rows_selected,:num_cols_selected] = parent1_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     # child_indexes[num_rows_selected:,num_cols_selected:] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]

            # # The 1st part is from 1st part parent1_img, the 2nd part is from 1st part of parent2_img
            # elif(threshold < 0.75):
            #     print("6")
            #     child_indexes[:num_rows_selected,:num_cols_selected] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     child_indexes[num_rows_selected:,num_cols_selected:] = parent1_img.get_index()[:num_rows_selected,:num_cols_selected]

            # # The 1st part is from 2nd part parent2_img, the 2nd part is from 2nd part of parent1_img
            # elif(threshold < 0.875):
            #     print("7")
            #     child_indexes[:num_rows_selected,:num_cols_selected] = parent2_img.get_index()[num_rows_selected:,num_cols_selected:]
            #     child_indexes[num_rows_selected:,num_cols_selected:] = parent1_img.get_index()[num_rows_selected:,num_cols_selected:]

            # # The 1st part is from 1st part of parent2_img, the 2nd part is from 1st part of parent1_img            
            # else:
            #     print("8")
            #     child_indexes[:num_rows_selected,:num_cols_selected] = parent2_img.get_index()[:num_rows_selected,:num_cols_selected]

            child["img"].set_index(child_indexes)
            child["score"] = self._fitness_single(child["img"].construct_img())
            
            # print("################")
            # print(child_indexes[-1])
            # # Error child indexes is not changing
            # s = 0
            # for i in range(len(child_indexes)):
            #     s += abs(child_indexes[i]-old_child_indexes[i])
            #     # s += abs(parent1_img.get_index()[i]-parent2_img.get_index()[i])
            # print("s=",s)
            
            # utils.preview_img(utils.to_img(parent1_img.construct_img()), title="parent1_img")
            # input()
            # utils.preview_img(utils.to_img(parent2_img.construct_img()), title="parent2_img")
            # input()
            # utils.preview_img(utils.to_img(child["img"].construct_img()), title="child")
            # input()
            # print(self.calc_error(parent1_img.construct_img(), child["img"].construct_img()))
            
            offspring.append(child)

        self.current_population.extend(offspring)

        print("--------------------------------------------------------")


    def _mutation(self):
        print("----------------------- Mutation -----------------------")
        for population_member_dict in self.current_population:
            img_indexes = population_member_dict["img"].get_index().copy()
            rows, cols = img_indexes.shape
            for r in range(rows):
                for c in range(cols):
                    probability = np.random.uniform(0,1)
                    if(probability < self.mutation_probability):
                        img_indexes[r,c] = np.random.randint(self.max_index_imgs)
            population_member_dict["img"].set_index(img_indexes)
        print("--------------------------------------------------------")

    def _termination(self):
        print("----------------------- Termination -----------------------")
        self.min_score = 100000000
        self.min_arg_score = 0
        for i,population_member_dict in enumerate(self.current_population):
            score = population_member_dict["score"]
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
        score_iteration_list = []

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
            score_iteration_list.append(self.current_population[termination[1]]["score"])
            # self.current_population = self._generate_population(parent=self.current_population)
        print(score_iteration_list)
        return self.progress_imgs, self.output_img
    
if __name__ == "__main__":
    pass