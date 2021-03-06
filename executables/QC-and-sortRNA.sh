#! /bin/bash 

# setup files
cp $1 .
tran=$(basename $1)
file=$(basename $1 .tar.gz)
name=$(basename $1 .fastq.tar.gz)
tar -xzf $tran

# software setup
wget http://opengene.org/fastp/fastp
chmod a+x ./fastp
tar -xzvf sortmerna-2.1-linux-64-multithread.tar.gz

# QC 
./fastp -i $file -o $name.qced.fastq --cut_by_quality3

# Sort RNA to get mRNA 
cd sortmerna-2.1b
# Index databases

./indexdb_rna --ref ./rRNA_databases/silva-bac-16s-id90.fasta,./index/silva-bac-16s-db:\./rRNA_databases/silva-bac-23s-id98.fasta,./index/silva-bac-23s-db:./rRNA_databases/silva-arc-16s-id95.fasta,./index/silva-arc-16s-db:./rRNA_databases/silva-arc-23s-id98.fasta,./index/silva-arc-23s-db:./rRNA_databases/silva-euk-18s-id95.fasta,./index/silva-euk-18s-db:./rRNA_databases/silva-euk-28s-id98.fasta,./index/silva-euk-28s:./rRNA_databases/rfam-5s-database-id98.fasta,./index/rfam-5s-db:./rRNA_databases/rfam-5.8s-database-id98.fasta,./index/rfam-5.8s-db

# Get mRNA 
./sortmerna --ref ./rRNA_databases/silva-bac-16s-id90.fasta,./index/silva-bac-16s-db:./rRNA_databases/silva-bac-23s-id98.fasta,./index/silva-bac-23s-db:./rRNA_databases/silva-arc-16s-id95.fasta,./index/silva-arc-16s-db:./rRNA_databases/silva-arc-23s-id98.fasta,./index/silva-arc-23s-db:./rRNA_databases/silva-euk-18s-id95.fasta,./index/silva-euk-18s-db:./rRNA_databases/silva-euk-28s-id98.fasta,./index/silva-euk-28s:./rRNA_databases/rfam-5s-database-id98.fasta,./index/rfam-5s-db:./rRNA_databases/rfam-5.8s-database-id98.fasta,./index/rfam-5.8s-db --reads ../$name.qced.fastq  --fastx --aligned ../$name-rRNA.qced --other ../$name-nonrRNA.qced --log -v -m 1 -a 14

# copy back to gluster
cd ..
tar -czvf $name-nonrRNA.qced.fastq.tar.gz $name-nonrRNA.qced.fastq
cp $name-nonrRNA.qced.fastq.tar.gz /mnt/gluster/emcdaniel/
