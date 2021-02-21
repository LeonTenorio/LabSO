#include <string>
#include <iostream>
#include <fstream>
#include <bits/stdc++.h> 
#include <map>

using namespace std;

static string driver_folder = "./drivers/";

//map<string,string> drivers_map;

map<string,string> drivers_map ={
    {"input_disk", "disk_input.asm"},
    {"output", "external_output.asm"}
};

bool isDriver(string function_name){
    //drivers_map["input_disk"] = "disk_input.asm";
    //drivers_map["output"] = "external_output.asm";
    if(drivers_map.count(function_name)==0){
        return false;
    }
    return true;
}

vector<string> getDriver(string function_name, vector<string> program_drivers){
    cout << "início do driver " << driver_folder+drivers_map[function_name] << endl;
    ifstream input(driver_folder+drivers_map[function_name]);
    cout << "abri o arquivo do driver" << endl;
    bool first = true;
    for( std::string line; getline( input, line ); ){
        if(first){
            first = false;
        }
        else{
            string line_string = line;
            program_drivers.push_back(line_string);
            cout << line << " " << program_drivers.size() << endl;
        }
    }
    return program_drivers;
}