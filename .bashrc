# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
export GOPATH=/home/adleyvong/workspace
export PATH=$PATH:$GOPATH/bin
alias routine='cd /home/adleyvong/Documents/Go_Project/My_Project'
alias cppwp='cd /home/adleyvong/Documents/My_WorkPlace/cpp/mytest'
alias openclsrc='cd /home/adleyvong/Documents/My_WorkPlace/cpp/invofiltering/Nvidia_OpenCL_SDK_4_2_Linux/OpenCL/src/oclParticleFilter'
alias openclbin='cd /home/adleyvong/Documents/My_WorkPlace/cpp/invofiltering/Nvidia_OpenCL_SDK_4_2_Linux/OpenCL/bin/linux/release'
alias finalfilters='cd /home/adleyvong/Documents/My_WorkPlace/cpp/invofiltering/final_filters'
alias myfilters='cd /home/adleyvong/Documents/My_WorkPlace/cpp/myfilters'
# workaround for cuda support gcc-6 (official 5.3 15/01/2017)
export EXTRA_NVCCFLAGS="-Xcompiler -std=c++98"
#LIBRARY_PATH =$LIBRARY_PATH:/usr/lib64/nvidia
####################################################################
## Shorten the current directory path
####################################################################
export PS1='\u@\h:\W$ '
####################################################################
## powerline setting
####################################################################
if [ -f `which powerline-daemon` ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  . /usr/share/powerline/bash/powerline.sh
fi

####################################################################
## CUDA setting
####################################################################
#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib64/nvidia  #cuda path

#LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/ati-stream/lib/x86_64 //opencl_amd path

#export LD_LIBRARY_PATH

#setenv LD_LIBRARY_PATH /usr/lib64/nvidia:${LD_LIBRARY_PATH}




