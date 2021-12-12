LINK='\033[1;34m' #blue
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
echo "updating..."
sudo apt update
sudo apt install unzip lzip git

while ! find MicrosoftCorporationII.WindowsSubsystemForAndroid*.msixbundle 1> /dev/null 2>&1
do
  echo -e "\n\msixbundle not found - download from: ${LINK}https://store.rg-adguard.net/${NC} (Ctrl+Click)\nProductId: 9P3395VX91NR, Ring: SLOW\n\nPress enter once downloaded to current folder" ; read -p "($PWD)"
done
echo msixbundle found!

while ! find open_gapps*pico*.zip 1> /dev/null 2>&1
do
  echo -e "\n\nGApps not found - download from: ${LINK}https://opengapps.org/${NC} (Ctrl+Click)\nPlatform: x86_64 if Windows architecture is x64, otherwise choose ARM64\nAndroid: 11 and Variant: Pico on\n\nPress enter once downloaded to current folder" ; read -p "($PWD)"
done
echo GApps found!

rm -rf WSAGAScript/ #cleanup from previous installation
git clone https://github.com/WSA-Community/WSAGAScript
mkdir WSAGAScript/#MSIX

while true; do
	echo -e "${YELLOW}press x for x64 architecture or a for ARM64${NC}"
    read -p "" -n 1 xa
    echo
    case $xa in
        [Aa]* )
			echo "extracting ARM64 version, please wait...";
			sed -i '7s/.*/Architecture="arm64"/' WSAGAScript/VARIABLES.sh #edit script to ARM architecture
			unzip -p MicrosoftCorporationII.WindowsSubsystemForAndroid* *ARM64_Release-Nightly.msix > WSAGAScript/#MSIX/ARM64.msix
			unzip WSAGAScript/#MSIX/ARM64.msix -d WSAGAScript/#MSIX/
			rm WSAGAScript/#MSIX/ARM64.msix;
			break;;
        [Xx]* )
			echo "extracting x64 verison, please wait...";
			unzip -p MicrosoftCorporationII.WindowsSubsystemForAndroid* *x64_Release-Nightly.msix > WSAGAScript/#MSIX/x64.msix
			unzip WSAGAScript/#MSIX/x64.msix -d WSAGAScript/#MSIX/
			rm WSAGAScript/#MSIX/x64.msix;
			break;;
        * ) echo "Please answer x or a for x64 or ARM64.";;
    esac
done
echo "done extracting"

echo "prepearing #IMAGES and #GAPPS folder"
rm -rf WSAGAScript/#MSIX/AppxMetadata/ WSAGAScript/#MSIX/AppxBlockMap.xml WSAGAScript/#MSIX/[Content_Types].xml WSAGAScript/#MSIX/AppxSignature.p7x
mv WSAGAScript/#MSIX/*.img WSAGAScript/#IMAGES
cp open_gapps*pico*.zip WSAGAScript/#GAPPS/ 

cd WSAGAScript
chmod +x extract_gapps_pico.sh
chmod +x extend_and_mount_images.sh
chmod +x apply.sh
chmod +x unmount_images.sh

./extract_gapps_pico.sh
sudo ./extend_and_mount_images.sh
sudo ./apply.sh
sudo ./unmount_images.sh

echo "moving edited images to intall location"
mv ./#IMAGES/*.img ./#MSIX/

echo -e "${YELLOW}Nearly done:${NC}"
echo "Enable developer mode in windows settings."
echo "Uninstall any other installed versions of WSA"
echo "Open Windows PowerShell (not PowerShell) as admin and run:"
echo -e "${LINK}Add-AppxPackage -Register $(wslpath -w \#MSIX)\\AppxManifest.xml${NC}\n"
read -n 1 -s -r -p "Press any key to continue"
echo
echo
echo

echo "Start \"Windows Subsystem for Android\" from Start Menu"
echo "Open Files (first in list)"
echo "(optional) Disable Diagnodstic Data"
echo "wait... until Downloads Folder opens and close it"
read -n 1 -s -r -p "Press any key to continue"
echo
echo

echo "Everyting should be installed now"
echo "Remaining Folder/Files: WSAGAScript, MicrosoftCorporation...msixbundle, open_gapps...zip, intallWSAGA,sh"
echo "delete them manually or keep if something breaks"
