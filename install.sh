#!/bin/bash
echo -e "\e[37m...\e[0m"
echo -e "\e[37m...\e[0m"
echo -e "\e[37mScript para la instalacion del software UHD + GNURadio + RFNoC para ETTUS E-310\e[0m"
echo -e "\e[37mVersión de UHD: UHD_4.0.0.rfnoc-devel\e[0m"
echo -e "\e[37mVersión de GNURadio: v3.7.9.3\e[0m"
echo -e "\e[37m...\e[0m"
echo -e "\e[37m...\e[0m"

typeset -i pc_rfnoc
typeset -i pc_no_rfnoc
typeset -i ettus_no_rfnoc
typeset -i ettus_rfnoc
typeset -i d
typeset -i version
typeset -i toolchain
typeset -i j

version=0
pc_rfnoc=0
pc_no_rfnoc=0
ettus_no_rfnoc=0
ettus_rfnoc=0
d=0
j=0
ip="192.168.1.8"

#Help info
if [[ "$1" = "--help" || "$#" = "0" ]]
	then
		echo -e "\e[33mUsage : install.sh [ Options ] [Types]\e[0m"
		echo -e "\e[33mOptions :\e[0m"
		echo -e "\e[33m  -d                      instalar dependencias necesarias\e[0m"
		echo -e "\e[33m  -ip                     establecer IP del dispositivo USRP [default = 192.168.1.8]\e[0m"
		echo -e "\e[33mTypes :\e[0m"
		echo -e "\e[33m  -pc-rfnoc               instalar UHD+GNURADIO+RFNoC en el ordenador\e[0m"
		echo -e "\e[33m  -pc-no-rfnoc            instalar UHD+GNURADIO en el ordenador\e[0m"
		echo -e "\e[33m  -ettus-rfnoc            instalar UHD+GNURADIO+RFNoC en la ETTUS\e[0m"
		echo -e "\e[33m  -ettus-no-rfnoc         instalar UHD+GNURADIO en la ETTUS\e[0m"
		echo
		echo -e "\e[33mEjemplos:\e[0m"
		echo -e "\e[33mInstalar dependencias necesarias y generar UHD-GNURADIO-RFNOC para el ordenador y USRP\e[0m"
		echo -e "\e[33minstall.sh -d -pc-rfnoc -ettus-rfnoc\e[0m"
		echo
		echo -e "\e[33mNo instalar dependencias y generar UHD-GNURADIO solamente para USRP\e[0m"
		echo -e "\e[33minstalar.sh -ettus-no-rfnoc\e[0m"
		echo
		exit
fi

for i in $*;
do
	if [[ $d = 0 && "$i" = "-d" ]]
	then
		d=1
	fi

	if [[ j=1 ]]
	then
		ip=$i
		j=0
	fi

	if [[ "$i" = "-ip" ]]
	then
		j=1;
	fi

	if [[ $pc_rfnoc = 0 && "$i" = "-pc-rfnoc" ]]
	then
		pc_rfnoc=1;
	fi

	if [[ $pc_no_rfnoc = 0 && "$i" = "-pc-no-rfnoc" ]]
	then
		pc_no_rfnoc=1;
	fi

	if [[ $ettus_no_rfnoc = 0 && "$i" = "-ettus-no-rfnoc" ]]
	then
		ettus_no_rfnoc=1;
	fi

	if [[ $ettus_rfnoc = 0 && "$i" = "-ettus-rfnoc" ]]
	then
		ettus_rfnoc=1;
	fi;

	let j=j+1
done

# Esto verifica que el sistema tenga arquitectura de 64bits
version=$(uname -a | grep -c x86_64)
echo -n "Arquitectura S.O : "
if [[ "$version" = "1" ]]
	then
		echo "x86_64"
	else
		echo "x86"
		echo -e "\e[31mDado que la arquitectura no es de 64bits no se podrá realizar la cross-compilacion del software para la USRP\e[0m"
fi

exit

