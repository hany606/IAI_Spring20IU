import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

from EA import EA
import numpy as np
from time import time
import json

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
output_dir += output_file_name

if(not os.path.exists(output_dir+"/")):
    output_dir += "/"
    os.mkdir(output_dir)

else:
    print("Error repeated directory, put another directory")
    exit()

out_img_path = output_dir+output_file_name+".png"
out_gif_path = output_dir+output_file_name+".gif"
results_log_file_path = output_dir+"results_log({:}).json".format(output_file_name)
tmp_img_path = output_dir+"tmp_"+output_file_name+".png"


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

init_time = time()
progress_imgs, out_img, score = algo.train(tmp_img_path=tmp_img_path)
process_time = time() - init_time

print("----------------------- Finish -----------------------")
print("Total processing time: {:}".format(process_time))
print("------------------------------------------------------")

with open(results_log_file_path,"w+") as f:
    results_dict = {"Error_score":score, "output_name": output_file_name, "Total_time": process_time}
    json.dump(results_dict, f, indent=4)


# print(type(out_img))
utils.preview_img(out_img)
utils.create_gif(out_gif_path, progress_imgs)
utils.write_img(out_img_path, out_img)
# out_img.save(out_img_path, "PNG")



