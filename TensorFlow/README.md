# Vertica TensorFlow Demo
## Training a TF model
1. [Install TensorFlow](https://www.tensorflow.org/install/pip#virtualenv-install) 1.15 on your system. Note: To install a specific version do `pip install tensorflow==1.15` in the last step.
2. Run `python3 train_save_model.py` from the base directory of this repo.
3. Move/copy the entire tf_mnist_keras directory to your Vertica cluster, then run the import TF model command:
```sql
select import_models('path/to/tf_mnist_keras' using parameters category='TENSORFLOW');
```
4. See Vertica Doc for further instructions.

## Sources
Data obtained from http://yann.lecun.com/exdb/mnist/
