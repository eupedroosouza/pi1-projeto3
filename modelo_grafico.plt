# Arquivo: modelo_grafico.plot
# Uso: gnuplot -e "hardware=?" modelo_grafico.plt 
# Argumentos: 
# hardare => [o hardware usado para o testo]
# com_numero => [se deve conter os valores junto aos pontos (deve haver um valor vazio)]
# Ex: gnuplot  -e "hardware='Ryzen 7 5700X - 32GB RAM DDR4 3200Mhz'; com_numero=''" modelo_grafico.plt

# Configurações do terminal e saída

set terminal pngcairo enhanced font "Arial,12" size 1000,600
outputfile = "./graficos/_grafico.png"
set output outputfile

set title "Comparativo de Algoritmos de Ordenação Mergesort e Bubblesort em C e Python \n{/*0.8 " . hardware . "}"
set xlabel "Tamanho da Entrada (10^n)"
set ylabel "Tempo (segundos)"

set datafile separator ";"

set logscale x
set logscale y

set xrange [10:1000000000]


set format x "10^{%L}"
set xtics 10
set mxtics 10

set grid
set key below

plot \
  'saidas/c_merge.csv' using 3:4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#ff9300" title 'Mergesort no C', \
  'saidas/c_bubble.csv' using 3:4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#ff3900" title 'Bubblesort no C', \
  'saidas/python_merge.csv' using 3:4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#8bf745" title 'Mergesort no Python', \
  'saidas/python_bubble.csv' using 3:4 with linespoints lt 1 lw 2 pt 7 ps 1.5 lc rgb "#38b5f4" title 'Bubblesort no Python'
