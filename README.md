# Vertica Machine Learning Example Data
Use the data in this repository to complete the Machine Learning examples
in the [Vertica documentation].

## Loading the data
To load the Machine Learning example data, run the following command
in the cloned repository:

```
$ vsql -f load_ml_data.sql
```

Alternatively, you can run each of the commands in the SQL file.

## Machine Learning Examples
For complete examples of each of the Machine Learning function, see the following links:
* [k-means]
* [Logistic Regression]
* [Linear Regression]
* [Data preparation]
* [SVM]

## Reference Documentation
[Vertica machine learning reference documentation]


[Vertica documentation]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/DownloadingMLExampleData.htm
[k-means]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/Kmeans/Kmeans.htm
[Logistic Regression]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/LogisticRegression/LogisticRegression.htm
[Linear Regression]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/LinearRegression/LinearRegression.htm
[Data preparation]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/DataPreparation/DataPreparation.htm
[SVM]: 
https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/SVM/SVM.htm
[Vertica machine learning reference documentation]: https://my.vertica.com/docs/latest/HTML/#Authoring/SQLReferenceManual/Functions/MachineLearning/MLAlgorithms.htm
