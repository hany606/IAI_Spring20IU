import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils
import numpy as np


input_dir = "../../input/"
output_dir = "../../output/"
assets_dir = "../../assets/mnist_png/mnist_png/testing/All_resized8x8/"
small_imgs_num = 10000
inp_img_path = input_dir+"input.png"
out_img_path = output_dir+"Baseline_output.png"

big_img_size = (512,512)
small_img_size = (8,8)

def calc_error(input_img, gen_img):
    shape = input_img.shape
    error = 0 
    for r in range(shape[0]):
        for c in range(shape[1]):
            for l in range(shape[2]):
                error += ((input_img[r][c][l] - gen_img[r][c][l])**2)
    
    error /= (shape[0]*shape[1]*shape[2])
    return error

def generate_baseline_img(small_imgs, input_img):
    new_img = input_img.copy()

    num_rows_small = small_img_size[0]
    num_cols_small = small_img_size[1]
    num_rows = big_img_size[0]//num_rows_small
    num_cols = big_img_size[1]//num_cols_small

    for r in range(num_rows):
        r_idx = r*num_rows_small
        r_idx_lim = r_idx + num_rows_small
        for c in range(num_cols):
            c_idx = c*num_cols_small
            c_idx_lim = c_idx + num_cols_small
            # print(r_idx, r_idx_lim)
            # print(c_idx, c_idx_lim)
            # print(r,c)

            section_img = input_img[r_idx:r_idx_lim, c_idx:c_idx_lim]
            mn_err = 1000000000
            mn_idx = 0
            mn_img = None
            for i, img in enumerate(small_imgs):
                imgtmp = utils.to_img(img)
                utils.preview_img(imgtmp)
                error = calc_error(section_img,img)
                if(error < mn_err):
                    mn_err = error
                    mn_idx = i
                    mn_img = img
            
            new_img[r_idx:r_idx_lim, c_idx:c_idx_lim] = mn_img


    gen_img = utils.to_img(new_img)
    return gen_img



# ------------------------------------------------------------------------
img = utils.read_img(inp_img_path)


imgs = utils.read_small_imgs()
# indexes = []
# for i in range(64):
#     indexes.append([np.random.randint(10000) for i in range(64)])

# imgt = utils.Image(imgs=imgs, index=indexes)

# img = imgt.construct_img()

# img = utils.to_img(img)

# print(img.size)
# utils.preview_img(img)

# ------------------------------------------------------------------------

img_np = utils.to_numpy(img)

out_img = generate_baseline_img(imgs,img_np)

utils.preview_img(out_img, title="Baseline_img")
utils.write_img(out_img_path, out_img)
