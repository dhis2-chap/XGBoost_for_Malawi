# XGBoost_for_Malawi
A CHAP implementation of XGBoost based on code from local modelers in Malawi. It trians a XGBoost model for each region individually. It uses the docker image in the repo docker_for-MadagascarArima. The model can be run through CHAP with the following command in the cli:
```bash
chap evaluate --model-name ../XGBoost_for_Malawi/ --dataset-csv ../XGBoost_for_Malawi/input/historic_data.csv  --report-filename report_XGBoost.pdf --debug --n-splits=1
```
