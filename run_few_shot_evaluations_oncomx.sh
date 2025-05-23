#!/bin/bash 

set -e

# --------------- Few-shot CodeS-1B --------------- #
# Oncomx's dev (1-shot)
#CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-1b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256 --pred_tag 1B_1S
#
## Oncomx's dev (3-shot)
#CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-1b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 3 --max_tokens 8192 --max_new_tokens 256
#
## Oncomx's dev (5-shot)
#CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-1b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256 --pred_tag 1B_5S
#
#
## --------------- Few-shot CodeS-3B --------------- #
## Oncomx's dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256 --pred_tag 3B_0S_oncomx
#
## Oncomx's dev (3-shot) 
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256 --pred_tag 3B_1S_oncomx
#
## Oncomx's dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256 --pred_tag 3B_5S_oncomx
#
#
## --------------- Few-shot CodeS-7B --------------- #
## Oncomx's dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256 --pred_tag 7B_0S_oncomx
#
## Oncomx's dev (3-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256 --pred_tag 7B_1S_oncomx
#
## Oncomx's dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256 --pred_tag 7B_5S_oncomx
#
#
# --------------- Few-shot CodeS-15B --------------- #
# Oncomx's dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256 --pred_tag 15B_0S_oncomx

# Oncomx's dev (3-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256 --pred_tag 15B_1S_oncomx

# Oncomx's dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_oncomx --table_num 25 --column_num 106 --dataset_path ./data/sft_oncomx_dev_text2sql.json --demonstration_set_path ./data/sft_oncomx_train_text2sql.json --num_of_demonstrations 3 --max_tokens 8192 --max_new_tokens 256 --pred_tag 15B_3S_oncomx
