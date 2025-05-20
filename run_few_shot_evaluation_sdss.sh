#!/bin/bash

set -e

# --------------- Few-shot CodeS-3B --------------- #
# sdss' dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_sdss --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 3B_0S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256 
#
## sdss' dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_sdss --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 3B_1S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256
#
## sdss' dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-3b --sic_path ./sic_ckpts/sic_sdss --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 3B_5S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256
#
#
## --------------- Few-shot CodeS-7B --------------- #
# sdss' dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_sdss --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 7B_0S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256
#
## sdss' dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_sdss --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 7B_1S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256
#
## sdss' dev (5-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-7b --sic_path ./sic_ckpts/sic_sdss --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 7B_5S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 5 --max_tokens 8192 --max_new_tokens 256
#
# --------------- Few-shot CodeS-15B --------------- #
# sdss' dev (0-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_cordis --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 15B_0S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 0 --max_tokens 8192 --max_new_tokens 256
#
## sdss' dev (1-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_cordis --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 15B_1S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 1 --max_tokens 8192 --max_new_tokens 256
#
## sdss' dev (3-shot)
CUDA_VISIBLE_DEVICES=0 python -u text2sql_few_shot.py --llm_path seeklhy/codes-15b --sic_path ./sic_ckpts/sic_cordis --table_num 6 --column_num 61 --dataset_path ./data/sft_sdss_dev_text2sql.json --pred_tag 15B_3S_sdss --demonstration_set_path ./data/sft_sdss_train_text2sql.json --num_of_demonstrations 3 --max_tokens 8192 --max_new_tokens 256
#
