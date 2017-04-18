FROM ubuntu:16.04

LABEL ubuntu.version="16.04" aspera.version="3.7.2" maintainer="Alice Minotto, @ Earlham Institute"

RUN useradd -ms /bin/bash  cyverse_user && \
    apt-get -y update && apt-get -yy install wget && \
    wget http://download.asperasoft.com/download/sw/connect/3.7.2/aspera-connect-3.7.2.141527-linux-64.sh

USER cyverse_user

RUN /bin/bash aspera-connect-3.7.2.141527-linux-64.sh

USER root

WORKDIR /data

ENTRYPOINT ["/home/cyverse_user/.aspera/connect/bin/ascp", "-i", "/home/cyverse_user/.aspera/connect/etc/asperaweb_id_dsa.openssh", "-k","1","-Tr","-l","800m"]
#, "anonftp@ftp.ncbi.nlm.nih.gov:/sra/sra-instant/reads/ByRun/sra/SRR/SRR304/SRR304976/SRR304976.sra","anonftp@ftp.ncbi.nlm.nih.gov:sra/sra-instant/reads/ByRun/sra/SRR/SRR110/SRR1103214/SRR1103214.sra", "/data"]