if [[ $d = 1 ]]
	then
		echo -e "\e[36Instalando dependencias\e[0m"
		sudo apt-get -y install autoconf automake build-essential ccache cmake cmake git-core cpufrequtils doxygen fort77 g++ git git-core gtk2-engines-pixbuf libasound2-dev libboost-all-dev libcppunit-1.13-0 libcppunit-dev libcppunit-doc libfftw3-bin libfftw3-dev libfftw3-doc libfontconfig1-dev libgsl0-dev libncurses5 libncurses5-dbg libncurses5-dev liborc-0.4-0 liborc-0.4-dev libpulse-dev libqt4-dev libqt4-dev-bin libqwt5-qt4-dev libqwtplot3d-qt4-dev libsdl1.2-dev libtool libudev-dev libusb-1.0-0 libusb-1.0-0-dev libusb-dev libxi-dev libxrender-dev libzmq-dev libzmq1 ncurses-bin pyqt4-dev-tools python-cheetah python-dev python-docutils python-gtk2 python-lxml python-mako python-numpy python-numpy-dbg python-numpy-doc python-opengl python-qt4 python-qt4-dbg python-qt4-dev python-qt4-doc python-qwt5-qt4 python-requests python-scipy python-sphinx python-tk python-wxgtk2.8 qt4-bin-dbg qt4-default qt4-dev-tools qt4-doc r-base-dev swig wget

		echo
		echo -e "\e[36mActualizando repositorios...\e[0m"
		apt-get update && apt-get upgrade && apt-get autoremove

	else
		echo -e "\e[31mCUIDADO: No se instalaron dependencias y no se actualizaron los repositorios. Esto puede causar que el software no pueda ser compìlado además de problemas de funcionamiento. Si ya tiene instaladas las siguientes dependencias y los ultimos repositorios descargados, haga caso omiso a este mensaje:\e[0m"
		echo -e "\e[31msudo apt-get -y install autoconf automake build-essential ccache cmake cmake git-core cpufrequtils doxygen fort77 g++ git git-core gtk2-engines-pixbuf libasound2-dev libboost-all-dev libcppunit-1.13-0 libcppunit-dev libcppunit-doc libfftw3-bin libfftw3-dev libfftw3-doc libfontconfig1-dev libgsl0-dev libncurses5 libncurses5-dbg libncurses5-dev liborc-0.4-0 liborc-0.4-dev libpulse-dev libqt4-dev libqt4-dev-bin libqwt5-qt4-dev libqwtplot3d-qt4-dev libsdl1.2-dev libtool libudev-dev libusb-1.0-0 libusb-1.0-0-dev libusb-dev libxi-dev libxrender-dev libzmq-dev libzmq1 ncurses-bin pyqt4-dev-tools python-cheetah python-dev python-docutils python-gtk2 python-lxml python-mako python-numpy python-numpy-dbg python-numpy-doc python-opengl python-qt4 python-qt4-dbg python-qt4-dev python-qt4-doc python-qwt5-qt4 python-requests python-scipy python-sphinx python-tk python-wxgtk2.8 qt4-bin-dbg qt4-default qt4-dev-tools qt4-doc r-base-dev swig wget\e[0m"
fi

