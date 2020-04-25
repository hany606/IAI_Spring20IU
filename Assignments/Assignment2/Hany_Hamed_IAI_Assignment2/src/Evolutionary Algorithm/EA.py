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
        self.progress_imgs = []

        # Parameters to be tuned
        self.num_iterations = 10000  # 50000 for uniform        # 5 for greedy_v2
        self.population_size = 100     # 100 for uniform      # 10 for greedy_v2
        self.selection_percentage = 0.2
        self.crossover_percentage = (0.5,0.5)   # ((row, col) in case of two parents
        self.crossover_num_parents = 2
        self.mutation_probability = 0.1    # 0.01 took 14 hrs for uniform and 7k score
        # self.hybrid_crossover_ratio = {"uniform":0, "parts":0, "greedy":0.5}
        self.termination_threshold = 500   # To be chosen, the threshold that the fitness score is acceptable
        self.crossover_greedy_probability = 1

        self.img_size = (512,512)


        self.imgs = utils.read_small_imgs(assets_dir=small_imgs_assets_path, num=small_imgs_num, format_str=format_str)
        self.imgs = np.array(self.imgs)
        self.small_img_shape = self.imgs.shape[1:]
        # Configurations for the small images
        self.max_index_imgs = small_imgs_num
        self.small_imgs_num_rc = tuple([self.img_size[0]//self.small_img_shape[0], self.img_size[1]//self.small_img_shape[1]])


        self.current_population = self._generate_population()
    
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


    # TODO: implement mn score optimization
    def calc_error(self, input_img, gen_img, mn_error=None):
        shape = input_img.shape
        error = 0 
        for r in range(shape[0]):
            for c in range(shape[1]):
                for l in range(shape[2]):
                    loc_error = ((float(input_img[r][c][l]) - float(gen_img[r][c][l]))**2)/(shape[0]*shape[1]*shape[2])
                    # print(loc_error)
                    error += loc_error
                    if(mn_error is not None and mn_error < error):
                        return 10000000000
        # print(error)
        return error

    # This is the fitness function that return how close the input image
    def _fitness_single(self, img_np):
        # rows, cols, channels = img_np.shape
        score = self.calc_error(img_np, self.input_img)
        # print(img_np[0,1], self.input_img[0,1])
        # for r in range(rows):
        #     for c in range(cols):
        #         for l in range(channels):
        #             loc_score = ((float(img_np[r][c][l]) - float(self.input_img[r][c][l]))**2)/(rows*cols*channels)
        #             # print(loc_error)
        #             score += loc_score
        # if(score < self.min_score):
        #     self.min_score = score
        #     self.min_arg_score = i
        # print(score)
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
        def parents_parts(num):
            offspring = []
            for i in range(num):
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

                child["img"].set_index(child_indexes)
                child["score"] = self._fitness_single(child["img"].construct_img())
                
                offspring.append(child)
            return offspring
        
        def uniform(gen_num, parent_num=None):
            if(gen_num == 0):
                return 0
            if(parent_num is None):
                parent_num = len(self.current_population)
            
            offspring = []

            for _ in range(gen_num):
                initial_indexes = self.current_population[0]["img"].get_index()
                child = {"img":utils.Image(imgs=self.imgs, imgs_shape=self.small_img_shape), "score":-1}
                child_indexes = initial_indexes.copy()
                parent_num = min(parent_num, len(self.current_population))
                parents = random.choices(self.current_population, k=parent_num)
                for index_row,row in enumerate(child_indexes):
                    for index_col,_ in enumerate(row):
                        random_parent_index = np.random.randint(parent_num)
                        random_parent_index_row = np.random.randint(self.small_imgs_num_rc[0])
                        random_parent_index_col = np.random.randint(self.small_imgs_num_rc[1])
                        child_indexes[index_row][index_col] = parents[random_parent_index]["img"].get_index()[random_parent_index_row][random_parent_index_col]
                
                child["img"].set_index(child_indexes)
                child["score"] = self._fitness_single(child["img"].construct_img())
                offspring.append(child)
            
            return offspring
            
        # Most probably it will computationally expensive but much more efficient
        # TODO: Make the last part of creation of the offspring no tappend the same child, that's if the parent_num not equal to the current_population
        def greedy_parts_v1(gen_num, parent_num=None):
            if(gen_num == 0):
                return []
            if(parent_num is None):
                parent_num = len(self.current_population)
            initial_indexes = self.current_population[0]["img"].get_index()
            child = {"img":utils.Image(imgs=self.imgs, imgs_shape=self.small_img_shape), "score":-1}
            child_indexes = initial_indexes.copy()
            

            parent_num = min(parent_num, len(self.current_population))
            parents = random.choices(self.current_population, k=parent_num)
            
            for index_row,row in enumerate(child_indexes):
                for index_col,_ in enumerate(row):
                    mn_error = 10000000000000000
                    mn_index = 0
                    for i in range(parent_num):
                        # print(parents[i]["img"].get_index())
                        parent_gene_index = parents[i]["img"].get_index()[index_row][index_col]
                        parent_img_gene = self.imgs[parent_gene_index]
                        rlim, clim = self.small_img_shape[:2]
                        input_img_gene  = self.input_img[rlim*index_row:rlim*index_row+rlim, clim*index_col:clim*index_col+clim]
                        error = self.calc_error(input_img_gene, parent_img_gene)
                        if(error < mn_error):
                            mn_error = error
                            mn_index = parent_gene_index
                    
                    child_indexes[index_row][index_col] = mn_index

            child["img"].set_index(child_indexes)
            child["score"] = self._fitness_single(child["img"].construct_img())

            # print(child["score"])
            # input("~~~INPUT DEBUG")

            offspring = [child for _ in range(gen_num)]
            return offspring

        # TODO: Make the last part of creation of the offspring not append the same child, that's if the parent_num not equal to the current_population
        def greedy_parts_v2(gen_num, parent_num=None):
            if(gen_num == 0):
                return []
            if(parent_num is None):
                parent_num = len(self.current_population)
            initial_indexes = self.current_population[0]["img"].get_index()
            child = {"img":utils.Image(imgs=self.imgs, imgs_shape=self.small_img_shape), "score":-1}
            child_indexes = initial_indexes.copy()
            
            # child["img"].set_index(child_indexes)
            # child["score"] = self._fitness_single(child["img"].construct_img())
            # print(child["score"])
            # input("~~~INPUT DEBUG")

            parent_num = min(parent_num, len(self.current_population))
            parents = random.choices(self.current_population, k=parent_num)
            
            for index_row,row in tqdm(enumerate(child_indexes)):
                for index_col,_ in tqdm(enumerate(row)):
                    if(np.random.uniform(0,1) > self.crossover_greedy_probability):
                        pass
                    mn_error = 10000000000000000
                    mn_index = 0
                    for i in tqdm(range(parent_num)):
                        parent_indexes = parents[i]["img"].get_index()
                        for parent_index_row,parent_row in enumerate(parent_indexes):
                            for parent_index_col,_ in enumerate(parent_row):
                                parent_gene_index = parent_indexes[parent_index_row][parent_index_col]
                                parent_img_gene = self.imgs[parent_gene_index]
                                rlim, clim = self.small_img_shape[:2]
                                input_img_gene  = self.input_img[rlim*index_row:rlim*index_row+rlim, clim*index_col:clim*index_col+clim]
                                error = self.calc_error(input_img_gene, parent_img_gene, mn_error=mn_error)
                                if(error < mn_error):
                                    mn_error = error
                                    mn_index = parent_gene_index
                    
                    child_indexes[index_row][index_col] = mn_index

            child["img"].set_index(child_indexes)
            child["score"] = self._fitness_single(child["img"].construct_img())

            # print(child["score"])
            # input("~~~INPUT DEBUG")

            offspring = [child for _ in range(gen_num)]
            return offspring

        print("----------------------- Crossover -----------------------")
        # Generate offspring from the best from the population to get the missed number of the population of the current population
        population_size_missed = int((self.population_size - len(self.current_population)))
        offspring = []
        # offspring = parents_parts(population_size_missed)
        # offspring = parents_parts(int(population_size_missed*self.hybrid_crossover_ratio["parts"]))
        # self.current_population.extend(offspring)

        num_population_left = population_size_missed - len(offspring)
        offspring = uniform(num_population_left, parent_num=self.crossover_num_parents)
        self.current_population.extend(offspring)

        # num_population_left = population_size_missed - len(offspring)
        # offspring = greedy_parts_v2(num_population_left, parent_num=self.crossover_num_parents)
        # self.current_population.extend(offspring)
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
        if(self.termination_threshold > mn):
            print(mn)
            return (True,argmn)
        return (False,argmn)

    # The impelmentation of the algorithm
    def train(self, tmp_img_path=None):
        self.output_img = None
        score_iteration_list = []

        for _ in tqdm(range(self.num_iterations)):
            # print("#{:} iteration".format(i+1))
            self._fitness()
            self._selection()
            self._crossover()
            self._mutation()
            termination = self._termination()
            mn_img_raw = self.current_population[termination[1]]["img"]
            # print(mn_img_raw.get_index())
            mn_img_np = mn_img_raw.construct_img()
            mn_img = utils.to_img(mn_img_np)
            self.output_img = mn_img
            # utils.preview_img(mn_img)
            self.progress_imgs.append(mn_img)
            print(self.current_population[termination[1]]["score"])
            score_iteration_list.append(self.current_population[termination[1]]["score"])
            if(tmp_img_path is not None):
                utils.write_img(tmp_img_path,self.output_img)
            # self.current_population = self._generate_population(parent=self.current_population)
            if(termination[0]):
                self.output_img = utils.to_img(self.current_population[termination[1]]["img"].construct_img())
                self.progress_imgs.append(self.output_img)
                print("## Termination satisfied ")
                break
        print(score_iteration_list)
        return self.progress_imgs, self.output_img, score_iteration_list[-1]
    
if __name__ == "__main__":
    pass