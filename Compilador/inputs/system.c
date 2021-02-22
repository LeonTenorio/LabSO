int directory[20];
int processtab[100];
int newprogramaddress[3];
int fileinformations[3];
int processtabsize;
int programsize;

int main(){
    int i;
    int memoryparticiontam;
    int mempartitionbase;
    int mempartitionlimit;
    processtabsize = getsymbtabsize();/*MAIS UM DRIVER*/
    if(processtabsize==0){
        inputdisk(1, 0, directory);
        memoryparticiontam = 4096/(directory[0]+2);
        i = 1;
        mempartitionbase = memoryparticiontam;
        while(i<directory[0]){
            mempartitionlimit = mempartitionbase + memoryparticiontam - 1;


            inputdisk(directory[i], fileinformations);
            getaddresstonewprogram(newprogramaddress, i, directory[0]);/*MAIS UM DRIVER*/
            
            programsize = inputdisk(fileinformations[0], fileinformations[1], newprogramaddress[0]);
            newprogramaddress[0] = newprogramaddress[0] + programsize;
            initializeprocessmemory(newprogramaddress[2], newprogramaddress[0], newprogramaddress[1]);
            insertinsymbtab();/*MAIS UM DRIVER*/

            i = i + 1;
            mempartitionbase = mempartitionlimit + 1;
        }
    }
}