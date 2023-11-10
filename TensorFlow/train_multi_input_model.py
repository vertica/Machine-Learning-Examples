#!/usr/bin/env python3

import os
import numpy as np
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

os.environ["CUDA_VISIBLE_DEVICES"] = "-1"

print ("Numpy version:     ", np.__version__)
print ("TensorFlow version:", tf.__version__)

batch_size      = 10
epochs          = 50
datatype        = 'int32'

#-------------------------------------------------------------------------
#   Load data
#-------------------------------------------------------------------------
datafile = 'clusters_data.csv'
data = {'x': [], 'y': [], 'labels': []}
with open(os.path.join('./data', datafile), 'r') as infile:
	for line in infile:
		vals = line.split(',')

		# header
		if vals[0] == 'id':
			continue;

		data['x'].append(float(vals[1]))
		data['y'].append(float(vals[2]))
		data['labels'].append(float(vals[3]))

x_train = np.asarray(data['x'], dtype=datatype)
y_train = np.asarray(data['y'], dtype=datatype)
labels = np.asarray(data['labels'], dtype=datatype)

#-------------------------------------------------------------------------
#   Create model
#-------------------------------------------------------------------------
input1 = keras.Input(shape=(1,), dtype=datatype)
input2 = keras.Input(shape=(1,), dtype=datatype)

# Note that this is an example model. In reality, there's no reason to use
# multiple inputs for this problem, nor does it require 2 Dense layers
x = layers.Concatenate(dtype=datatype)([input1, input2])
x = layers.Dense(32, activation='relu')(x)
x = layers.Dense(32, activation='relu')(x)
output = layers.Dense(1)(x)

model = keras.Model(inputs=[input1, input2], outputs=output, name='multi_model')

model.summary()

model.compile(
    loss=keras.losses.MeanSquaredError(),
    optimizer='adam',
    metrics=["mse"],
)

#-------------------------------------------------------------------------
#   Train model
#-------------------------------------------------------------------------
model.fit([x_train, y_train], labels, epochs=epochs, batch_size=batch_size)

test_scores = model.evaluate([x_train, y_train], labels)
print("Train loss/MSE:", test_scores[0])

print()
print("Some sample predictions:")
print(model.predict([x_train[:5], y_train[:5]]))
print()

#-------------------------------------------------------------------------
#   Save and export the model
#-------------------------------------------------------------------------
tensorflow_dir   = './multi_input_model'

model.save(tensorflow_dir)
print('Model saved to: ' + tensorflow_dir)
print('All done!')
