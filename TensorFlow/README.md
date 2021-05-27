# Vertica TensorFlow Demo
## Intro
As of Vertica 11, Vertica now supports TensorFlow 2! Train your TensorFlow models in Python outside of Vertica and then import them to your Vertica cluster for prediction on in-database data.

## TensorFlow 2 in Vertica
TensorFlow 2 brings many updates and improvements to TensorFlow, and is now the default TensorFlow version. It is recommended to use TF 2 instead of TF 1 and to port past models to TF 2.

### Training a TF2 model
> **_NOTE:_**  Steps 1 - 5 should be performed outside of Vertica. For more details on Vertica Tensorflow, see the Vertica Documentation.

1. [Install TensorFlow](https://www.tensorflow.org/install)
2. Train and save the example model:
```bash
python3 train_tf2_model.py
```
3. In order for Vertica to successfully import your model, it must be transformed into a frozen graph file, we provide a script to do this for TF2 models. Run the freeze_tf2_model.py script, passing in the path to your saved model directory and optionally the directory name to save the frozen graph to (default is saved_model_dir/frozen_tfmodel):
```bash
python3 freeze_tf_model.py tf2_model
```
This script also auto-generates the required tf_model_desc.json file, which allows Vertica to translate from SQL tables to Tensorflow Tensors. This generated file should work for most cases, but if your model requires a complex mapping from/to Vertica tables you may need to modify it (see the Vertica documentation).

5. Copy the resulting folder (just the frozen model folder with the .pb and .json files) to any node in your Vertica cluster, also copy the data/ directory and load_tf_data.sql.

6. Load the data into Vertica (your vsql alias may differ: e.q. $VSQL). The data folder must be in the same directory as the load_tf_data.sql file:
```bash
vsql -f load_tf_data.sql
```

7. Import your trained model:
```sql
select import_models('path/to/frozen_tfmodel' using parameters category='TENSORFLOW');
```

> **_NOTE:_**  The imported model will take on the name of the folder that the .pb file was in, so rename this folder prior to import if you want a different name.

8. Predict with your model in Vertica!
```sql
select PREDICT_TENSORFLOW (*
                   USING PARAMETERS model_name='frozen_tfmodel', num_passthru_cols=1)
                   OVER(PARTITION BEST) FROM tf_mnist_test_images order by id;
```

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
