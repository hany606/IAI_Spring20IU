import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

from PIL import Image
import numpy as np
from tqdm import tqdm



def resize():
    size = (8, 8)
    input_dir = "../../assets/CIFAR_dataset/imgs/imgs_original/"
    output_dir = "../../assets/CIFAR_dataset/imgs/imgs_resized_16x16/"
    for i in tqdm(range(50000)):
        inp_img_path = input_dir+"{:05d}.png".format(i)
        img = Image.open(inp_img_path)
        img_new = img.resize(size)
        out_img_path = output_dir+"{:05d}.png".format(i)
        img_new.save(out_img_path, "PNG")




if __name__ == "__main__":
    # input_dir = "../../assets/CIFAR_dataset/cifar-10-batches-py/"
    # output_dir = "../../assets/CIFAR_dataset/imgs"
    # file1 = input_dir + "data_batch_1"
    resize()