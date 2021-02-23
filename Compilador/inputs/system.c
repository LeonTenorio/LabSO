void main(void)
{
    int directory[21];/*Primeira posicao eh o tamanho do diretorio. Admito 20 programas que serao carregados*/
    int processtab[100];/*Primeira posicao eh o numero do processo em execucao, segunda posicao eh o tamanho da tabela, terceira posicao para frente eh a tabela de processos*/
    int processtabsize;
    int tracksector[2];
    int i;
    int memoryparticiontam;
    int mempartitionbase;
    int mempartitionlimit;
    int programsize;
    int aux;
    int auxdois;
    processtabsize = processtab[1];
    if(processtabsize==0)
    {
        inputdisk(1, 0, directory);
        memoryparticiontam = 4096/(directory[0]+2);
        i = 0;
        mempartitionbase = memoryparticiontam;
        while(i+1 < directory[0])
        {
            mempartitionlimit = mempartitionbase + memoryparticiontam;
            mempartitionlimit = mempartitionlimit - 1;
            inputdisktracksector(directory[i+1], tracksector);
            programsize = inputdisk(tracksector[0], tracksector[1], mempartitionbase);
            
            aux = mempartitionbase+1;
            auxdois = aux+programsize;
            insertinprocesstab(processtab, i, i+1, 0, aux, programsize, auxdois, auxdois+40, mempartitionlimit);

            i = i + 1;
            mempartitionbase = mempartitionlimit + 1;
        }
    }
}