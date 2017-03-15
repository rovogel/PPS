#!/bin/bash

function pause(){
   read -p "Presione una tecla para continuar..."
}

echo -e "\e[37m...\e[0m"
echo -e "\e[37m...\e[0m"
echo -e "\e[37mScript para la generación e instalacion del software UHD + GNURadio + RFNoC\e[0m"
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
ip=192.168.1.8

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

#Crear árbol de directorio necesario para la instalación
if [[ -d ~/ETTUS ]]
	then
		if [[ ! -d ~/ETTUS/src ]]
			then
				mkdir ~/ETTUS/src
		fi

		if [[ ! -d ~/ETTUS/build ]]
			then
				mkdir ~/ETTUS/build
		fi

		if [[ ! -d ~/ETTUS/remoto/  ]]
			then
				mkdir ~/ETTUS/remoto
				mkdir ~/ETTUS/remoto/usr
				mkdir ~/ETTUS/remoto/etc
		fi
	else
		mkdir ~/ETTUS
		mkdir ~/ETTUS/src
		mkdir ~/ETTUS/build
		mkdir ~/ETTUS/remoto
		mkdir ~/ETTUS/remoto/usr
		mkdir ~/ETTUS/remoto/etc
fi

echo
echo -e "\e[36mEn el directorio $HOME :\e[0m"
echo -e "\e[36m|+ ETTUS\e[0m"
echo -e "\e[36m|||+ src\e[0m"
echo -e "\e[36m|||+ build\e[0m"
echo -e "\e[36m|||+ remoto\e[0m"
echo -e "\e[36m|||||+ usr\e[0m"
echo -e "\e[36m|||||+ etc\e[0m"
echo

#comprueba si existe la carpeta principal de construcción y las fuentes
if [[ ! -d ~/ETTUS/src/PPS/uhd && ! -d ~/ETTUS/src/PPS/uhd-rfnoc && ! -d ~/ETTUS/src/PPS/gnuradio && ! -d ~/ETTUS/src/PPS/gr-ettus && ! -d ~/ETTUS/src/PPS/fpga ]]
	then

		if [[ -f ~/ETTUS/src/PPS/uhd.zip && -f ~/ETTUS/src/PPS/uhd-rfnoc.zip && -f ~/ETTUS/src/PPS/gnuradio.zip && -f ~/ETTUS/src/PPS/gr-ettus.zip && -f ~/ETTUS/src/PPS/fpga.zip ]]
			then
				cd ~/ETTUS/src/PPS
				unzip uhd.zip
				unzip uhd-rfnoc.zip
				unzip gnuradio.zip
				unzip fpga.zip
				unzip gr-ettus.zip
			else
				cd ~/ETTUS/src
				git clone https://github.com/rovogel/PPS.git
				cd ~/ETTUS/src/PPS
				unzip uhd.zip
				unzip uhd-rfnoc.zip
				unzip gnuradio.zip
				unzip fpga.zip
				unzip gr-ettus.zip
		fi
fi

#comprueba si ya está descargado el toolchain
if [[ ! -f ~/ETTUS/oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh ]]
	then
		cd ~/ETTUS
		wget -t 5 http://files.ettus.com/e3xx_images/e3xx-release-4/oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh
	else
		echo "Binario del Toolchain encontrado."
fi

#comprueba si el toolchain ya fue instalado, caso contrario lo instala en ~/ETTUS/
if [[ ! -d ~/ETTUS/sysroots && ! -f ~/ETTUS/version-armv7ahf-vfp-neon-oe-linux-gnueabi && ! -f ~/ETTUS/site-config-armv7ahf-vfp-neon-oe-linux-gnueabi && ! -f ~/ETTUS/environment-setup-armv7ahf-vfp-neon-oe-linux-gnueabi ]]
	then
		if [[ -x ~/ETTUS/oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh ]]
			then
				cd ~/ETTUS/
				sh oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh -d ~/ETTUS/ -y
			else
				echo -e "\e[31mEl archivo 'oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh' no cuenta con permisos de ejecución o no existe. Si este existe, examine el nombre del mismo o cambie los permisos de este mediante 'sudo chmod a+x oecore-x86_64-armv7ahf-vfp-neon-toolchain-nodistro.0.sh' y ejecute el instador nuevamente.\e[0m"
				exit
		fi
	else
		echo "---El Toolchain ya se encuentra instalado en la carpeta principal."
