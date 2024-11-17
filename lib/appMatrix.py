# similar lenght
# align entire seq
# comapring gene

from flask import Flask, request, jsonify
from typing import List

app = Flask(__name__)
#define value
def needleman_wunsch(seq1: str, seq2: str) -> List[str]:
    match_score = 1
    mismatch_penalty = -1
    gap_penalty = -2

#matrix + 1 voundary
    n, m = len(seq1) + 1, len(seq2) + 1
    score_matrix = [[0] * m for _ in range(n)]

#fill gap penal i ro, j column
    for i in range(n):
        score_matrix[i][0] = i * gap_penalty
    for j in range(m):
        score_matrix[0][j] = j * gap_penalty

#fill matrix
    for i in range(1, n):
        for j in range(1, m):
            match = score_matrix[i - 1][j - 1] + (match_score if seq1[i - 1] == seq2[j - 1] else mismatch_penalty)
            delete = score_matrix[i - 1][j] + gap_penalty
            insert = score_matrix[i][j - 1] + gap_penalty
            score_matrix[i][j] = max(match, delete, insert)

#backtarcking
    aligned_seq1, aligned_seq2 = "", ""
    i, j = n - 1, m - 1

    while i > 0 and j > 0:
        current = score_matrix[i][j]
        if current == score_matrix[i - 1][j - 1] + (match_score if seq1[i - 1] == seq2[j - 1] else mismatch_penalty):
            aligned_seq1 = seq1[i - 1] + aligned_seq1
            aligned_seq2 = seq2[j - 1] + aligned_seq2
            i, j = i - 1, j - 1
        elif current == score_matrix[i][j - 1] + gap_penalty:
            aligned_seq1 = "-" + aligned_seq1
            aligned_seq2 = seq2[j - 1] + aligned_seq2
            j -= 1
        else:
            aligned_seq1 = seq1[i - 1] + aligned_seq1
            aligned_seq2 = "-" + aligned_seq2
            i -= 1
#gap handling
    while i > 0:
        aligned_seq1 = seq1[i - 1] + aligned_seq1
        aligned_seq2 = "-" + aligned_seq2
        i -= 1
    while j > 0:
        aligned_seq1 = "-" + aligned_seq1
        aligned_seq2 = seq2[j - 1] + aligned_seq2
        j -= 1

    return [aligned_seq1, aligned_seq2]

#request handling
@app.route('/align', methods=['POST'])
def align_sequences():
    data = request.get_json()
    seq1 = data.get('seq1', "")
    seq2 = data.get('seq2', "")
    if not seq1 or not seq2:
        return jsonify({'error': 'Both sequences are required'}), 400
    aligned = needleman_wunsch(seq1, seq2)
    return jsonify({'alignment': aligned})

if __name__ == '__main__':
    app.run(debug=True)
