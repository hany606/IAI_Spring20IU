# Assignment2

This directory includes my solution for this assignment.

## Description:

This assignment required implementing one of the evolutionary algorithms to generate  picture that looks like an input image in an artistic way.

The assignment is written fully in python.

## Specifications/Constraints:

* Input image: 512x512 pixels
* Output image (Generated): 512x512 pixels
* No using for other libraries for evolutionary algorithms


## Dependencies

* PIL
* Numpy
* tqdm for progress visualization


## Structures:

The structure of the codes is as following:

– input directory: has the input images.

– output directory: has the output of the generated images.

– src directory: contains all the source codes that has been used
* Extra tools directory: has the tools that is used for resize, change the format of the input image, ...etc.

* Evolutionary Algorithm directory: includes EA.py that has EA class that contain all the functionalities for the algorithm (fitness, crossover, mutation, termination, training, generation functions), and main.py that has the main running code for the assignment.

* Shared directory: includes the utils.py that contains the useful functions (e.g. changing from PIL.Image to numpy and the opposite, read and write images and gif for animation, preview the image, read the small images of the dataset from their directory, and Image class that is used to describe the member of the generated population and store the indexes of the small images as matrix to be the genes of the member (it contains construct img() function that concatenate the small images based on the indexes that was provided and get the big image)

* Baseline directory: includes the script to generate the baseline generated image.

– assets directory: that stores the scripts for downloading the dataset
and the dataset itself.

## How to run & use?

0. Put the input image in 'input" directory

1. Install the dependencies:
    ```bash
        pip3 install tqdm
        pip3 install numpy
        pip3 install Pillow
    ```
2. Prepare the dataset
    ```bash
        cd assets/CIFAR_dataset/cifar_imgs_github
        python3 install_cifar10.py
        cd ..
        chmod +x prepare.sh
        mkdir -p imgs/imgs_original
        mkdir -p imgs/imgs_resized
        ./prepare.sh
        cd ../..
        cd src/Extra\ tools
        python3 cifar_custom.py
        cd ..        
        cd Evolutionary\ Algorithm
    ```
3. Run the following command and wait until it finishes or press Ctrl+C to finish (There is tmp image is being updated every iteration)

    ```python3 main.py -i <input_file_name_wo_ext> -o <output_directory_name_wo_ext>```

    For example:
    ```python3 main.py``` By default will take input.png as input file from the input directory and save it in the output directory in output/output/output.png

    ```python3 main.py -i input2 -o output2```

4. To see the progress of the evolving of the image till the output, open the "output/out.gif"

5. To see the output image, open "output.png" from the output directory

Note: There was a developing for a dockerfile in the progress but did not finish on time
