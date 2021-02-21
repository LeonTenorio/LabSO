#include <string>
#include <iostream>
#include <fstream>
#include <bits/stdc++.h> 
#include <map>

using namespace std;

static string driver_folder = "./drivers/";

static map<string,string> drivers_map ={
    {"input_disk", "disk_input.asm"},
    {"output", "external_output.asm"}
};

bool isDriver(string function_name){
    if(drivers_map.count(function_name)==0){
        return false;
    }
    return true;
}

void getDriver(string function_name, vector<string> program_drivers){
    ifstream driver_asm;
    driver_asm.open(driver_folder+drivers_map[func_name]);
    if(!driver_asm){
        cout << "Erro abrindo o driver " << function_name << endl;
        exit (-1);
    }
    string line;
    while(getline(driver_asm, line)){
        program_drivers.push_back(line);
    }
}