library(stringr)
library(parallel)
library(Biostrings)

SD<-format(Sys.time(),'RAX_%Y%m%d_%H%M')

args <- commandArgs(TRUE) # megengedjuk h az Rscript scriptnev utan argumentumokat irhassunk be
pattern1 <- args[1]          # filenev
partfile <- args[2]          # partition file
cpusz <- args[3]             # mennyi cpuval fusson
gen <- args[4]               # bootstrap generation
################################################################################
lf2<-list.files(pattern = pattern1)

folduj<-SD

bootrax<-function(x){
  nev<-str_split(x,"\\.")[[1]][1]
  cmdform<-paste0("raxmlHPC-PTHREADS-AVX2 -T ",cpusz," -m PROTGAMMAWAG -p ",sample.int(10000,1)," -f a -x ",sample.int(10000,1)," -# ",gen,"  -s ",x," -n ",nev,".tre > info ", nev)
  cat(cmdform, "\n")
  system(cmdform, intern=F)
}

sink(file=paste0("logfile",SD,".txt"))
mclapply(lf2,FUN=bootrax,mc.cores=as.numeric(1))
sink()

system(paste0("mkdir ",folduj ))
system(paste0("cp RAxML_* ./",folduj))
system(paste0("cp *logfile* ./",folduj))
system("rm RAxML_*")
system("rm *logfile*")

