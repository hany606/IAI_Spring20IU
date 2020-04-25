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

1. Run the following command to run the docker file to setup the docker container

    ```docker  ```

2. Run the following command to run the bash of the docker container

    ```docker ```

3. Inside the docker container's bash, run the following command and wait until it finishes

    ```python3 main.py```

4. To see the progress of the evolving of the image till the output, open the "output/out.gif"

5. To see the output image, open "output.png"