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
    {"output", "external_output.asm"},
    {"initializeprocessmemory", "initialize_process_memory.asm"},
    {"inputdisktracksector", "disk_input_track_sector.asm"},
    {"insertinprocesstab", "process_tab_insert.asm"},
    {"getupcodeoperation", "get_upcode_operation.asm"},
    {"selectprocesstorun", "select_process_to_run.asm"}
};

bool isDriver(string function_name){
    if(drivers_map.count(function_name)==0){
        return false;
    }
    return true;
}

string getDriverName(string function_name){
    return drivers_map[function_name];
}

vector<string> getDriver(string function_name){
    vector<string> driver_lines;
    ifstream input(driver_folder+drivers_map[function_name]);
    int lineCount = 0;
    for( std::string line; getline( input, line ); ){
        if(lineCount>1){
            string line_string = line;
            driver_lines.push_back(line_string);
        }
        lineCount++;
    }
    return driver_lines;
}