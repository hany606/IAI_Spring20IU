import os,sys,inspect
current_dir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parent_dir = os.path.dirname(current_dir)+"/Shared/"
sys.path.insert(0, parent_dir) 
import utils

import argparse



def calc_error(input_img, gen_img):
    shape = input_img.shape
    error = 0 
    for r in range(shape[0]):
        for c in range(shape[1]):
            for l in range(shape[2]):
                loc_error = ((float(input_img[r][c][l]) - float(gen_img[r][c][l]))**2)/(shape[0]*shape[1]*shape[2])
                # print(loc_error)
                error += loc_error
    # print(error)
    return error

input_dir = "../../input/"
output_dir = "../../output/"
inp_img_path = input_dir+"input.png"
out_img_path = output_dir+"output_8x8.png"
baseline_file_path = output_dir+"Baseline_output8x8.png"



parser = argparse.ArgumentParser(description='Reproduce images')
parser.add_argument('--gen-file', action='store', default=out_img_path, type=str, required=False,
                    dest="gen_file", help='Specify the output file name')
parser.add_argument('--baseline-file', action='store', default=baseline_file_path, type=str, required=False,
                    dest="baseline_file", help='Specify the output file name')
parser.add_argument('--input', action='store', default=inp_img_path, type=str, required=False,
                    dest="input_file", help='Specify the output file name')
results = parser.parse_args()

gen_file = results.gen_file
baseline_file = results.baseline_file
input_file = results.input_file

gen_file_img = utils.read_img(gen_file)
baseline_file_img = utils.read_img(baseline_file)
input_file_img = utils.read_img(input_file)



utils.preview_img(input_file_img)

utils.preview_img(gen_file_img)
print("Generation Error between {:} and {:} ->\n {:}\n".format(gen_file,input_file, calc_error(utils.to_numpy(gen_file_img), utils.to_numpy(input_file_img))))
utils.preview_img(baseline_file_img)
print("Baseline Error between {:} and {:} ->\n {:}\n".format(baseline_file,input_file, calc_error(utils.to_numpy(baseline_file_img), utils.to_numpy(input_file_img))))


