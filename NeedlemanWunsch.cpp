#include <iostream>
#include <string>
#include <vector>

using namespace std;

const int gap_penalty = -1;

void printMatrix(int **matrix) {
   for (int i=0; i < sizeof(matrix[0]); i++) {
      for (int j=0; j < sizeof(matrix[1]); j++) {
         cout << matrix[i][j] << endl;
      }
   }
}

int score(const char &a, const char &b) {
   if (a == b) 
      return 1;
   return -1;
}

// Score not passed two characters
int score(const char &a) {
   return gap_penalty;
}

int findMaxIndex (const int scores[], int numCount) {
   int maxIndex = 0;
   for (int i=0; i < numCount; i++) {
      if (scores[i] > maxIndex) 
         maxIndex=i;
   }
}

int main (int argc, char* argv[]) {


   for (int i=0; i < argc; i++) {
      //cout << argv[i] << endl;
   }

   string seq1 = argv[1];
   string seq2 = argv[2];

   int scoreMatrix[seq1.length() + 1][seq2.length() + 1];


   for (int i=0; i < seq1.length() + 1; i++) {
      scoreMatrix[i][0] = i * gap_penalty;
   }
   
   for (int j=0; j < seq2.length() + 1; j++) {
      scoreMatrix[0][j] = j * gap_penalty;
   }

   for (int i=0; i < seq1.length() + 1; i++) {
      for (int j=0; j < seq2.length() + 1; j++) {
         char lettera = seq1[i-1];
         char letterb = seq2[j-1];
         int scores[3];

         // Diagonal
         scores[0] = scoreMatrix[i-1][j-1] + score(lettera,letterb);

         // Up
         scores[1] = scoreMatrix[i-1][j] + gap_penalty;

         // Left
         scores[2] = scoreMatrix[i][j-1] + gap_penalty;

         int maxIndex = findMaxIndex(scores,3);
      }
   }



}
