#!/usr/bin/env python3

import csv
import sys
import pandas as pd
import numpy as np
from Bio import pairwise2
from Bio import SeqIO
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression

def process_csv(args):
    fin, fout = args
    data_in = pd.read_csv(fin)

    data = data_in.drop(columns=['Name','Surname'],axis=1)
    data = data.dropna(how='any')

    Y = data['Result']
    X = data.drop(columns=['Result'])
    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.1, random_state=9)

    logreg = LogisticRegression(C=10)
    logreg.fit(X_train, Y_train)
    Y_predict_logreg = logreg.predict(X_test)
    score_logreg = logreg.score(X_test, Y_test)

    f = open(fout, 'w')
    f.write(np.array2string(score_logreg))
    f.close()

def process_fasta(args):
    fin_1, fin_2, fout = args
    data_in_1 = SeqIO.read(fin_1, 'fasta')
    data_in_2 = SeqIO.read(fin_2, 'fasta')
    content = []

    pairwise_score = pairwise2.align.globalxx(data_in_1.seq, data_in_2.seq, score_only=True)
    pairwise_similarity = pairwise_score / max(len(data_in_1.seq), len(data_in_2.seq))

    protain_1 = data_in_1.seq.transcribe().translate()
    protain_2 = data_in_2.seq.transcribe().translate()

    protain_score = pairwise2.align.globalxx(protain_1, protain_2, score_only=True)
    protain_similarity = protain_score / max(len(protain_1), len(protain_2))

    header = ['seq1', 'seq2', 'pairwise_similarity', 'protain_similarity']
    content.append([fin_1, fin_2, pairwise_similarity, protain_similarity])

    with open(fout, 'a', newline='') as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(content)
        f.close()



if __name__ == "__main__":
    #process_csv(sys.argv[1:])
    process_fasta(sys.argv[1:])