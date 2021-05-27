# Vertica TensorFlow Demo
## Intro
As of Vertica 11, Vertica now supports TensorFlow 2! Train your TensorFlow models in Python outside of Vertica and then import them to your Vertica cluster for prediction on in-database data.

## TensorFlow 2 in Vertica
TensorFlow 2 brings many updates and improvements to TensorFlow, and is now the default TensorFlow version. It is recommended to use TF 2 instead of TF 1 and to port past models to TF 2.

### Training a TF2 model
> **_NOTE:_** Steps 1 - 5 should be performed outside of Vertica.
1. [Install TensorFlow](https://www.tensorflow.org/install)
2. Train your TF 2 model outside of Vertica in Python](https://www.tensorflow.org/tutorials/quickstart/beginner)
3. [Save the model](https://www.tensorflow.org/tutorials/keras/save_and_load#save_the_entire_model)
```python
mymodel.save('my_saved_model_dir')
```
4. In order for Vertica to successfully import your model, it must be transformed into a frozen graph file, we provide a script to do this for TF2 models. Run the freeze_tf2_model.py script, passing in the path to your saved model and optionally a directory to save the frozen graph format to (default is frozen_tfmodel):
```bash
./freeze_tf_model.py path/to/my/awesome/tf/model frozen_dir_name(opt)
```
This script also auto-generates the required tf_model_desc.json file, which allows Vertica to translate from SQL tables to Tensorflow Tensors. This generated file should work for most cases, but if your model requires a complex mapping from/to Vertica tables you may need to modify this file.
5. Copy the resulting folder to any node in your Vertica cluster, and import the model:
```sql
select import_models('path/to/frozen_model_dir' using parameters category='TENSORFLOW');
```
6. Predict with your model in Vertica!

## Training a TF 1 model (deprecated)
1. [Install TensorFlow](https://www.tensorflow.org/install/pip#virtualenv-install) 1.15 on your system. Note: To install a specific version do `pip install tensorflow==1.15` in the last step. If this version of TensorFlow is not found, you may need to downgrade your python version (TF 1 is not supported on Python 3.8 and newer)
2. Run `python3 train_save_model.py` from the base directory of this repo.
3. Move/copy the entire tf_mnist_keras directory to your Vertica cluster, then run the import TF model command:
```sql
select import_models('path/to/tf_mnist_keras' using parameters category='TENSORFLOW');
```
4. See Vertica Doc for further instructions.

## Sources
Data obtained from http://yann.lecun.com/exdb/mnist/
