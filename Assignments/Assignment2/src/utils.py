# This file include the utilities functions required for the code
from PIL import Image as PImage
import numpy as np

def preview_img(img):
    img.rotate(np.pi/4)
    img.show()

def read_img(img_path):
    img = PImage.open(img_path)
    return img

def to_numpy(img):
    np_img = np.array(img)
    return np_img

def to_img(np_img):
    img = PImage.fromarray(np_img)
    return img
    
def write_img(img_path, img):
    img.save(img_path, "PNG")

def create_gif(gif_path, imgs):
    init_img = imgs[0]
    init_img.save(gif_path, save_all=True, append_images=imgs[1:])

class Image:
    # index and rotation are 64x64 = (512/8 x 512/8) matrix that have the indices of the small images for each
    def __init__(self,imgs, src_path="../assets/mnist_png/mnist_png/testing/All_resized8x8/",
                index=None, size = (512, 512), imgs_size=(8,8)):
        self.index = index
        self.src_path = src_path
        self.size = size
        self.imgs_size = imgs_size
        self.imgs = imgs
        self.img = np.empty(size)

    def set_index(self,index):
        self.index = index

    def construct_img(self):
        num_rows_small = self.imgs_size[0]
        num_cols_small = self.imgs_size[1]
        num_rows = self.size[0]//num_rows_small
        num_cols = self.size[1]//num_cols_small
        for r in range(num_rows):
            r_idx = r*num_rows_small
            r_idx_lim = r_idx + num_rows_small
            for c in range(num_cols):
                c_idx = c*num_cols_small
                c_idx_lim = c_idx + num_cols_small
                # print(r_idx, r_idx_lim)
                # print(c_idx, c_idx_lim)
                # print(r,c)
                img = self.imgs[self.index[r][c]]
                self.img[r_idx:r_idx_lim, c_idx:c_idx_lim] = img
        return self.img



if __name__ == "__main__":
    pass    