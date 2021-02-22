int directory[21];/*Primeira posicao eh o tamanho do diretorio. Adminito 20 programas que serao carregados*/
int processtab[101];/*Minha tabela de processos, com a primeira posicao sendo o tamanho dela*/
int processtabsize;

int main(){
    int i;
    int memoryparticiontam;
    int mempartitionbase;
    int mempartitionlimit;
    int programsize;
    processtabsize = processtab[0];
    if(processtabsize==0){
        inputdisk(1, 0, directory);
        memoryparticiontam = 4096/(directory[0]+2);
        i = 1;
        mempartitionbase = memoryparticiontam;
        while(i<directory[0]){
            mempartitionlimit = mempartitionbase + memoryparticiontam - 1;
            programsize = inputdisk(directory[i+1], mempartitionbase);
            processtab[i*7+1] = i;
            processtab[i*7+2] = 0;
            processtab[i*7+3] = mempartitionbase+1;
            processtab[i*7+4] = mempartitionbase[0];
            processtab[i*7+5] = mempartitionbase+programsize;
            processtab[i*7+6] = mempartitionbase+programsize+40;
            processtab[i*7+7] = mempartitionlimit;

            initializeprocessmemory(newprogramaddress[2], newprogramaddress[0], newprogramaddress[1]);

            i = i + 1;
            mempartitionbase = mempartitionlimit + 1;
        }
    }
}