fi

#Creando los directorios para la construccion de cada componente (uhd/host/build, gnuradio/build, etc)
if [[ -d ~/ETTUS/src/PPS/uhd/host/build ]]
	then
		if [[ $(ls -l ~/ETTUS/src/PPS/uhd/host/build | grep -c "total 0") != 0 ]]
			then
				cd ~/ETTUS/src/PPS/uhd/host/build
				rm -r *
		fi
	else
		mkdir ~/ETTUS/src/PPS/uhd/host/build
fi

if [[ -d ~/ETTUS/src/PPS/uhd-rfnoc/host/build ]]
	then
		if [[ $(ls -l ~/ETTUS/src/PPS/uhd-rfnoc/host/build | grep -c "total 0") != 0 ]]
			then
				cd ~/ETTUS/src/PPS/uhd-rfnoc/host/build
				rm -r *
		fi
	else
		mkdir ~/ETTUS/src/PPS/uhd-rfnoc/host/build
fi

if [[ -d ~/ETTUS/src/PPS/gnuradio/build ]]
	then
		if [[ $(ls -l ~/ETTUS/src/PPS/gnuradio/build | grep -c "total 0") != 0 ]]
			then
				cd ~/ETTUS/src/PPS/gnuradio/build
				rm -r *
		fi
	else
		mkdir ~/ETTUS/src/PPS/gnuradio/build
fi

if [[ -d ~/ETTUS/src/PPS/gr-ettus/build ]]
	then
		if [[ $(ls -l ~/ETTUS/src/PPS/gr-ettus/build | grep -c "total 0") != 0 ]]
			then
				cd ~/ETTUS/src/PPS/gr-ettus/build
				rm -r *
		fi
	else
		mkdir ~/ETTUS/src/PPS/gr-ettus/build
fi

