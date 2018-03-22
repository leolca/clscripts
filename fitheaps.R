#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
          stop("At least one argument must be supplied (input file).n", call.=FALSE)
}

library(proto)
library(argparse)
library(zipfR)

parser <- ArgumentParser()
parser$add_argument("--file", type="character", help="provide input filename with vocabulary growth data")
args <- parser$parse_args()

data = read.vgc(args$file)
M = data$N
N = data$V
beta = log(N[length(N)])/log(M[length(M)])
lfit = lsfit(x = log(M), y = log(N), intercept = TRUE)
alfa = coef(lfit)[["Intercept"]]
cat("a\tb\n")
cat(sprintf("%.3f",alfa)); cat("\t"); cat(sprintf("%.3f",beta)); cat("\n")
