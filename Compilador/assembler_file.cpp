#include <string>
#include <iostream>
#include <bits/stdc++.h> 
#include "binary.cpp"

using namespace std;

static vector<string> assembly;
static vector<string> labels;
static map<string,int> labels_lines;

int main(int argc, char **argv)
{
    string assembly_file = argv[1];
    string output_file = argv[2];
    ifstream input(assembly_file);
    for( std::string line; getline( input, line ); ){
        string line_string = line;
        if(line_string.size()>0){
            if(line_string.at(0)=='.'){
                labels_lines[line_string] = assembly.size() - labels.size();
                assembly.push_back(line_string);
                labels.push_back(line_string);
            }
            else{
                assembly.push_back(line_string);
            }
        }
    }
    ofstream binaryFile;
    binaryFile.open(output_file);
    binaryFile << generateBinary(assembly, labels, labels_lines, true, true, false, false, 0, 0);
    binaryFile.close();
    return 0;
}