# Task2

1. Here is terraform code to build cluster on aws usning 2 EC2 one master and one worker
2. as prerequisites:
    1. aws account
    2. aws configure in your terminal
    3. keyname to ssh to ec2
    4. your ami id to use
3. to build cluster:
    a. terraform init
    b. terraform plan #for valiadting
    c. terraform apply
    
4. it generate cluster with one master and number of worker depend on count you provide in terrfaorm.vars
5. to make workers join cluster :
    a. on master after building :  kubeadm token create --print-join-command
    b. take output and run it on workers

