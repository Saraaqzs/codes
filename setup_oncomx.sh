#!/bin/bash
# Run this script within the codes directory to build the necessary elements for oncomx training
# Make sure that the correct conda environment is activated too

cd ../
git clone https://github.com/vdellabalda/pg2sqlite.git
cd pg2sqlite/initial-sync/py
pip install -r requirements.txt
cp *.py /scratch/codes/data/sft_data_collections/oncomx
cd ../../../

git clone https://github.com/ckosten/sciencebenchmark_dataset.git

cd codes/data/sft_data_collections
cd oncomx

#python ../../../../pg2sqlite/initial-sync/py/convert-schema.py "postgresql://uzh_user:bigdata%40uzh@160.85.252.195:5433/oncomx_v1_0_25?options=-csearch_path%3oncomx_v1_0_25" oncomx_v1_0_25_small.db
#python ../../../../pg2sqlite/initial-sync/py/convert-schema.py "postgresql://uzh_user:bigdata%40uzh@160.85.252.195:5433/oncomx_v1_0_25?options=-csearch_path%3Doncomx_v1_0_25" oncomx_v1_0_25_small.db
python export_to_csv.py  "postgresql://uzh_user:bigdata%40uzh@160.85.252.195:5433/oncomx_v1_0_25?options=-csearch_path%3Doncomx_v1_0_25" 'oncomx_v1_0_25' oncomx_v1_0_25_small_dir
python import_csv_to_sqlite.py oncomx_v1_0_25_small_dir oncomx_v1_0_25_small.sqlite oncomx_v1_0_25_small.sql
mkdir oncomx_v1_0_25_small
mv oncomx_v1_0_25_small.sqlite ./oncomx_v1_0_25_small/oncomx_v1_0_25_small.sqlite

cp ../../../../sciencebenchmark_dataset/oncomx/tables.json .
cp ../../../../sciencebenchmark_dataset/oncomx/dev.json .
cp ../../../../sciencebenchmark_dataset/oncomx/seed.json train.json

cd ../../../
python -u build_contents_index.py
python -u prepare_sft_datasets.py
