# Vertica TensorFlow Demo
## Introduction
As of Vertica 11, Vertica supports TensorFlow 2! Train your TensorFlow models in Python and then import them to your Vertica cluster to predict on in-database data.

This README is designed to be used alongside the [Vertica Tensorflow documentation](https://www.vertica.com/docs/latest/HTML/Content/Authoring/AnalyzingData/MachineLearning/UsingExternalModels/UsingTensorFlow/UsingTensorFlowModels.htm).

### A note about Vertica versions
TensorFlow support was introduced in Vertica 10.x.x, which only supports TF 1. TensorFlow 2 support was introduced in 11.x.x. There are also differences in the model input/output types allowed in each Vertica version. For details, see the tables below.

#### Supported Input Types

| Vertica Version | Float              | Double             | Int\*              |
| --------------- | :----------------: | :----------------: | :----------------: |
| 10.x.x          | :white_check_mark: | :white_check_mark: | :x:                |
| 11.x.x          | :white_check_mark: | :white_check_mark: | :x:                |
| 11.1.x          | :white_check_mark: | :white_check_mark: | :white_check_mark: |

\*Includes Int8, Int16, Int32, and Int64.

#### Supported Output Types

| Vertica Version | Float              | Double             | Int\* |
| --------------- | :----------------: | :----------------: | :---: |
| 10.x.x          | :white_check_mark: | :x:                | N/A   |
| 11.x.x          | :white_check_mark: | :x:                | N/A   |
| 11.1.x          | :white_check_mark: | :white_check_mark: | N/A   |

\*TF models cannot output an integer.

## TensorFlow 2 in Vertica
TensorFlow 2 brings many updates and improvements to TensorFlow, and is now the default TensorFlow version. It is recommended to use TF 2 instead of TF 1 and to port past models to TF 2.

### Training a simple TF 2 model
> **_NOTE:_**  Steps 1-5 should be performed outside of Vertica. For details, see the [Vertica documentation](https://www.vertica.com/docs/latest/HTML/Content/Authoring/AnalyzingData/MachineLearning/UsingExternalModels/UsingTensorFlow/TensorFlowExample.htm).

1. [Install TensorFlow](https://www.tensorflow.org/install).
2. Train and save the example model:
```bash
python3 train_simple_model.py
```
3. Convert your TF 2 model to the Vertica-compatible frozen graph format by running `freeze_tf2_model.py`, passing in the path to your saved model directory and (optionally) the directory name to save the frozen graph to (default: `saved_model_dir/frozen_tfmodel`).:
```bash
python3 freeze_tf2_model.py simple_model
```
This script also generates the required `tf_model_desc.json` file, which allows Vertica to translate between SQL tables Tensorflow Tensors.

While the automatically-generated file should work for most use cases, you may need to modify it if your model requires a complex mapping from/to Vertica tables. For details, see [tf_model_desc.json Overview](https://www.vertica.com/docs/latest/HTML/Content/Authoring/AnalyzingData/MachineLearning/UsingExternalModels/UsingTensorFlow/ModelDescJsonOverview.htm).

4. Copy the resulting frozen model folder (containing the .pb and .json files) to any node in your Vertica cluster.

5. Copy the `data/` directory and `load_tf_data.sql`.

6. Load the data into Vertica (your vsql alias may differ: e.q. $VSQL). The data folder must be in the same directory as the load_tf_data.sql file:
```bash
vsql -f load_tf_data.sql
```

7. Import your trained model:
> **_NOTE:_**  The imported model takes on the name of the folder containing the .pb file, so rename this folder prior to import if you want a different name.
```sql
SELECT import_models('path/to/frozen_tfmodel' USING PARAMETERS category='TENSORFLOW');
```

8. Predict with your model in Vertica:
```sql
SELECT PREDICT_TENSORFLOW (*
                   USING PARAMETERS model_name='frozen_tfmodel', num_passthru_cols=1)
                   OVER(PARTITION BEST) FROM tf_mnist_test_images ORDER BY id;
-- to view the actual (observed) labels:
SELECT * FROM tf_mnist_test_labels ORDER BY id;
```

### Training a multi-input TensorFlow 2 model
Some tasks require a model that can accept multiple inputs which cannot be grouped into a single Tensor. While this is a toy example, it illustrates how to train and freeze a multi-input model. Follow the instructions in the section above, with the following modifications:

- In step 2, run `train_multi_input_model.py` (rather than `train_simple_model.py`).
- In step 3, use the `multi_input_model` directory (rather than `simple_model`).
- In step 8, run the following query to start the prediction:
```sql
SELECT PREDICT_TENSORFLOW (id, label, x, y 
                   USING PARAMETERS model_name='frozen_multi_model', num_passthru_cols=2)
                   OVER(PARTITION BEST) AS (id, true_label, pred_label)
                   FROM tf_cluster_data ORDER BY id;
-- to view the actual (observed) labels:
SELECT * FROM tf_mnist_test_labels ORDER BY id;
```

## Training a TensorFlow 1 model (deprecated)
1. [Install TensorFlow](https://www.tensorflow.org/install/pip#virtualenv-install) 1.15 on your system.
> **_NOTE:_**  To install Tensorflow 1.15, use `pip install tensorflow==1.15` in the last step in the procedure above. If `pip` cannot find this version of TensorFlow, downgrade your Python version to 3.7 or below.
2. Navigate to the `tf1` directory.
3. Run `python3 train_save_model.py`.
4. Move/copy the entire `tf_mnist_keras` directory to your Vertica cluster.
5. Run `import_models`:
```sql
SELECT import_models('path/to/tf_mnist_keras' USING parameters category='TENSORFLOW');
```
6. See the [Vertica documentation](https://www.vertica.com/docs/latest/HTML/Content/Authoring/AnalyzingData/MachineLearning/UsingExternalModels/UsingTensorFlow/TensorFlowExample.htm) for further instructions.

## Sources
Data obtained from [MNIST database](http://yann.lecun.com/exdb/mnist/).
