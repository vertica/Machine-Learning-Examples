#!/usr/bin/env python3

import numpy as np
import os

import tensorflow as tf
from tensorflow import keras
from tensorflow.keras.utils import to_categorical

from load_mnist import load_mnist

os.environ["CUDA_VISIBLE_DEVICES"] = "-1"

print ("Numpy version:     ", np.__version__)
print ("TensorFlow version:", tf.__version__)
print ('Keras version: ', keras.__version__)

batch_size      = 100
epochs          = 5
num_test_images = 10

(train_eval_data, train_eval_labels), (test_data, test_labels) = load_mnist (normalize=True)

train_eval_data = train_eval_data.astype ('float64')
test_data       = test_data.astype ('float64')

train_eval_labels = np.asarray (train_eval_labels, dtype=np.int64)
train_eval_labels = to_categorical (train_eval_labels)

test_labels = np.asarray (test_labels,  dtype=np.int64)
test_labels = to_categorical (test_labels)

#  Split the training data into two parts, training and evaluation
data_split   = np.split (train_eval_data,   [55000])
labels_split = np.split (train_eval_labels, [55000])

train_data   = data_split [0]
train_labels = labels_split [0]

eval_data    = data_split [1]
eval_labels  = labels_split [1]

print ('Size of train_data: ', train_data.shape [0])
print ('Size of eval_data: ',  eval_data.shape [0])
print ('Size of test_data: ',  test_data.shape [0])

train_data = train_data.reshape ((55000, 28,28,1))
eval_data  = eval_data.reshape  ((5000,  28,28,1))
test_data  = test_data.reshape  ((10000, 28,28,1))

test_data   = test_data [:num_test_images]
test_labels = test_labels [:num_test_images]

tfmodel = keras.Sequential ([
    keras.layers.Conv2D       (32, (5,5), activation = tf.nn.relu, input_shape=(28, 28,1), name='image'),
    keras.layers.MaxPooling2D (2,2),
    keras.layers.Conv2D       (64, (5, 5), activation=tf.nn.relu),
    keras.layers.MaxPooling2D (2, 2),
    keras.layers.Flatten      (),
    keras.layers.Dense        (10, activation=tf.nn.softmax, name='OUTPUT')
])

tfmodel.compile (loss='categorical_crossentropy',
                 optimizer='sgd',
                 metrics=['accuracy'])

tfmodel.fit (train_data, train_labels,
             batch_size = batch_size,
             epochs = epochs,
             verbose = 1
            )

tfmodel.summary ()

loss, acc = tfmodel.evaluate(eval_data, eval_labels)
print ('Loss: ', loss, '  Accuracy: ', acc)

#---------------------------------------------------------------------------------
#  Run predictions
#---------------------------------------------------------------------------------
predictions = tfmodel.predict (test_data)

#for i in range (test_labels.shape [0]):
#    print ('Actual:    ', np.argmax (test_labels [i]))
#    print ('Predicted: ', np.argmax (predictions [i]), '\n')

#-------------------------------------------------------------------------
#   Save and export the model
#-------------------------------------------------------------------------
tensorflow_dir   = './tf2_model'

tfmodel.save(tensorflow_dir)
print('model saved to: ' + tensorflow_dir)
print('All done!')
