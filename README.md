# ERAD | ERAMIA 2021 Workshop
ECL course material for community workshops. The training cluster utilized during the workshop is: http://54.215.2.79:8010/.

# During the workshop GitPod will be used as main environment:
1. By using your GitHub credentials, just click on the following link for instantiate a environment via GitPod: https://gitpod.io/#https://github.com/hpccsystems-solutions-lab/hpcc-systems-BR

**Note I**: Alternatively, you can use the ECL IDE:
1. Download and install the latest ECL IDE version available from https://hpccsystems.com/download#HPCC-Platform. For detailed information on how to setup the ECL IDE, please watch this instructional video: https://www.youtube.com/watch?v=TT7rCcyWTAo
2. Download and install the latest git version available from https://git-scm.com/downloads
3. Install the required Machine Learning bundles using the ecl command line interface with administrator rights from your clienttools/bin folder (for further details, please visit: https://hpccsystems.com/download/free-modules/machine-learning-library):

```
cd “C:\Program Files (x86)\HPCCSystems\8.2.20\clienttools\bin” 
ecl bundle install https://github.com/hpcc-systems/ML_Core.git
ecl bundle install https://github.com/hpcc-systems/LearningTrees.git
ecl bundle install https://github.com/hpcc-systems/Visualizer.git
ecl bundle install https://github.com/hpcc-systems/DataPatterns.git
```

**Note II**: The properties dataset is already sprayed and available in the training cluster utilized during the workshop and also available in the following link:https://github.com/hpccsystems-solutions-lab/hpcc-systems-BR/raw/main/Data/propriedades.csv
