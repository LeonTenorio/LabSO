#include <string>
#include <iostream>
#include <fstream>
#include <bits/stdc++.h> 
#include <map>
#pragma once

using namespace std;

static string driver_folder = "./drivers/";

//map<string,string> drivers_map;

map<string,string> drivers_map ={
    {"inputdisk", "disk_input.asm"},
    {"output", "external_output.asm"}
};

bool isDriver(string function_name){
    if(drivers_map.count(function_name)==0){
        return false;
    }
    return true;
}

vector<string> getDriver(string function_name){
    vector<string> driver_lines;
    ifstream input(driver_folder+drivers_map[function_name]);
    bool first = true;
    for( std::string line; getline( input, line ); ){
        if(first){
            first = false;
        }
        else{
            string line_string = line;
            driver_lines.push_back(line_string);
            cout << line << " " << driver_lines.size() << endl;
        }
    }
    return driver_lines;
}