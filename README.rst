
Guide for VGA (GPU) Passthrough with KVM (QEMU)
===============================================


( Guide is under construction :)

NOTE: I planned to write guide for how to use display card from within KVM virtual machine. But this project changed ;)

This project now contains information and scripts for creating my KVM environment.

Clone this project:

.. code-block:: bash

 $ git clone https://github.com/lordmikefin/kvm-gpu-guide.git

 $ cd kvm-gpu-guide/
 $ git submodule init
 $ git submodule update

Add ssh url for project and submodules

.. code-block:: bash

 $ git remote add origin_ssh git@github.com:lordmikefin/kvm-gpu-guide.git
 
 $ cd ./submodule/LMToysBash/
 $ git remote add origin_ssh git@github.com:lordmikefin/LMToysBash.git

Or set ssh url for project and submodules ;)

.. code-block:: bash

 $ git remote set-url origin git@github.com:lordmikefin/kvm-gpu-guide.git
 
 $ cd ./submodule/LMToysBash/
 $ git remote set-url origin git@github.com:lordmikefin/LMToysBash.git

Usefull git commands:

.. code-block:: bash

 $ git remote -v
 
 $ git branch
 $ git branch -r
 
 $ git checkout master
 $ # git checkout -b master --track origin/master
 
 $ git commit -a --dry-run
 $ git commit -a -m "COMMENT HERE"
 $ git log -p
 $ git push
 
 $ git pull
 $ git submodule foreach "(git checkout master; git pull)"
