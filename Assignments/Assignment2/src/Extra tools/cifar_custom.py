import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

from PIL import Image
import numpy as np
from tqdm import tqdm



def resize():
    size = (16, 16)
    # input_dir = "../input/"
    input_dir = "../../assets/CIFAR_dataset/imgs/imgs_original/"
    output_dir = "../../assets/CIFAR_dataset/imgs/imgs_resized_16x16/"
    for i in tqdm(range(50000)):
        inp_img_path = input_dir+"{:05d}.png".format(i)
        # print(inp_img_path)
        # break
        img = Image.open(inp_img_path)
        # print(img.size)
        img_new = img.resize(size)
        out_img_path = output_dir+"{:05d}.png".format(i)
        img_new.save(out_img_path, "PNG")
        # print(img_new.size)



# def unpickle(file):
#     import pickle
#     with open(file, 'rb') as fo:
#         dict = pickle.load(fo, encoding='bytes')
#         # for i in dict.keys():
#         #     print(i)
#         #     print(dict[i])
#         # print(dict.keys())
#         for i in range(len(dict[b'data'])):
#             co = 100
#             clean_img = np.empty((32,32,3))
#             for r in range(32):
#                 for c in range(32):
#                     for l in range(3):
#                         clean_img[r][c][l] = dict[b'data'][co][r+c+l]
#             print(clean_img[0])
#             print(type(clean_img))
#             # img = clean_img
#             img = Image.fromarray(clean_img, 'RGB')
#             # img = utils.to_img(clean_img)
#             utils.preview_img(img)
#             break
#         # print(dict[b'data'][0])
#         # print((dict[b'data'][0].shape))
#     return dict



if __name__ == "__main__":
    # input_dir = "../../assets/CIFAR_dataset/cifar-10-batches-py/"
    # output_dir = "../../assets/CIFAR_dataset/imgs"
    # file1 = input_dir + "data_batch_1"
    resize()