#Descarga de toolchain y generacion de archivos segun la configuración elegida
if [[ $pc_no_rfnoc!=0 || $pc_rfnoc!=0 || ettus_rfnoc!=0 || ettus_no_rfnoc!=0 ]]
	then
		if [[ $pc_no_rfnoc=1 && $pc_rfnoc=0 ]]
			then

				#Si existen archivos generados, se borran antes de una nueva contrucción
				if [[ $(ls -l ~/ETTUS/build | grep -c "total 0") != 0 ]]
					then
						cd ~/ETTUS/build
						rm -r *
				fi

				cd ~/ETTUS/src/PPS/uhd/host/build
				cmake -DENABLE_E300=ON -DE300_FORCE_NETWORK=ON ..
				make -j2
				make install
				ldconfig

				cd ~/ETTUS/src/PPS/gnuradio/build
				cmake ..
				make -j2
				make install
				ldconfig
			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para PC, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/local/\e[0m"
				echo
		fi

		if [[ $pc_rfnoc=1 && $pc_no_rfnoc=0 ]]
			then

				#Si existen archivos generados, se borran antes de una nueva contrucción
				if [[ $(ls -l ~/ETTUS/build | grep -c "total 0") != 0 ]]
					then
						cd ~/ETTUS/build
						rm -r *
				fi

				cd ~/ETTUS/src/PPS/uhd-rfnoc/host/build
				cmake -DENABLE_E300=ON -DE300_FORCE_NETWORK=ON ..
				make -j2
				make install
				ldconfig

				cd ~/ETTUS/src/PPS/gnuradio/build
				cmake ..
				make -j2
				make install
				ldconfig

				cd ~/ETTUS/src/PPS/gr-ettus/build
				cmake ..
				make -j2
				make install
				ldconfig
			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para PC, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/local/\e[0m"
				echo
		fi

		if [[ $ettus_no_rfnoc=1 && $ettus_rfnoc=0 ]]
			then

				#Si existen archivos generados, se borran antes de una nueva contrucción
				if [[ $(ls -l ~/ETTUS/build | grep -c "total 0") != 0 ]]
					then
						cd ~/ETTUS/build
						rm -r *
				fi

				#Montamos el directorio /usr de la ettus en nuestro directorio principal
				sshfs root@$ip:/usr ~/ETTUS/remoto/usr
				sshfs root@$ip:/etc ~/ETTUS/remoto/etc

				cd ~/ETTUS/src/PPS/uhd/host/build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../host/cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_DOXYGEN=False -DENABLE_E300=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/build # instalamos en la placa
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi #instalamos pisando el toolchain

				cd ~/ETTUS/src/PPS/gnuradio/build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_GR_VOCODER=OFF -DENABLE_GR_ATSC=OFF -DENABLE_GR_WXGUI=OFF -DENABLE_GR_DTV=OFF -DENABLE_DOXYGEN=False -DENABLE_GR_AUDIO=ON -DENABLE_GR_BLOCKS=ON -DENABLE_GR_DIGITAL=ON -DENABLE_GR_FEC=ON -DENABLE_GR_FFT=ON -DENABLE_GR_FILTER=ON -DENABLE_GR_QTGUI=ON -DENABLE_GR_UHD=ON -DENABLE_PYTHON=ON -DENABLE_VOLK=ON -DENABLE_GRC=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/build
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi

				cd ~/ETTUS/build
				cp -r usr/* ~/ETTUS/remoto/usr/
				cp -r etc/* ~/ETTUS/remoto/etc/

				fusermount -u ~/ETTUS/remoto/usr
				fusermount -u ~/ETTUS/remoto/etc

			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO+RFNoC por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para la USRP, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/\e[0m"
				echo
		fi

		if [[ $ettus_no_rfnoc=0 && $ettus_rfnoc=1 ]]
			then

				#Si existen archivos generados, se borran antes de una nueva contrucción
				if [[ $(ls -l ~/ETTUS/build | grep -c "total 0") != 0 ]]
					then
						cd ~/ETTUS/build
						rm -r *
				fi

				#Montamos el directorio /usr de la ettus en nuestro directorio principal
				sshfs root@$ip:/usr ~/ETTUS/remoto/usr
				sshfs root@$ip:/etc ~/ETTUS/remoto/etc

				pause

				cd ~/ETTUS/src/PPS/uhd-rfnoc/host/build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../host/cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_DOXYGEN=False -DENABLE_E300=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/build # instalamos en la placa
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi #instalamos pisando el toolchain

				pause

				cd ~/ETTUS/src/PPS/gnuradio/build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_GR_VOCODER=OFF -DENABLE_GR_ATSC=OFF -DENABLE_GR_WXGUI=OFF -DENABLE_GR_DTV=OFF -DENABLE_DOXYGEN=False -DENABLE_GR_AUDIO=ON -DENABLE_GR_BLOCKS=ON -DENABLE_GR_DIGITAL=ON -DENABLE_GR_FEC=ON -DENABLE_GR_FFT=ON -DENABLE_GR_FILTER=ON -DENABLE_GR_QTGUI=ON -DENABLE_GR_UHD=ON -DENABLE_PYTHON=ON -DENABLE_VOLK=ON -DENABLE_GRC=ON ..
				make -j2
				make install DESTDIR=~/ETTUS/build
				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi

				pause

				cd ~/ETTUS/src/PPS/gr-ettus/build
				cmake -Wno-dev -DCMAKE_TOOLCHAIN_FILE=../../gnuradio/cmake/Toolchains/oe-sdk_cross.cmake -DCMAKE_INSTALL_PREFIX=/usr -DENABLE_DOXYGEN=OFF ..
				make -j2
				make install DESTDIR=~/ETTUS/build
#				make install DESTDIR=~/ETTUS/sysroots/armv7ahf-vfp-neon-oe-linux-gnueabi

				pause

				cd ~/ETTUS/build
				cp -r usr/* ~/ETTUS/remoto/usr/
				cp -r etc/* ~/ETTUS/remoto/etc/

				pause

				fusermount -u ~/ETTUS/remoto/usr
				fusermount -u ~/ETTUS/remoto/etc

				pause
			else
				echo
				echo -e "\e[31mSolo se puede generar una version de UHD+GNURADIO+RFNoC por instalación!!\e[0m"
				echo -e "\e[31mNOTA: Cada vez que se genera una nueva versión para la USRP, se sobreescribe la versión ya instalada. La instalación se realiza en /usr/\e[0m"
				echo
		fi

fi

echo -e "\e[33mSe termino el proceso de instalación"