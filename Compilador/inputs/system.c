int directory[21];/*Primeira posicao eh o tamanho do diretorio. Adminito 20 programas que serao carregados*/
int processtab[101];/*Minha tabela de processos, com a primeira posicao sendo o tamanho dela*/
int processtabsize;
int tracksector[2];

void main(void)
{
    int i;
    int memoryparticiontam;
    int mempartitionbase;
    int mempartitionlimit;
    int programsize;
    processtabsize = processtab[0];
    if(processtabsize==0)
    {
        inputdisk(1, 0, directory);
        memoryparticiontam = 4096/(directory[0]+2);
        i = 1;
        mempartitionbase = memoryparticiontam;
        while(i<directory[0])
        {
            mempartitionlimit = mempartitionbase + memoryparticiontam - 1;
            inputdisktracksector(tracksector);
            programsize = inputdisk(tracksector[0], tracksector[1], mempartitionbase);
            /*inputdisk(tracksector[0], tracksector[1], mempartitionbase);*/
            processtab[i*7+1] = i;
            processtab[i*7+2] = 0;
            processtab[i*7+3] = mempartitionbase+1;
            processtab[i*7+4] = programsize;
            processtab[i*7+5] = mempartitionbase+programsize;
            processtab[i*7+6] = mempartitionbase+programsize+40;
            processtab[i*7+7] = mempartitionlimit;

            /*initializeprocessmemory(processbuffer+programsize, processbuffer+programsize+40, mempartitionlimit, i);*/

            i = i + 1;
            mempartitionbase = mempartitionlimit + 1;
        }
    }
}