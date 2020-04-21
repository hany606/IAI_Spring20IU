import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

from PIL import Image
import numpy as np


def resize():
    size = (8, 8)
    # input_dir = "../input/"
    input_dir = "../../assets/mnist_png/mnist_png/testing/All/"
    output_dir = "../../assets/mnist_png/mnist_png/testing/All_resized8x8/"
    for i in range(10000):
        inp_img_path = input_dir+"{:}.png".format(i)
        img = Image.open(inp_img_path)
        # print(img.size)
        img_new = img.resize(size)
        out_img_path = output_dir+"{:}.png".format(i)
        img_new.save(out_img_path, "PNG")
        # print(img_new.size)
