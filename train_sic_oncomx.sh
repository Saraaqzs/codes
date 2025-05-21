set -e

# Train schema filter using Oncomx
python -u train_schema_item_filter.py \
    --batch_size 4 \
    --gradient_descent_step 8 \
    --device 0 \
    --learning_rate 1e-5 \
    --gamma 2.0 \
    --alpha 0.75 \
    --epochs 64 \
    --patience 8 \
    --seed 42 \
    --save_path ./sic_ckpts/sic_oncomx \
    --tensorboard_save_path ./train_logs/sic_oncomx \
    --train_filepath ./data/sft_oncomx_train_text2sql.json \
    --dev_filepath ./data/sft_oncomx_dev_text2sql.json \
    --model_name_or_path roberta-large \
    --mode train


