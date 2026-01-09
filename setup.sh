#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

clear
echo -e "${CYAN}
   _____ ______ _   _  _____ ______ _____ 
  / ____|  ____| \ | |/ ____|  ____|_   _|
 | (___ | |__  |  \| | (___ | |__    | |  
  \___ \|  __| | . \` |\___ \|  __|   | |  
  ____) | |____| |\  |____) | |____ _| |_ 
 |_____/|______|_| \_|_____/|______|_____|
                                          
      ${YELLOW}BOMBER INSTALLER SCRIPT${NC}
"

# 1. Update Packages
echo -e "${YELLOW}[*] Checking System Packages...${NC}"
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1

# 2. Install Git & Python (Critical for cloning)
echo -e "${YELLOW}[*] Installing Git & Python...${NC}"
pkg install git python -y > /dev/null 2>&1

# 3. CLONE OR UPDATE REPOSITORY (Main Logic)
cd $HOME
if [ -d "BOMBER" ]; then
    echo -e "${GREEN}[*] Tool directory found! Updating...${NC}"
    cd BOMBER
    git pull > /dev/null 2>&1
else
    echo -e "${GREEN}[*] Cloning SENSEI Repository...${NC}"
    git clone https://github.com/jubairbro/BOMBER > /dev/null 2>&1
    cd BOMBER
fi

# 4. Install Dependencies
echo -e "${YELLOW}[*] Installing Python Modules...${NC}"
pip install requests rich pyfiglet fake-useragent > /dev/null 2>&1

# 5. Setup Global Command
echo -e "${YELLOW}[*] Creating Shortcut Command...${NC}"

# Termux Binary Path
BIN_PATH="$PREFIX/bin"

# Check if bin exists, else fallback
if [ ! -d "$BIN_PATH" ]; then
    BIN_PATH="/usr/bin"
fi

# Create the 'bomb' executable
cat <<EOF > "$BIN_PATH/bomb"
#!/bin/bash
cd \$HOME/BOMBER
python3 main.py "\$@"
EOF

# Give permission
chmod +x "$BIN_PATH/bomb"

# Setup alias BOMB
cp "$BIN_PATH/bomb" "$BIN_PATH/BOMB"
chmod +x "$BIN_PATH/BOMB"

echo -e "\n${GREEN}[✔] INSTALLATION SUCCESSFUL!${NC}"
echo -e "${CYAN}========================================${NC}"
echo -e "   Just type ${GREEN}bomb${NC} to run the tool!"
echo -e "${CYAN}========================================${NC}"
