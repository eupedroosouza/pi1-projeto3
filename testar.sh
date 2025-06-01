#!/bin/bash

regex_isanumber="^[0-9]+$"
pastaExecucao=`echo "$PWD"`

function help() {
    echo "<======= Ajuda (Teste de Ordenação Bubblesort e Mergesort em Python e C) =======>"
    echo "-l [linguagem - c/python] → em qual linguagem de programação o algoritmo será executado."
    echo "-a [algoritmo - bubble/merge] → qual o algoritmo a ser executado"
    echo "-n [número de execuções - ex: 10] → quantas vezes o algoritmo vai executar"
    echo "-t [tamanho da entrada - ex 5, equivalente a 10^5] - o tamanho da entrada (tamanho da lista que o algoritmo ordenará)"
}

# l -> linguagem (c ou ptython)
# a -> algoritmo (buble ou merge)
# n -> numero de execuções
# t -> tamanho da entrada
while getopts ":l:a:n:t:h" name; do
    case "${name}" in
        l) linguagem=${OPTARG};;
        a) algoritmo=${OPTARG};;
        n) execucoes=${OPTARG};;
        t) tamanho=${OPTARG};;
        h) 
            help
            exit 1
            ;;
        :)
            echo "O argumento (-${OPTARG}) precisa ter conteúdo."
            help
            exit 1
            ;;
        *)
            echo "Argumento inválido: -$OPTARG."
            help
            exit 1
            ;;    
        esac
done

# checagem dos argumentos
if [[ -z "$linguagem" ]]; then 
    echo "Argumento obrigatório: -l [c/python]."
    help
    exit 1;
fi

if [[ -z "$algoritmo" ]]; then 
    echo "Argumento obrigatório: -a [bubble/merge]."
    help
    exit 1;
fi

if [[ -z "$execucoes" ]]; then 
    echo "Argumento obrigatório: -n [número de execuções]."
    help
    exit 1;
fi

if [[ -z "$tamanho" ]]; then 
    echo "Argumento obrigatório: -t [tamanho da entrada, equivalente a 10^-t]."
    help
    exit 1;
fi

# checagem dos valores
if [[ "$linguagem" != "c" &&  "$linguagem" != "python" ]]; then
    echo "O argumento de linguagem (-l) é incorreto, deve ser: c ou python."
    help
    exit 1
fi

if [[ "$algoritmo" != "bubble"  && "$algoritmo" != "merge" ]]; then
    echo "O argumento de algoritmo (-a) é incorreto, deve ser: bubble ou merge."
    help
    exit 1
fi

if ! [[ "$execucoes" =~ $regex_isanumber ]]; then
    echo "O número de execuções (-n) deve ser um número positivo."
    help
    exit 1
fi

if [[ "$execucoes" -eq 0 ]]; then
    echo "O número de execuções (-n) deve ser maior que 0."
    help
    exit 1
fi

if ! [[ "$tamanho" =~ $regex_isanumber ]]; then
    echo "O tamanho (-t) deve ser um número positivo."
    help
    exit 1
fi

if [[ "$tamanho" -eq 0 ]]; then
    echo "O tamanho (-t) deve ser maior que 0."
    help
    exit 1
fi

tamanhoReal=$((10**$tamanho))
echo "<======= Informações =======>"
echo "Linguagem: $linguagem"
echo "Algoritmo: $algoritmo"
echo "Número de Execuções: $execucoes"
echo "Tamanho da entrada: 10^$tamanho ($tamanhoReal)"
echo ""

# checagem de instalação
echo "<======= Checagem de Instalação =======>"
if [[ $linguagem == "c" ]]; then
    if [[ $algoritmo == "bubble" ]]; then
        executavelC="bubblesort"
    elif [[ $algoritmo == "merge" ]]; then
        executavelC="mergesort"
    fi
    arquivoC="${pastaExecucao}/${executavelC}";
    if ! [[ -e $arquivoC ]]; then
        echo "O executável do algoritimo não foi encontrado em $arquivoC"
        exit 1
    else 
        echo "Algoritmo executável $executavelC encontrado."
    fi
fi  
if [[ $linguagem == "python" ]]; then
    if [[ $algoritmo == "bubble" ]]; then
        nomeArquivoPython="bubblesort.py"
    elif [[ $algoritmo == "merge" ]]; then
        nomeArquivoPython="mergesort.py"
    fi
    arquivoPython="${pastaExecucao}/${nomeArquivoPython}"
    if ! [[ -e $arquivoPython ]]; then
        echo "O algoritimo não foi encontrado em $arquivoPython"
        exit 1
    else 
        echo "Algoritmo $nomeArquivoPython encontrado."
    fi
    if [[ $(command -v python3 &>/dev/null; echo $?) -eq 0 ]]; then
        echo "Python encontrado com sucesso."
    else 
        echo "O Python não foi encontrado."
        exit 1
    fi
fi
echo ""


# checagem de arquivo
echo "<======= Checagem de Arquivo de Saída =======>"
nomeArquivoSaida="${linguagem}_${algoritmo}_${execucoes}_${tamanho}_saidas.csv"
pastaSaida="${pastaExecucao}/saidas"
arquivoSaida="${pastaSaida}/${nomeArquivoSaida}"
echo "Diretório de saídas: $pastaSaida"
echo "Arquivo de saída: $nomeArquivoSaida."
echo "Checando arquivo de saída."
if ! [[ -d $pastaSaida ]]; then
    echo "Diretório de saídas não existe, criando..."
    mkdir $pastaSaida
    echo "Diretório de saídas criado: ${pastaSaida}/saidas"
else
    if [[ -e $arquivoSaida ]]; then
        echo "Já existe arquivo de saída. Fazendo backup..."
        segundos=$(date +%s)
        arquivoBackup="${pastaSaida}/${segundos}_bakcup_$nomeArquivoSaida"
        mv $arquivoSaida $arquivoBackup
        echo "O backup do arquivo foi salvo em $arquivoBackup"
    fi
fi
touch $arquivoSaida
echo "Arquivo de saída criado."
echo ""


# teste
echo "<======= Teste =======>"
segundosInicio=$(date +%s)
inicioTeste=$(date +"%d/%m/%Y %H:%M:%S")
echo "Início dos testes: $inicioTeste"
# exec
count=1
while [ $count -le $execucoes ]; do
    echo -ne "Executandando o teste número $count\r"
    if [[ $linguagem == "c" ]]; then
        resultado=$($(echo $arquivoC) $(echo $tamanhoReal))
    elif [[ $linguagem == "python" ]]; then
        resultado=$(python3 $(echo $arquivoPython) $(echo $tamanhoReal))
    fi
    readarray -d ';' -t resultado_array <<< "$resultado"
    echo "${resultado_array[1]}" >> $arquivoSaida
    echo -ne "Teste número $count executado!      \r"
    count=$(($count + 1))
done
echo "Foram executados $execucoes testes."
fimTeste=$(date +"%d/%m/%Y %H:%M:%S")
segundosFim=$(date +%s)
segundos=$(($segundosInicio - $segundosFim))
echo "Fim dos testes: $inicioTeste"
echo "Os testes levaram $((segundos/3600)) hora(s) $((segundos%3600/60)), minuto(s) e $((segundos%60)) segundo(s)."
echo ""

# tratamento de dados
echo "<======= Tratamento de Dados =======>"
echo ""
# todo

# fim
echo "Fim da execução!"


  