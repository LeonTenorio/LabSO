void main(void)
{
    /*Primeira posicao eh a quantidade de processos que sao carregados do HD*/
    /*Segunda posicao para frente sao os enderecos dos processos que sao carregados*/
    /*Cada processo listado aqui eh: 16bits ID, 8 bits track, 8 bits sector*/
    int directory[21];/*Capacidade de 19 processos de usuario*/
    /*Primeira posicao da tabela sera o numero do processo em execucao*/
    /*Segunda vai ser a quantidade de processos logicamente em execucao*/
    /*Terceira posicao da tabela vai ser o tamanho da tabela*/
    /*Quarta posicao para frente sao os processos*/
    int processtab[136];/*Capacidade de 19 processos de usuario*/
    int index;
    int programsize;
    int memparticiontam;
    int memparticionbase;
    int memparticionlimit;
    int aux;
    int auxdois;
    int auxtres;
    int tracksector[2];

    if(processtab[1]!=0){
        /*Verificacao se o ultimo processo em execucao terminou*/
        index = processtab[0];

        aux = 7*index;
        aux = aux + 5;/*Indice para endereco das intrucoes*/
        auxdois = aux + 2;/*Indice para endereco dos registradores*/
        auxtres = getprocessopcodeoperation(processtab[aux], processtab[auxdois]);

        if(auxtres==1){
            output(150);
            /*Instrucao de HALT, ultimo programa finalizou*/
            aux = aux - 1; /*Acesso do estado do ultimo processo*/
            processtab[aux] = 2;

            aux = processtab[1];
            aux = aux - 1;
            processtab[1] = aux;
        }
    }

    if(processtab[1]==0){
        inputdisk(1, 0, directory);
        memparticiontam = 4096;
        memparticiontam = memparticiontam - tracksector;
        memparticiontam = memparticiontam - 200;
        memparticiontam = memparticiontam/(directory[0]+2);

        index = 0;
        memparticionbase = tracksector;
        memparticionbase = memparticionbase + 200;
        memparticionbase = memparticionbase + memparticiontam;
        while(index < directory[0]){
            memparticionlimit = memparticionbase + memparticiontam;
            memparticionlimit = memparticionlimit - 1;
            inputdisktracksector(directory[index+1], tracksector);

            programsize = inputdisk(tracksector[0], tracksector[1], memparticionbase);
            memparticionbase = memparticionbase + 1;
            aux = 7*index;
            aux = aux + 3;
            processtab[aux] = index + 1;

            aux = aux + 1;
            processtab[aux] = 0;
            
            aux = aux + 1;
            processtab[aux] = memparticionbase;
            
            aux = aux + 1;
            processtab[aux] = programsize;
            
            aux = aux + 1;
            memparticionbase = memparticionbase + programsize;
            auxdois = memparticionbase;
            processtab[aux] = memparticionbase;
            
            aux = aux + 1;
            memparticionbase = memparticionbase + 40;
            processtab[aux] = memparticionbase;
            
            aux = aux + 1;
            processtab[aux] = memparticionlimit;

            aux = 7*index;
            aux = aux + 7;
            auxdois = aux + 1;
            auxtres = auxdois + 1;
            initializeprocessmemory(processtab[aux], processtab[auxdois], processtab[auxtres], index + 1);

            index = index + 1;
            memparticionlimit = memparticionlimit + 1;
            memparticionbase = memparticionlimit;
            
            aux = processtab[1];
            aux = aux + 1;
            processtab[1] = aux;

            aux = processtab[2];
            aux = aux + 1;
            processtab[2] = aux;
        }
        aux = processtab[0];
        aux = aux - 1;
        processtab[0] = aux;
    }

    index = processtab[0];
    index = index + 1;

    if(index>=processtab[2]){
        index = 0;
    }

    aux = 7*index;
    aux = aux + 4;

    while(processtab[aux]!=0){
        index = index + 1;
        aux = aux + 7;
        if(index>=processtab[2]){
            index = 0;
            aux = 4;
        }
    }

    output(index);
    processtab[0] = index;

    aux = 7*index;
    aux = aux + 5;
    auxdois = aux + 1;
    auxtres = auxdois + 1;

    selectprocesstorun(processtab[aux], processtab[auxdois], processtab[auxtres]);
}