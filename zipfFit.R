#!/usr/bin/env Rscript

args = commandArgs(trailingOnly=TRUE)
if (length(args)==0) {
	  stop("At least one argument must be supplied (input file).n", call.=FALSE)
} 

library(proto)
library(argparse)
library(zipfR)

parser <- ArgumentParser()
parser$add_argument("--file", type="character", help="provide input filename with type frequency list")
parser$add_argument("--model", default="fzm", type="character", help="model to be fitted (fzm, zm or gigp) [default \"%(default)s\"]")
parser$add_argument("--gof", action="store_true", default=FALSE, help="print goodness of fit")
args <- parser$parse_args()


data.tfl = read.tfl(args$file)
data.spc = tfl2spc(data.tfl)
data.model <- lnre(args$model, data.spc, exact=FALSE)
# https://www.r-bloggers.com/the-zipf-and-zipf-mandelbrot-distributions/
s = 1 / data.model$param$alpha
#b = (1-data.model$param$alpha)/(data.model$param$B*data.model$param$alpha)
b = data.model$param$B/(s - 1)
C = (1-data.model$param$alpha)/data.model$param$B^(1-data.model$param$alpha)
p = data.model$go[1,3]
df = data.model$go[1,2]
X2 = data.model$go[1,1]
if ( args$gof ) {
  cat("a\tb\tC\tX2\tdf\tp\n")
  cat(sprintf("%.3f",s)); cat("\t"); cat(sprintf("%.3f",b)); cat("\t"); cat(sprintf("%.3f",C)); cat("\t"); cat(sprintf("%.2f",X2)); cat("\t"); cat(sprintf("%.2f",df)); cat("\t"); cat(sprintf("%0.3g",p));  
} else {
  cat("a\tb\tC\n")
  cat(sprintf("%.3f",s)); cat("\t"); cat(sprintf("%.3f",b)); cat("\t"); cat(sprintf("%.3f",C));
}
cat("\n")
