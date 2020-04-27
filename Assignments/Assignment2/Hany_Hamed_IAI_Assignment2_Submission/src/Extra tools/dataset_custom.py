import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

from PIL import Image
import numpy as np


def resize(size, input_dir, output_dir, num, format_str="{:}.png"):
    size = size
    input_dir = input_dir
    output_dir = output_dir
    for i in range(num):
        inp_img_path = input_dir+format_str.format(i)
        img = Image.open(inp_img_path)
        # print(img.size)
        img_new = img.resize(size)
        out_img_path = output_dir+format_str.format(i)
        img_new.save(out_img_path, "PNG")
