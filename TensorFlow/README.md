# Vertica TensorFlow Demo
## Intro
As of Vertica 11, Vertica now supports TensorFlow 2! Train your TensorFlow models in Python outside of Vertica and then import them to your Vertica cluster for prediction on in-database data. This README is designed to be used alongside the [Vertica Tensorflow Documentation](https://www.vertica.com/docs/11.1.x/HTML/Content/Authoring/AnalyzingData/MachineLearning/UsingExternalModels/UsingTensorFlow/TensorFlowExample.htm).

### A note about Vertica versions
TensorFlow support was introduced in Vertica 10.x.x, which only supports TF 1. TensorFlow 2 support was introduced in 11.x.x. There are also differences in the model input/output types allowed in each Vertica version, see the tables below.

#### Supported Input Types:

| Vertica Version | Float | Double | Int\* |
| --------------- | ----- | ------ | ----- |
| 10.x.x          | :white_check_mark:   | Yes    | :x:    |
| 11.x.x          | Yes   | Yes    | No    |
| 11.1.x          | Yes   | Yes    | Yes   |

\*Includes Int8, Int16, Int32, and Int64.

#### Supported Output Types:

| Vertica Version | Float | Double | Int\* |
| --------------- | ----- | ------ | ----- |
| 10.x.x          | Yes   | No     | N/A   |
| 11.x.x          | Yes   | No     | N/A   |
| 11.1.x          | Yes   | Yes    | N/A   |

\*There is no way to output an integer from a TF model.

## TensorFlow 2 in Vertica
TensorFlow 2 brings many updates and improvements to TensorFlow, and is now the default TensorFlow version. It is recommended to use TF 2 instead of TF 1 and to port past models to TF 2.

### Training a simple TF 2 model
> **_NOTE:_**  Steps 1 - 5 should be performed outside of Vertica. See the Vertica Documentation (link above) for more details.

1. [Install TensorFlow](https://www.tensorflow.org/install)
2. Train and save the example model:
```bash
python3 train_simple_model.py
```
3. In order for Vertica to successfully import your model, it must be transformed into a frozen graph file, we provide a script to do this for TF2 models. Run the freeze_tf2_model.py script, passing in the path to your saved model directory and optionally the directory name to save the frozen graph to (default is saved_model_dir/frozen_tfmodel):
```bash
python3 freeze_tf2_model.py simple_model
```
This script also auto-generates the required tf_model_desc.json file, which allows Vertica to translate from SQL tables to Tensorflow Tensors. This generated file should work for most cases, but if your model requires a complex mapping from/to Vertica tables you may need to modify it (see the Vertica documentation).

4. Copy the resulting folder (just the frozen model folder with the .pb and .json files) to any node in your Vertica cluster, also copy the data/ directory and load_tf_data.sql.

5. Load the data into Vertica (your vsql alias may differ: e.q. $VSQL). The data folder must be in the same directory as the load_tf_data.sql file:
```bash
vsql -f load_tf_data.sql
```

6. Import your trained model:
```sql
select import_models('path/to/frozen_tfmodel' using parameters category='TENSORFLOW');
```

> **_NOTE:_**  The imported model will take on the name of the folder that the .pb file was in, so rename this folder prior to import if you want a different name.

7. Predict with your model in Vertica!
```sql
select PREDICT_TENSORFLOW (*
                   USING PARAMETERS model_name='frozen_tfmodel', num_passthru_cols=1)
                   OVER(PARTITION BEST) FROM tf_mnist_test_images order by id;
-- to view the actual (observed) labels, do:
select * from tf_mnist_test_labels order by id;
```

### Training a multi-input TF 2 model
Some tasks require a model which can accept multiple inputs which cannot be grouped into a single Tensor. While this is a toy example, it illustrates how to train and freeze a multi-input model. Follow the instructions in the section above, with the following exceptions:

- In step 2, substitute `train_multi_input_model.py` instead of `train_simple_model.py`.
- In step 3, substitute the `multi_input_model` directory instead of `simple_model`.
- Steps 4 - 6 remain unchanged.
- In step 7, run this SQL statement instead:
```sql
select PREDICT_TENSORFLOW (id, label, x, y 
                   USING PARAMETERS model_name='frozen_multi_model', num_passthru_cols=2)
                   OVER(PARTITION BEST) as (id, true_label, pred_label)
                   FROM tf_cluster_data order by id;
-- to view the actual (observed) labels, do:
select * from tf_mnist_test_labels order by id;
```

## Training a TF 1 model (deprecated)
1. [Install TensorFlow](https://www.tensorflow.org/install/pip#virtualenv-install) 1.15 on your system. Note: To install a specific version do `pip install tensorflow==1.15` in the last step. If this version of TensorFlow is not found, you may need to downgrade your python version (TF 1 is not supported on Python 3.8 and newer)
2. Change to the `tf1` directory.
3. Run `python3 train_save_model.py`.
4. Move/copy the entire tf_mnist_keras directory to your Vertica cluster, then run the import TF model command:
```sql
select import_models('path/to/tf_mnist_keras' using parameters category='TENSORFLOW');
```
5. See Vertica Doc for further instructions.

## Sources
Data obtained from http://yann.lecun.com/exdb/mnist/
