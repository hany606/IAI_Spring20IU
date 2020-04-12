from EA import EA
import utils
import numpy as np

input_dir = "../input/"
output_dir = "../output/"
assets_dir = "../assets/mnist_png/mnist_png/testing/All_resized8x8/"
small_imgs_size = 10000
inp_img_path = input_dir+"input2_bw.png"
out_img_path = output_dir+"output.png"
out_gif_path = output_dir+"output.gif"


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

algo = EA(img, small_imgs_assets_path=assets_dir, small_imgs_size=small_imgs_size)

progress_imgs, out_img = algo.train()

# print(type(out_img))
utils.preview_img(out_img)
utils.create_gif(out_gif_path, progress_imgs)
# utils.write_img(out_img_path, out_img)
out_img.save(out_img_path, "PNG")
