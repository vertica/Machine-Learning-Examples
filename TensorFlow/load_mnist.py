import gzip
import os
import numpy as np
#from PIL import Image

key_file = {
    'train_img':   'train-images-idx3-ubyte.gz',
    'train_label': 'train-labels-idx1-ubyte.gz',
    'test_img':    't10k-images-idx3-ubyte.gz',
    'test_label':  't10k-labels-idx1-ubyte.gz'
}

cur_dir = os.path.dirname(os.path.abspath(__file__)) 
dataset_dir = cur_dir + '/data'

img_size  = 784

def load_labels (file_name):
    file_path = dataset_dir + "/" + file_name
    print("Converting " + file_name + " to NumPy Array ...")
    with gzip.open(file_path, 'rb') as f:
            labels = np.frombuffer(f.read(), np.uint8, offset=8)
    print("Done")
    return labels


def load_imgs (file_name):
    file_path = dataset_dir + "/" + file_name
    print("Converting " + file_name + " to NumPy Array ...")
    with gzip.open(file_path, 'rb') as f:
            data = np.frombuffer(f.read(), np.uint8, offset=16)
    data = data.reshape(-1, img_size)
    print("Done")

    return data


def convert_to_numpy ():

    dataset = {}

    dataset['train_img']   = load_imgs   (key_file['train_img'])
    dataset['train_label'] = load_labels (key_file['train_label'])
    dataset['test_img']    = load_imgs   (key_file['test_img'])
    dataset['test_label']  = load_labels (key_file['test_label'])
    return dataset


def change_one_hot_labels(X):

    T = np.zeros((X.size, 10))
    for idx, row in enumerate(T):
        row[X[idx]] = 1
    return T


#----------------------------------------------------------------------------
#    Parameters
#    ----------
#    normalize : Normalize the pixel values
#    flatten : Flatten the images as one array
#    one_hot_label : Encode the labels as a one-hot array
#
#    Returns
#    -------
#    (Trainig Image, Training Label), (Test Image, Test Label)
#----------------------------------------------------------------------------
def load_mnist (normalize=True, flatten=True, one_hot_label=False):

    dataset = convert_to_numpy ()

    if normalize:
        for key in ('train_img', 'test_img'):
            dataset[key] = dataset[key].astype(np.float32)
            dataset[key] /= 255.0

    if not flatten:
         for key in ('train_img', 'test_img'):
            dataset[key] = dataset[key].reshape(-1, 28, 28, 1)

    if one_hot_label:
        dataset['train_label'] = change_one_hot_labels(dataset['train_label'])
        dataset['test_label']  = change_one_hot_labels(dataset['test_label'])

    return (dataset['train_img'], dataset['train_label']), (dataset['test_img'], dataset['test_label'])


"""
def img_show(img):
    pil_img = Image.fromarray(np.uint8(img))
    pil_img.show()
# Show the sample image
img   = x_train[0]
label = t_train[0]
print(label)
print(img.shape)
img = img.reshape(28, 28)
print(img.shape)
img_show(img)
"""

