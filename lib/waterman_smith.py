# region of similarity, best match on large seq
# focusing on high scoring
# stop 0

from flask import Flask, request, jsonify
from typing import List

app = Flask(__name__)

# Scoring 
match_score = 3
mismatch_penalty = -1
gap_penalty = -2

# matrix 0
def smith_waterman(seq1: str, seq2: str) -> List[str]:
    n = len(seq1) + 1
    m = len(seq2) + 1
    score_matrix = [[0] * m for _ in range(n)]
    max_score = 0
    max_position = None
# matrix score
    for i in range(1, n):
        for j in range(1, m):
            match = score_matrix[i - 1][j - 1] + (match_score if seq1[i - 1] == seq2[j - 1] else mismatch_penalty)
            delete = score_matrix[i - 1][j] + gap_penalty
            insert = score_matrix[i][j - 1] + gap_penalty
            score_matrix[i][j] = max(0, match, delete, insert)

            if score_matrix[i][j] > max_score:
                max_score = score_matrix[i][j]
                max_position = (i, j)
# traceback
    align1, align2 = "", ""
    i, j = max_position
    while score_matrix[i][j] > 0:
        if score_matrix[i][j] == score_matrix[i - 1][j - 1] + (match_score if seq1[i - 1] == seq2[j - 1] else mismatch_penalty):
            align1 += seq1[i - 1]
            align2 += seq2[j - 1]
            i -= 1
            j -= 1
        elif score_matrix[i][j] == score_matrix[i - 1][j] + gap_penalty:
            align1 += seq1[i - 1]
            align2 += "-"
            i -= 1
        else:
            align1 += "-"
            align2 += seq2[j - 1]
            j -= 1

    align1 = align1[::-1]
    align2 = align2[::-1]

    return align1, align2, max_score

@app.route('/align', methods=['POST'])
def align_sequences():
    data = request.get_json()
    seq1 = data.get('seq1', "")
    seq2 = data.get('seq2', "")
    if not seq1 or not seq2:
        return jsonify({'error': 'Both sequences are required'}), 400
    alignment1, alignment2, score = smith_waterman(seq1, seq2)
    return jsonify({'alignment': [alignment1, alignment2], 'score': score})

if __name__ == '__main__':
    app.run(debug=True)
