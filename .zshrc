# Created by newuser for 5.2
export GOPATH=/home/adley/workspace
export PATH=$PATH:$GOPATH/bin
alias routine='cd /home/adley/Documents/Go_Project/My_Project'
alias finalfilters='cd /home/adley/Documents/My_WorkPlace/cpp/invofiltering/final_filters'
alias myfilters='cd /home/adley/Documents/My_WorkPlace/cpp/myfilters'
alias openclsrc='cd /home/adley/Documents/My_WorkPlace/cpp/invofiltering/Nvidia_OpenCL_SDK_4_2_Linux/OpenCL/src/oclParticleFilter'
alias openclbin='cd /home/adley/Documents/My_WorkPlace/cpp/invofiltering/Nvidia_OpenCL_SDK_4_2_Linux/OpenCL/bin/linux/release'
# only show current directory
export PS1='%m %1d$ '  #  machine name (%m) and current path (%1d)

# workaround for cuda support gcc-6 (official 5.3 15/01/2017)
 export EXTRA_NVCCFLAGS="-Xcompiler -std=c++98"

#export LIBRARY_PATH=/usr/lib64/nvidia

#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/nvidia  #cuda path

#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/ati-stream/lib/x86_64 //opencl_amd path

#export LD_LIBRARY_PATH

#setenv LD_LIBRARY_PATH /usr/lib64/nvidia:${LD_LIBRARY_PATH}


