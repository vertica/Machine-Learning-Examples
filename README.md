# Vertica Machine Learning Example Data
Use the data in this repository to complete the Machine Learning examples
in the [Vertica documentation].

## Loading  data
To load the Machine Learning example data, run the following command
in 'data' directory of the cloned repository:

```
$ vsql -f load_ml_data.sql
```

Alternatively, you can run the indiviudal commands in the SQL file to load a particular data set.

## Machine Learning Examples
For complete examples of each of the Machine Learning function, see the following links:
* [Data preparation]
* [k-means]
* [Linear Regression]
* [Logistic Regression]
* [Naive Bayes]
* [Random Forest]
* [SVM Classification]
* [SVM Regression]

## Reference Documentation
[Vertica machine learning reference documentation]


[Vertica documentation]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/DownloadingMLExampleData.htm
[Data preparation]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/DataPreparation/DataPreparation.htm
[k-means]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/Kmeans/Kmeans.htm
[Linear Regression]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/LinearRegression/LinearRegression.htm
[Logistic Regression]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/LogisticRegression/LogisticRegression.htm
[Naive Bayes]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/NaiveBayes/NaiveBayes.htm
[Random Forest]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/RandomForest/RandomForest.htm
[SVM Classification]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/SVM/SVM.htm
[SVM Regression]: https://my.vertica.com/docs/latest/HTML/index.htm#Authoring/AnalyzingData/MachineLearning/SVM/SVM__SupportVectorMachine_forRegression.htm
[Vertica machine learning reference documentation]: https://my.vertica.com/docs/latest/HTML/#Authoring/SQLReferenceManual/Functions/MachineLearning/MLAlgorithms.htm
