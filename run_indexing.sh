#!/bin/bash
set -e

# === CONFIGURATION ===
INPUT_JSONL="./data/temp_db_index/contents.jsonl"
SPLIT_DIR="./data/temp_db_index/splits"
SHARD_DIR="./data/temp_db_index/shards"
INDEX_BASE_DIR="./indexes"
FINAL_INDEX_NAME="oncomx_final_index"
LINES_PER_SHARD=1000000
THREADS=4

# === STEP 1: Split the main JSONL file ===
echo "🔹 Splitting input into chunks of $LINES_PER_SHARD lines..."
mkdir -p "$SPLIT_DIR"
mkdir -p "$SHARD_DIR"
split -l $LINES_PER_SHARD "$INPUT_JSONL" "$SPLIT_DIR/part_"

# === STEP 2: Move each part into its own directory as docs.json ===
echo "🔹 Organizing shards..."
for f in "$SPLIT_DIR"/part_*; do
  shard_name=$(basename "$f")
  mkdir -p "$SHARD_DIR/$shard_name"
  mv "$f" "$SHARD_DIR/$shard_name/docs.json"
done

# === STEP 3: Index each shard separately ===
mkdir -p "$INDEX_BASE_DIR"
echo "🔹 Indexing each shard..."
for shard_path in "$SHARD_DIR"/*; do
  shard_name=$(basename "$shard_path")
  index_path="$INDEX_BASE_DIR/$shard_name"
  echo "  📦 Indexing $shard_name into $index_path"
  python -m pyserini.index.lucene \
    --collection JsonCollection \
    --input "$shard_path" \
    --index "$index_path" \
    --generator DefaultLuceneDocumentGenerator \
    --impact \
    --threads $THREADS
done

# === STEP 4: Merge all indices ===
echo "🔹 Merging all shard indices into $FINAL_INDEX_NAME..."
index_paths=$(find "$INDEX_BASE_DIR" -maxdepth 1 -mindepth 1 -type d | tr '\n' ' ')
python -m pyserini.index.merge \
  --indexes $index_paths \
  --index "$INDEX_BASE_DIR/$FINAL_INDEX_NAME"

echo "✅ Done. Final index is at: $INDEX_BASE_DIR/$FINAL_INDEX_NAME"

