from EA import EA
import utils

input_dir = "../input/"
output_dir = "../output/"
inp_img_path = input_dir+"input.jpg"
out_img_path = output_dir+"output.jpg"
out_gif_path = output_dir+"output.git"

img = utils.read_img(inp_img_path)
utils.preview_img(img)
utils.write_img(out_img_path, img)

# algo = EA(img)

# progress_imgs, out_img = algo.run()

# utils.preview_img(out_img)
# utils.create_gif(out_gif_path, progress_imgs)
# utils.write_img(out_img_path, out_img)