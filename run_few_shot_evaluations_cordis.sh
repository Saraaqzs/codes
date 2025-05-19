#!/bin/bash

set -e

# --------------- Few-shot CodeS-3B --------------- #
# cordis' dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 3B_0S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 3B_1S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 3B_5S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256
#
#
## --------------- Few-shot CodeS-7B --------------- #
# cordis' dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 7B_0S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 7B_1S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 7B_5S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256
#
#
## --------------- Few-shot CodeS-7B-merged --------------- #
# cordis' dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b-merged --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 7Bm_0S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b-merged --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 7Bm_1S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b-merged --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 7Bm_5S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256
#
#
#
# --------------- Few-shot CodeS-15B --------------- #
# cordis' dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 15B_0S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 15B_1S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256
#
## cordis' dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_cordis --table_num 19 --column_num 82 --dataset_path ./data/sft_cordis_dev_text2sql.json --pred_tag 15B_5S --demonstration_set_path ./data/sft_cordis_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256
#
