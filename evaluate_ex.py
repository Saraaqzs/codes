import sqlite3
import json
import argparse
from collections import Counter
from func_timeout import func_set_timeout, FunctionTimedOut

def parse_option():
    parser = argparse.ArgumentParser()
    
    parser.add_argument('--pred', type = str, default = "pred_sqls.txt")
    parser.add_argument('--gold', type = str, default = "./data/test.json")
    parser.add_argument('--db', type = str, default = "./data/database/everbright_bank/everbright_bank.sqlite")
    
    opt = parser.parse_args()

    return opt

@func_set_timeout(900)
def execute_sql(cursor, sql):
    cursor.execute(sql)
    sql_res = cursor.fetchmany(1000)

    return sql_res

def normalize_row(row):
    return tuple(sorted(Counter(row).items(), key=lambda x: str(x[0])))

def compare_sql(predicted_sql, ground_truth, db_path):
    conn = sqlite3.connect(db_path, check_same_thread = False)
    # Connect to the database
    cursor = conn.cursor()
    try:
        ground_truth_res = execute_sql(cursor, ground_truth)
    except FunctionTimedOut as fto:
        print("raises an error: time out.")
        return 0, 0, None, None
    #gt_desc = cursor.execute(ground_truth).description

    try:
        predicted_res = execute_sql(cursor, predicted_sql)
    #    pred_desc = cursor.execute(predicted_sql).description

    except Exception as e:
        print("raises an error: {}.".format(str(e)))
        return 0, 0, None, ground_truth_res
    except FunctionTimedOut as fto:
        print("raises an error: time out.")
        return 0, 0, None, ground_truth_res

    #gt_col_names = [col[0].replace(" ","") for col in gt_desc]
    #pred_col_names = [col[0].replace(" ","") for col in pred_desc]
         
    # Build an index map to reorder predicted columns
    #res = 1
    #try:
    #    index_map = [pred_col_names.index(col) for col in gt_col_names]
    #except Exception as e:
    #    print("Columns do not match")
    #    print(gt_col_names)
    #    print(pred_col_names)
    #    res = 0
    
    strict_res = 0
    if predicted_res == ground_truth_res:
        strict_res = 1

    res = 0
    gt_norm = [normalize_row(row) for row in ground_truth_res]
    pred_norm = [normalize_row(row) for row in predicted_res]
    #pred_rows_reordered = [tuple(row[i] for i in index_map) for row in predicted_res]
    if "ORDER BY" not in ground_truth:
        c1 = Counter(gt_norm)
        c2 = Counter(pred_norm)
        res = int(c1==c2)
    elif gt_norm == pred_norm:
        res = 1

    return strict_res, res, predicted_res, ground_truth_res

if __name__ == "__main__":
    opt = parse_option()
    pred_sqls = [line.strip() for line in open(opt.pred).readlines()]
    questions = [data["question"] for data in json.load(open(opt.gold))]
    ground_truth_sqls = [data["sql"] for data in json.load(open(opt.gold))]

    results = []
    strict_results = []
    for question, pred, ground_truth in zip(questions, pred_sqls, ground_truth_sqls):
        # print(ground_truth)
        strict_res, res, predicted_res, ground_truth_res = compare_sql(pred, ground_truth, opt.db)
        
        if res == 0 and strict_res == 0:
            print("WRONG")
            print("question:", question)
            print("pred sql:", pred)
            print("gt sql:", ground_truth)
            if predicted_res is not None:
                print("results of pred sql:", predicted_res[:20])
            else:
                print("results of pred sql: None")
            print("results of gt sql:", ground_truth_res[:20])
            print("-"*30)
        
        elif res == 1 and strict_res == 0:
            print("CORRECT (only soft)")
            print("question:", question)
            print("pred sql:", pred)
            print("gt sql:", ground_truth)
            print("results of pred sql:", predicted_res[:20])
            print("results of gt sql:", ground_truth_res[:20])
            print("-"*30)
        
        if res == 0 and strict_res == 1:
            print("CORRECT (only strict)")
            print("question:", question)
            print("pred sql:", pred)
            print("gt sql:", ground_truth)
            print("results of pred sql:", predicted_res[:20])
            print("results of gt sql:", ground_truth_res[:20])
            print("-"*30)

        if res == 1 and strict_res == 1:
            print("CORRECT (full)")
            print("question:", question)
            print("pred sql:", pred)
            print("gt sql:", ground_truth)
            print("results of pred sql:", predicted_res[:20])
            print("results of gt sql:", ground_truth_res[:20])
            print("-"*30)

        results.append(res)
        strict_results.append(strict_res)
    
    print("EX score:", sum(results)/len(results))
    print("EX score (strict):", sum(strict_results)/len(strict_results))
