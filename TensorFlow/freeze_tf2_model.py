#!/usr/bin/env python3

import tensorflow as tf
from tensorflow import keras
from tensorflow.python.framework.convert_to_constants import convert_variables_to_constants_v2
import numpy as np
import json, os, sys

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
    full_model = full_model.get_concrete_function(
        tf.TensorSpec(model.inputs[0].shape, model.inputs[0].dtype))
    
    # Get frozen graph def
    frozen_func = convert_variables_to_constants_v2(full_model)
    frozen_func.graph.as_graph_def()
    
    print('Input name: ' + frozen_func.inputs[0].op.name)
    print('Output name: ' + frozen_func.outputs[0].op.name)
    
    print('Saving frozen model to: ' + os.path.join(frozen_out_path, frozen_graph_filename + '.pb'))
    tf.io.write_graph(graph_or_graph_def=frozen_func.graph,
                      logdir=frozen_out_path,
                      name=f"{frozen_graph_filename}.pb",
                      as_text=False)
    
    input_dims = [1 if e is None else e for e in list(model.inputs[0].get_shape())]
    
    output_dims = [1 if e is None else e for e in list(model.outputs[0].get_shape())]
    
    model_info = {
        'frozen_graph' : frozen_graph_filename + '.pb',
        'input_desc' :
        [{
            'op_name' : frozen_func.inputs[0].op.name,
            'tensor_map' : [{'idx': 0, 'dim' : input_dims, 'col_start' : 0}]
        }],
        'output_desc' :
        [{
            'op_name' : frozen_func.outputs[0].op.name,
            'tensor_map' : [{'idx': 0, 'dim' : output_dims, 'col_start' : 0}]
        }]
    }
    
    #print(json.dumps(model_info, indent=4, sort_keys=False))
    
    print('Saving model description file to: ' + os.path.join(frozen_out_path, 'tf_model_desc.json'))
    with open(os.path.join(frozen_out_path, 'tf_model_desc.json'), 'w') as json_file:
      json.dump(model_info, json_file, indent=4, sort_keys=False)


if __name__ == "__main__":
   main(sys.argv[1:])
