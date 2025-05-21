from utils.db_utils import get_cursor_from_path, execute_sql_long_time_limitation, execute_sql_streaming
import json
import os, shutil

def remove_contents_of_a_folder(index_path):
    # if index_path does not exist, then create it
    os.makedirs(index_path, exist_ok = True)
    # remove files in index_path
    for filename in os.listdir(index_path):
        file_path = os.path.join(index_path, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
        except Exception as e:
            print('Failed to delete %s. Reason: %s' % (file_path, e))

#def build_content_index(db_path, index_path):
#    '''
#    Create a BM25 index for all contents in a database
#    '''
#    cursor = get_cursor_from_path(db_path)
#    results = execute_sql_long_time_limitation(cursor, "SELECT name FROM sqlite_master WHERE type='table';")
#    table_names = [result[0] for result in results]
#
#    all_column_contents = []
#    for table_name in table_names:
#        # skip SQLite system table: sqlite_sequence
#        if table_name == "sqlite_sequence":
#            continue
#        results = execute_sql_long_time_limitation(cursor, "SELECT name FROM PRAGMA_TABLE_INFO('{}')".format(table_name))
#        column_names_in_one_table = [result[0] for result in results]
#        for column_name in column_names_in_one_table:
#            try:
#                print("SELECT DISTINCT `{}` FROM `{}` WHERE `{}` IS NOT NULL;".format(column_name, table_name, column_name))
#                results = execute_sql_long_time_limitation(cursor, "SELECT DISTINCT `{}` FROM `{}` WHERE `{}` IS NOT NULL;".format(column_name, table_name, column_name))
#                column_contents = [str(result[0]).strip() for result in results]
#
#                for c_id, column_content in enumerate(column_contents):
#                    # remove empty and extremely-long contents
#                    if len(column_content) != 0 and len(column_content) <= 25:
#                        all_column_contents.append(
#                            {
#                                "id": "{}-**-{}-**-{}".format(table_name, column_name, c_id).lower(),
#                                "contents": column_content
#                            }
#                        )
#            except Exception as e:
#                print(str(e))
#
#    os.makedirs('./data/temp_db_index', exist_ok = True)
#    
#    with open("./data/temp_db_index/contents.json", "w") as f:
#        f.write(json.dumps(all_column_contents, indent = 2, ensure_ascii = True))
#
#    # Building a BM25 Index (Direct Java Implementation), see https://github.com/castorini/pyserini/blob/master/docs/usage-index.md
#    cmd = "python -m pyserini.index.lucene --collection JsonCollection --input ./data/temp_db_index --index {} --generator DefaultLuceneDocumentGenerator --threads 16 --storePositions --storeDocvectors --storeRaw".format(index_path)
#    
#    d = os.system(cmd)
#    print(d)
#    os.remove("./data/temp_db_index/contents.json")

# Re-run the optimized streaming version of the build_content_index function after state reset


def build_content_index_streaming(db_path, index_path):

    cursor, conn = get_cursor_from_path(db_path)
    results = execute_sql_long_time_limitation(cursor, "SELECT name FROM sqlite_master WHERE type='table';")
    table_names = [result[0] for result in results]

    os.makedirs('./data/temp_db_index', exist_ok=True)
    output_path = "./data/temp_db_index/contents.jsonl"

    with open(output_path, "w", encoding="utf-8") as f:
        for table_name in table_names:
            if table_name == "sqlite_sequence":
                continue

            results = execute_sql_long_time_limitation(cursor, f"SELECT name FROM PRAGMA_TABLE_INFO('{table_name}')")
            column_names = [result[0] for result in results]
 
            results = execute_sql_long_time_limitation(cursor, f"SELECT type FROM PRAGMA_TABLE_INFO('{table_name}')")
            column_types = [result[0] for result in results]
            
            for column_name, column_type in zip(column_names, column_types):
                found = False
                for c_type in ['integer', 'real', 'numeric', 'int', 'float', 'double']:
                    if c_type in column_type.lower():
                        found = True
                if found:
                    continue
                try:
                    query = f"SELECT DISTINCT `{column_name}` FROM `{table_name}` WHERE `{column_name}` IS NOT NULL;"
                    print(query)

                    for r_id, row in enumerate(execute_sql_streaming(cursor, query)):
                        column_content = str(row[0]).strip()
                        if 0 < len(column_content) <= 25:
                            entry = {
                                "id": f"{table_name}-**-{column_name}-**-{r_id}".lower(),
                                "contents": column_content
                            }
                            f.write(json.dumps(entry, ensure_ascii=True) + "\n")

                except Exception as e:
                    print(f"⚠️ Error processing {table_name}.{column_name}: {e}")


    # Build BM25 index
    cmd = (
        f"python -m pyserini.index.lucene --collection JsonCollection "
        f"--input ./data/temp_db_index --index {index_path} --generator DefaultLuceneDocumentGenerator "
        f"--threads 2 --storePositions --storeDocvectors --storeRaw"
    )
    d = os.system(cmd)
    print("BM25 index build return code:", d)

    #os.remove(output_path)
    conn.close()



def build_content_index(db_path, index_path):
    '''
    Create a BM25 index for all contents in a database, memory-safe version.
    '''
    cursor = get_cursor_from_path(db_path)
    results = execute_sql_long_time_limitation(cursor, "SELECT name FROM sqlite_master WHERE type='table';")
    table_names = [result[0] for result in results]

    os.makedirs('./data/temp_db_index', exist_ok=True)
    output_path = "./data/temp_db_index/contents.jsonl"

    with open(output_path, "w", encoding="utf-8") as f:
        for table_name in table_names:
            if table_name == "sqlite_sequence":
                continue

            results = execute_sql_long_time_limitation(cursor, f"SELECT name FROM PRAGMA_TABLE_INFO('{table_name}')")
            column_names_in_one_table = [result[0] for result in results]

            for column_name in column_names_in_one_table:
                try:
                    query = f"SELECT DISTINCT `{column_name}` FROM `{table_name}` WHERE `{column_name}` IS NOT NULL;"
                    print(query)
                    results = execute_sql_long_time_limitation(cursor, query)

                    for r_id, result in enumerate(results):
                        column_content = str(result[0]).strip()
                        if 0 < len(column_content) <= 25:
                            entry = {
                                "id": f"{table_name}-**-{column_name}-**-{r_id}".lower(),
                                "contents": column_content
                            }
                            f.write(json.dumps(entry, ensure_ascii=True) + "\n")

                except Exception as e:
                    print(str(e))
    #os.system(f"cp {output_path} /cluster/home/aliq/codes/data/sft_data_collections/sdss/") 
    # Build BM25 index
    #cmd = (
    #    f"python -m pyserini.index.lucene --collection JsonCollection "
    #    f"--input ./data/temp_db_index --index {index_path} --generator DefaultLuceneDocumentGenerator "
    #    f"--threads 1 --storePositions --storeDocvectors --storeRaw"
    #)
    #d = os.system(cmd)
    #print("BM25 index build return code:", d)

    #os.remove(output_path)


if __name__ == "__main__":
    
    #print("build content index for Oncomx's training set...")
    #remove_contents_of_a_folder("./data/sft_data_collections/oncomx/db_contents_index")
    ## build content index for Oncomx's training set databases
    #build_content_index(
    #    os.path.join("./data/sft_data_collections/oncomx/", "oncomx_v1_0_25_small", "oncomx_v1_0_25_small.sqlite"),
    #    os.path.join("./data/sft_data_collections/oncomx/db_contents_index/", "oncomx_v1_0_25_small")
    #)

    #print("build content index for Cordis's training set...")
    #remove_contents_of_a_folder("./data/sft_data_collections/cordis/db_contents_index")
    ## build content index for Oncomx's training set databases
    #build_content_index_streaming(
    #    os.path.join("./data/sft_data_collections/cordis/", "cordis_temporary", "cordis_temporary.sqlite"),
    #    os.path.join("./data/sft_data_collections/cordis/db_contents_index/", "cordis")
    #)

    print("build content index for SDSS's training set...")
    remove_contents_of_a_folder("./data/sft_data_collections/sdss/db_contents_index")
    # build content index for Oncomx's training set databases
    build_content_index_streaming(
        os.path.join("./data/sft_data_collections/sdss/", "skyserver_dr16_2020_11_30", "skyserver_dr16_2020_11_30.sqlite"),
       os.path.join("./data/sft_data_collections/sdss/db_contents_index/", "sdss")
    )

    #print("build content index for SDSS's training set...")
    #remove_contents_of_a_folder("./data/sft_data_collections/sdss/db_contents_index")
    ## build content index for SDSS's training set databases
    #build_content_index(
    #    os.path.join("./data/sft_data_collections/sdss/", "sdss_lite.sqlite"),
    #    os.path.join("./data/sft_data_collections/sdss/db_contents_index/", "sdss_lite")
    #)
#
    #    print("build content index for SDSS's dev set databases...")
    #    remove_contents_of_a_folder("./data/sft_data_collections/sdss/dev/db_contents_index")
    #    # build content index for SDSS's dev set databases
    #    for db_id in os.listdir("./data/sft_data_collections/sdss/dev/dev_databases"):
    #        print(db_id)
    #        build_content_index(
    #            os.path.join("./data/sft_data_collections/sdss/dev/dev_databases/", db_id, db_id + ".sqlite"),
    #            os.path.join("./data/sft_data_collections/sdss/dev/db_contents_index/", db_id)
    #        )

    # print("build content index for BIRD's training set databases...")
    # remove_contents_of_a_folder("./data/sft_data_collections/bird/train/db_contents_index")
    # # build content index for BIRD's training set databases
    # for db_id in os.listdir("./data/sft_data_collections/bird/train/train_databases"):
    #     if db_id.endswith(".json"):
    #         continue
    #     print(db_id)
    #     build_content_index(
    #         os.path.join("./data/sft_data_collections/bird/train/train_databases/", db_id, db_id + ".sqlite"),
    #         os.path.join("./data/sft_data_collections/bird/train/db_contents_index/", db_id)
    #     )
    #
    # print("build content index for BIRD's dev set databases...")
    # remove_contents_of_a_folder("./data/sft_data_collections/bird/dev/db_contents_index")
    # # build content index for BIRD's dev set databases
    # for db_id in os.listdir("./data/sft_data_collections/bird/dev/dev_databases"):
    #     print(db_id)
    #     build_content_index(
    #         os.path.join("./data/sft_data_collections/bird/dev/dev_databases/", db_id, db_id + ".sqlite"),
    #         os.path.join("./data/sft_data_collections/bird/dev/db_contents_index/", db_id)
    #     )
    #
    # print("build content index for spider's databases...")
    # remove_contents_of_a_folder("./data/sft_data_collections/spider/db_contents_index")
    # # build content index for spider's databases
    # for db_id in os.listdir("./data/sft_data_collections/spider/database"):
    #     print(db_id)
    #     build_content_index(
    #         os.path.join("./data/sft_data_collections/spider/database/", db_id, db_id + ".sqlite"),
    #         os.path.join("./data/sft_data_collections/spider/db_contents_index/", db_id)
    #     )
    #
    # print("build content index for Dr.Spider's 17 perturbation test sets...")
    # # build content index for Dr.Spider's 17 perturbation test sets
    # test_set_names = os.listdir("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data")
    # test_set_names.remove("Spider-dev")
    # for test_set_name in test_set_names:
    #     if test_set_name.startswith("DB_"):
    #         remove_contents_of_a_folder(os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "db_contents_index"))
    #         for db_id in os.listdir(os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "database_post_perturbation")):
    #             print(db_id)
    #             build_content_index(
    #                 os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "database_post_perturbation", db_id, db_id + ".sqlite"),
    #                 os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "db_contents_index", db_id)
    #             )
    #     else:
    #         remove_contents_of_a_folder(os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "db_contents_index"))
    #         for db_id in os.listdir(os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "databases")):
    #             if db_id in ["README.md", "database_original"]:
    #                 continue
    #             print(db_id)
    #             build_content_index(
    #                 os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "databases", db_id, db_id + ".sqlite"),
    #                 os.path.join("./data/sft_data_collections/diagnostic-robustness-text-to-sql/data/", test_set_name, "db_contents_index", db_id)
    #             )
    #
    # print("build content index for Bank_Financials and Aminer_Simplified training set databases...")
    # remove_contents_of_a_folder("./data/sft_data_collections/domain_datasets/db_contents_index")
    # # build content index for Bank_Financials's training set databases
    # for db_id in os.listdir("./data/sft_data_collections/domain_datasets/databases"):
    #     print(db_id)
    #     build_content_index(
    #         os.path.join("./data/sft_data_collections/domain_datasets/databases/", db_id, db_id + ".sqlite"),
    #         os.path.join("./data/sft_data_collections/domain_datasets/db_contents_index/", db_id)
    #     )

