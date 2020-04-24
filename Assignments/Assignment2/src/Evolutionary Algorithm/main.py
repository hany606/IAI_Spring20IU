import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

from EA import EA
import numpy as np

import argparse
parser = argparse.ArgumentParser(description='Reproduce images')
parser.add_argument('-o', action='store', default="output_8x8", type=str, required=False,
                    dest="output_file_name", help='Specify the output file name')

results = parser.parse_args()

input_dir = "../../input/"
output_dir = "../../output/"
assets_dir = "../../assets/CIFAR_dataset/imgs/imgs_resized/"
small_imgs_num = 50000
inp_img_path = input_dir+"input.png"

output_file_name = results.output_file_name

out_img_path = output_dir+output_file_name+".png"
out_gif_path = output_dir+output_file_name+".gif"


# --------------- Testing ------------------

# img = utils.read_img(assets_dir+"0.png")
# img_np = utils.to_numpy(img)
# print(img_np[2])
# print(img_np.shape)




# imgs = utils.read_small_imgs()
# indexes = []
# for i in range(64):
#     indexes.append([np.random.randint(10000) for i in range(64)])

# imgt = utils.Image(imgs=imgs, index=indexes)

# img = imgt.construct_img()

# img = utils.to_img(img)

# print(img.size)
# utils.preview_img(img)




# ------------------------------------------

img = utils.read_img(inp_img_path)

algo = EA(img, small_imgs_assets_path=assets_dir, small_imgs_num=small_imgs_num, format_str="{:05d}.png")

progress_imgs, out_img = algo.train()

# print(type(out_img))
utils.preview_img(out_img)
utils.create_gif(out_gif_path, progress_imgs)
# utils.write_img(out_img_path, out_img)
out_img.save(out_img_path, "PNG")



