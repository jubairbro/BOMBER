#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}===============================${NC}"
echo -e "${CYAN}   SENSEI INSTALLER SCRIPT     ${NC}"
echo -e "${CYAN}===============================${NC}"

# 1. Update Packages
echo -e "${YELLOW}[*] Checking System Packages...${NC}"
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1

# 2. Install Git & Python
echo -e "${YELLOW}[*] Installing Git & Python...${NC}"
pkg install git python -y > /dev/null 2>&1

# 3. CLONE OR UPDATE REPOSITORY
cd $HOME
if [ -d "BOMBER" ]; then
    echo -e "${GREEN}[*] Updating Existing Tool...${NC}"
    cd BOMBER
    git pull > /dev/null 2>&1
else
    echo -e "${GREEN}[*] Cloning Repository...${NC}"
    git clone https://github.com/jubairbro/BOMBER > /dev/null 2>&1
    cd BOMBER
fi

# 4. Install Dependencies
echo -e "${YELLOW}[*] Installing Python Dependencies...${NC}"
pip install requests rich pyfiglet fake-useragent > /dev/null 2>&1

# 5. Setup Global Command
echo -e "${YELLOW}[*] Setting up 'bomb' command...${NC}"

BIN_PATH="$PREFIX/bin"
if [ ! -d "$BIN_PATH" ]; then
    BIN_PATH="/usr/bin"
fi

cat <<EOT > "$BIN_PATH/bomb"
#!/bin/bash
cd $HOME/BOMBER
python3 main.py "$@"
EOT

chmod +x "$BIN_PATH/bomb"
cp "$BIN_PATH/bomb" "$BIN_PATH/BOMB"
chmod +x "$BIN_PATH/BOMB"

echo -e "\n${GREEN}[✔] INSTALLATION COMPLETE!${NC}"
echo -e "Type ${GREEN}bomb${NC} to start."
