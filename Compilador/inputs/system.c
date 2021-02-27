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
    int auxtres;
    output(110);
    /*Meus processos terao 3 estados: 0 pronto para execucao, 1 bloqueado, 2 terminado*/
    processtabsize = processtab[1];
    if(processtabsize!=0){
        output(120);
        i = processtab[0];
        aux = 4+i*7;
        auxdois = processtab[aux];
        auxtres = getupcodeoperation(auxdois);
        if(auxtres==1){
            /*Processo terminado*/
            processtab[aux] = 2;
            processtab[1] = processtabsize - 1;
        }
    }
    if(processtabsize==0)
    {
        output(130);
        inputdisk(1, 0, directory);
        memoryparticiontam = 4096/(directory[0]+2);
        i = 0;
        mempartitionbase = memoryparticiontam;
        while(i+1 < directory[0])
        {
            output(i);
            mempartitionlimit = mempartitionbase + memoryparticiontam;
            mempartitionlimit = mempartitionlimit - 1;
            inputdisktracksector(directory[i+1], tracksector);
            programsize = inputdisk(tracksector[0], tracksector[1], mempartitionbase);
            
            aux = mempartitionbase+1;
            auxdois = aux+programsize;
            auxtres = auxdois + 40;
            insertinprocesstab(processtab, i, i+1, 0, aux, programsize, auxdois, auxtres, mempartitionlimit);

            initializeprocessmemory(auxdois, auxtres, mempartitionlimit, i+1);

            i = i + 1;
            mempartitionbase = mempartitionlimit + 1;
            aux = processtab[1];
            processtab[1] = aux + 1;
        }
        aux = 0;
        processtab[0] = aux - 1;
    }
    processtabsize = processtab[1];
    output(140);
    
    /*Varrer a tabela de simbolos procurando o proximo processo pronto para ser executado*/
    i = processtab[0]+1;
    aux = 3+i*7;
    while(processtab[aux]!=0){
        output(i);
        i = i + 1;
        if(i>=processtabsize){
            i = 0;
        }
        aux = 3+i*7;
    }
    aux = aux + 1;
    auxdois = aux + 1;
    auxtres = auxdois + 1;
    selectprocesstorun(processtab[aux], processtab[auxdois], processtab[auxtres]);
    output(150);
}