if [[ $pc_no_rfnoc!=0 || $pc_rfnoc!=0 || ettus_rfnoc!=0 || ettus_no_rfnoc!=0 ]]
	then
		echo -e "\e[36mDescargando datos...\e[0m"
		mkdir ~/ETTUS
		cd ~/ETTUS
		#agregar comando de descarga de archivos

		if [[ -d ~/ETTUS/sysroots && -f ~/ETTUS/version-armv7ahf-vfp-neon-oe-linux-gnueabi && -f ~/ETTUS/site-config-armv7ahf-vfp-neon-oe-linux-gnueabi && -f ~/ETTUS/environment-setup-armv7ahf-vfp-neon-oe-linux-gnueabi]]
			else
				if [[ -x ~/ETTUS/oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh ]]
					then
						sh oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh -d ~/ETTUS/ -y
					else
						echo -e "\e[31mEl archivo 'oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh' no cuenta con permisos de ejecución. Cambie los permisos de este archivo mediante 'sudo chmod a+x oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh' y ejecute el instador nuevamente.\e[0m"
						exit
		fi

		if [[ $pc_no_rfnoc=1 && $pc_rfnoc=0]]
			then
				cd ~/ETTUS
				cd uhd/host/
				mkdir build
				cd  build
				cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_E300=ON -DE300_FORCE_NETWORK=ON ..
				make -j2
				make install
				ldconfig

				cd ~/ETTUS
				cd gnuradio
				mkdir build
				cd build
				cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
				make -j2
				make install
				ldconfig
			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para PC, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/local/\e[0m"
				echo
		fi

		if [[ $pc_rfnoc=1 && $pc_no_rfnoc=0]]
			then
				cd ~/ETTUS
				cd uhd-rfnoc/host/
				mkdir build
				cd  build
				cmake -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_E300=ON -DE300_FORCE_NETWORK=ON ..
				make -j2
				make install
				ldconfig

				cd ~/ETTUS
				cd gnuradio
				mkdir build
				cd build
				cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
				make -j2
				make install
				ldconfig

				cd ~/ETTUS
				cd gr-ettus
				mkdir build
				cd build
				cmake -DCMAKE_INSTALL_PREFIX=/usr/local ..
				make -j2
				make install
				ldconfig
			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para PC, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/local/\e[0m"
				echo
		fi

		if [[ $ettus_no_rfnoc=1 && $ettus_rfnoc=0]]
			then
				cd ~/ETTUS
				cd uhd/host/
				mkdir build
				cd  build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../host/cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_DOXYGEN=False -DENABLE_E300=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/root-ettus # instalamos en la placa
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi #instalamos pisando el toolchain

				cd ~/ETTUS
				cd gnuradio
				mkdir build
				cd build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_GR_VOCODER=OFF -DENABLE_GR_ATSC=OFF -DENABLE_GR_WXGUI=OFF -DENABLE_GR_DTV=OFF -DENABLE_DOXYGEN=False -DENABLE_GR_AUDIO=ON -DENABLE_GR_BLOCKS=ON -DENABLE_GR_DIGITAL=ON -DENABLE_GR_FEC=ON -DENABLE_GR_FFT=ON -DENABLE_GR_FILTER=ON -DENABLE_GR_QTGUI=ON -DENABLE_GR_UHD=ON -DENABLE_PYTHON=ON -DENABLE_VOLK=ON -DENABLE_GRC=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/root-ettus
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi
			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO+RFNoC por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para la USRP, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/\e[0m"
				echo
		fi

		if [[ $ettus_no_rfnoc=0 && $ettus_rfnoc=1]]
			then
				cd ~/ETTUS
				cd uhd-rfnoc/host/
				mkdir build
				cd  build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../host/cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_DOXYGEN=False -DENABLE_E300=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/root-ettus # instalamos en la placa
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi #instalamos pisando el toolchain

				cd ~/ETTUS
				cd gnuradio
				mkdir build
				cd build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_GR_VOCODER=OFF -DENABLE_GR_ATSC=OFF -DENABLE_GR_WXGUI=OFF -DENABLE_GR_DTV=OFF -DENABLE_DOXYGEN=False -DENABLE_GR_AUDIO=ON -DENABLE_GR_BLOCKS=ON -DENABLE_GR_DIGITAL=ON -DENABLE_GR_FEC=ON -DENABLE_GR_FFT=ON -DENABLE_GR_FILTER=ON -DENABLE_GR_QTGUI=ON -DENABLE_GR_UHD=ON -DENABLE_PYTHON=ON -DENABLE_VOLK=ON -DENABLE_GRC=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/root-ettus
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi

				cd ~/ETTUS
				cd gr-ettus
				mkdir build
				cd build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../../gnuradio/cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_DOXYGEN=OFF ..
				make -j2
				make install DESTDIR=~/ETTUS/root-ettus
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi

			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO+RFNoC por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para la USRP, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/\e[0m"
				echo
		fi

fi

echo "Se termino el proceso de instalación"