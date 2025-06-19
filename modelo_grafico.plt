# Arquivo: modelo_grafico.plot
# Uso: gnuplot -e "hardware=?" modelo_grafico.plt 
# Argumentos: 
# hardare => [o hardware usado para o testo]
# com_numero => [se deve conter os valores junto aos pontos (deve haver um valor vazio)]
# Ex: gnuplot  -e "hardware='Ryzen 7 5700X - 32GB RAM DDR4 3200Mhz'; com_numero=''" modelo_grafico.plt

# Configurações do terminal e saída
set terminal pngcairo enhanced font "Arial,12" size 1000,600
outputfile = "./graficos/" . strftime("%Y-%m-%d-%H-%M-%S", time(0)) . "_grafico.png"
set output outputfile

# Configurações do título e eixos
if (exists("hardware")) {
    tt = "Comparativo de Algoritmos de Ordenação Mergesort e Bubblesort em C e Python\n{/*0.8 " . hardware . "}"
    set title tt
} else {
    set title "Comparativo de Algoritmos de Ordenação Mergesort e Bubblesort em C e Python"
    
}
set xlabel "Tamanho da Entrada (10^n)"
set ylabel "Tempo (segundos)"
set datafile separator ";"
set xrange [1:6]
set xtics (0, "10^1" 1, "10^2" 2, "10^3" 3, "10^4" 4, "10^5" 5, "10^6" 6, "10^7" 7, "10^8" 8, "10^9" 9, "10^{10}" 10, "10^{11}" 11, "10^{12}" 12)
set grid
set logscale y
set logscale x
set key below

if (exists("com_numero")) {
     plot 'saidas/c_merge.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#ff9300" title 'Mergesort no C', \
     '' using ($0):4:(sprintf("%.8f", $4)) with labels offset 6.2,0 tc rgb "#ff9300" notitle, \
     'saidas/c_bubble.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#ff3900" title 'Bubblesort no C', \
     '' using ($0):4:(sprintf("%.8f", $4)) with labels offset -6.2,0 tc rgb "#ff3900" notitle, \
     'saidas/python_merge.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#8bf745" title 'Mergesort no Python', \
     '' using ($0):4:(sprintf("%.8f", $4)) with labels offset -6.2,0 tc rgb "#8bf745" notitle, \
     'saidas/python_bubble.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#38b5f4" title 'Bubblesort no Python', \
     '' using ($0):4:(sprintf("%.8f", $4)) with labels offset 6.2,0 tc rgb "#38b5f4" notitle
} else {
    plot 'saidas/c_merge.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#ff9300" title 'Mergesort no C', \
        'saidas/c_bubble.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#ff3900" title 'Bubblesort no C', \
        'saidas/python_merge.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#8bf745" title 'Mergesort no Python', \
        'saidas/python_bubble.csv' using ($0):4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#38b5f4" title 'Bubblesort no Python', \
}
