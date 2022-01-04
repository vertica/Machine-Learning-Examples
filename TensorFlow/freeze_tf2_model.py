#!/usr/bin/env python3

import tensorflow as tf
from tensorflow import keras
from tensorflow.python.framework.convert_to_constants import convert_variables_to_constants_v2
import numpy as np
import json, os, sys

def get_str_from_dtype(dtype, is_input):
    if dtype in {tf.float16, tf.float32, tf.float64}:
        dtype_str = 'TF_FLOAT'
    elif dtype is tf.int64:
        dtype_str = 'TF_INT64'
    else:
        print('Only float and int64 datatypes accepted for inputs and outputs of model.')
        sys.exit()

    if is_input and dtype_str is 'TF_INT64':
        print('Integer dtype not accepted as model input.')
        sys.exit()

    return dtype_str

def main(argv):
    os.environ['TF_CPP_MIN_LOG_LEVEL'] = '1' # suppress some TF noise

    if len(sys.argv) != 2 and len(sys.argv) != 3:
        print('Please provide path to your saved model directory. Additionally, you may provide the')
        print('name of the directory to save the frozen model to (default is frozen_tfmodel). E.g.')
        print('./freeze_tf_model.py path/to/my/awesome/tf/model frozen_dir_name(opt)')
        sys.exit()

    saved_model_path = sys.argv[1]

    if len(sys.argv) == 3:
        save_dir = sys.argv[2]
    else:
        save_dir = 'frozen_tfmodel'

    frozen_out_path = os.path.join(saved_model_path, save_dir)
    frozen_graph_filename = "frozen_graph" # name of the .pb file

    model = tf.keras.models.load_model(saved_model_path)

    # Convert Keras model to ConcreteFunction
    full_model = tf.function(lambda x: model(x))

    # Note: If this line is failing, you may need to change the argument that is being passed into
    # get_concrete_function. The input should be one or more TensorSpecs, and should match the inputs
    # to your model. Sometimes, models with custom functions do not have model.inputs/outputs and you
    # need to provide them yourself. For example, if you have a function that accepts multiple inputs,
    # you may need to write something like ('None' acts as a wildcard for the shape argument):
    #
    # full_model = full_model.get_concrete_function(
    #    (tf.TensorSpec(shape=None, dtype=tf.float32),
    #    tf.TensorSpec(shape=None, dtype=tf.int64),
    #    ...
    #    ))
    full_model = full_model.get_concrete_function(
        tf.TensorSpec(model.inputs[0].shape, model.inputs[0].dtype))

    # Get frozen graph def
    frozen_func = convert_variables_to_constants_v2(full_model)
    frozen_func.graph.as_graph_def()

    print('Saving frozen model to: ' + os.path.join(frozen_out_path, frozen_graph_filename + '.pb'))
    tf.io.write_graph(graph_or_graph_def=frozen_func.graph,
                      logdir=frozen_out_path,
                      name=f"{frozen_graph_filename}.pb",
                      as_text=False)

    inputs = []
    for inp in frozen_func.inputs:
        #print(inp.op.name)
        #print(inp.get_shape())
        input_dims = [1 if e is None else e for e in list(inp.get_shape())]
        dtype = get_str_from_dtype(inp.dtype, True)
        inputs.append(
        {
            'op_name' : inp.op.name,
            'tensor_map' : [{'idx': 0, 'dim' : input_dims, 'col_start' : 0, 'data_type' : dtype}]
        })

    outputs = []
    for output in frozen_func.outputs:
        #print(output.op.name)
        #print(output.get_shape())
        output_dims = [1 if e is None else e for e in list(output.get_shape())]
        dtype = get_str_from_dtype(output.dtype, False)
        outputs.append(
        {
            'op_name' : output.op.name,
            'tensor_map' : [{'idx': 0, 'dim' : output_dims, 'col_start' : 0, 'data_type' : dtype}]
        })

    model_info = {
        'frozen_graph' : frozen_graph_filename + '.pb',
        'input_desc' : inputs,
        'output_desc' : outputs
    }

    #print(json.dumps(model_info, indent=4, sort_keys=False))

    print('Saving model description file to: ' + os.path.join(frozen_out_path, 'tf_model_desc.json'))
    with open(os.path.join(frozen_out_path, 'tf_model_desc.json'), 'w') as json_file:
      json.dump(model_info, json_file, indent=4, sort_keys=False)


if __name__ == "__main__":
   main(sys.argv[1:])
