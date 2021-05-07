import numpy as np
import os
import sys

import tensorflow.compat.v1 as tf
from tensorflow import keras
from tensorflow.keras.utils import to_categorical
from tensorflow.python.tools import freeze_graph

from load_mnist import load_mnist

tf.logging.set_verbosity(tf.logging.ERROR)
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

tf.reset_default_graph ()

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
if 'linux' in sys.platform or 'darwin' in sys.platform:
    tensorflow_dir   = os.path.dirname (os.path.realpath (__file__))
    model_dir        = tensorflow_dir + '/model/'
    saved_model_dir  = tensorflow_dir + '/saved_model/'
    frozen_model_dir = tensorflow_dir + '/frozen_model/'
    output_dir = tensorflow_dir + '/tf_mnist_keras/'

    cmd = 'rm -Rf ' + model_dir + ' ' + saved_model_dir + ' ' + frozen_model_dir + ' ' + output_dir
    os.system (cmd)
    cmd = 'mkdir ' + frozen_model_dir + ' ' + output_dir
    os.system (cmd)
    cmd = 'cp ' + tensorflow_dir + '/tf_model_desc.json ' + output_dir
    os.system (cmd)
    cmd = 'cp ' + tensorflow_dir + '/data/20-* ' + output_dir
    os.system (cmd)
    cmd = 'cp ' + tensorflow_dir + '/load_tf_data.sql ' + output_dir
    os.system (cmd)

elif 'win' in sys.platform:
    tensorflow_dir = os.path.dirname (os.path.realpath (__file__))
    model_dir        = tensorflow_dir + '\\model\\'
    saved_model_dir  = tensorflow_dir + '\\saved_model\\'
    frozen_model_dir = tensorflow_dir + '\\frozen_model\\'
    output_dir = tensorflow_dir + '\\tf_mnist_keras\\'

    cmd = 'rmdir /s /Q ' + model_dir + ' ' + saved_model_dir + ' ' + frozen_model_dir + ' ' + output_dir
    os.system (cmd)
    cmd = 'mkdir ' + frozen_model_dir + ' ' + output_dir
    os.system (cmd)
    cmd = 'copy ' + tensorflow_dir + '\\tf_model_desc.json ' + output_dir
    os.system (cmd)
    cmd = 'copy ' + tensorflow_dir + '\\data\\20-* ' + output_dir
    os.system (cmd)
    cmd = 'copy ' + tensorflow_dir + '\\load_tf_data.sql ' + output_dir
    os.system (cmd)

saver = tf.train.Saver ()
sess  = tf.keras.backend.get_session()

# IMPORTANT
# The strings in tfmodel.inputs and tfmode.outputs correspond almost exactly to the op_name parameters
# required for each input/output in the tf_model_desc.json file. If you are building your own model,
# run:
#       print({t.name:t for t in tfmodel.inputs})
#       print({t.name:t for t in tfmodel.outputs})
# 
# The outputs of the above command should be something like:
# {'image_input:0': <tf.Tensor 'image_input:0' shape=(?, 28, 28, 1) dtype=float32>}
# {'OUTPUT/Softmax:0': <tf.Tensor 'OUTPUT/Softmax:0' shape=(?, 10) dtype=float32>}
#
# from this we can infer that for the input the op_name should be 'image_input'
# and for the output the op_name should be 'OUTPUT/Softmax'.
#
# This is also used below in the freeze_graph command.
tf.saved_model.simple_save(
        sess,
        model_dir,
        inputs  = {t.name:t for t in tfmodel.inputs},
        outputs = {t.name:t for t in tfmodel.outputs})

tf.saved_model.save(tfmodel, saved_model_dir)

tf.io.write_graph(sess.graph_def, frozen_model_dir, 'model.pbtxt', as_text=True)
#tf.io.write_graph(sess.graph_def, frozen_model_dir, 'model.pb',    as_text=False)

#print(saver.saver_def.filename_tensor_name)
#print(saver.saver_def.restore_op_name)

saver.save(sess, frozen_model_dir + 'model.ckpt')

fg = freeze_graph.freeze_graph(
                          input_graph= frozen_model_dir + 'model.pbtxt',
                          input_saver='',
                          input_binary=False,
                          input_checkpoint= frozen_model_dir + 'model.ckpt',
                          output_node_names='OUTPUT/Softmax',
                          restore_op_name=saver.saver_def.restore_op_name,
                          filename_tensor_name=saver.saver_def.filename_tensor_name,
                          output_graph= output_dir + 'mnist_keras.pb',
                          clear_devices=True,
                          initializer_nodes='',
                          input_saved_model_dir=model_dir 
                         )
sess.graph.finalize()
