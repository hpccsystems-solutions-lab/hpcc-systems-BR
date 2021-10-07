# SIEEL 2021 Workshop
ECL course material for community workshops. The training cluster utilized during the workshop is: http://52.52.151.87:8010/.

# Client installation prerequisites
Download and install the latest ECL IDE version available from https://hpccsystems.com/download#HPCC-Platform. For detailed information on how to setup the ECL IDE, please watch this instructional video: https://www.youtube.com/watch?v=TT7rCcyWTAo
Download and install the latest git version available from https://git-scm.com/downloads
Install the required Machine Learning bundles using the ecl command line interface with administrator rights from your clienttools/bin folder (for further details, please visit: https://hpccsystems.com/download/free-modules/machine-learning-library):

```
cd “C:\Program Files (x86)\HPCCSystems\8.2.20\clienttools\bin” 
ecl bundle install https://github.com/hpcc-systems/ML_Core.git
ecl bundle install https://github.com/hpcc-systems/PBblas.git
ecl bundle install https://github.com/hpcc-systems/KMeans.git
ecl bundle install https://github.com/hpcc-systems/dbscan.git
ecl bundle install https://github.com/hpcc-systems/LinearRegression.git
ecl bundle install https://github.com/hpcc-systems/LogisticRegression.git
ecl bundle install https://github.com/hpcc-systems/GNN.git
ecl bundle install https://github.com/hpcc-systems/LearningTrees.git
```
**Note I**: Alternatively, by using your GitHub credentials, you can try the code examples directly via GitPod: https://gitpod.io/#https://github.com/hpcc-systems/Community-Workshops

**Note II**: The properties dataset is already sprayed and available in the training cluster utilized during the workshop and also available in the following link:https://github.com/alysson-oliveira/hpcc-systems-BR/blob/main/Data/propriedades.zip
