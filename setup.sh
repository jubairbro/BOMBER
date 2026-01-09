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

echo -e "${YELLOW}[*] Updating System Packages...${NC}"
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1

echo -e "${YELLOW}[*] Installing Python & Git...${NC}"
pkg install python git -y > /dev/null 2>&1

echo -e "${YELLOW}[*] Installing Python Dependencies...${NC}"
pip install requests rich pyfiglet fake-useragent > /dev/null 2>&1

echo -e "${YELLOW}[*] Setting up Global Command...${NC}"

# Termux Binary Path
BIN_PATH="$PREFIX/bin"

# Check if bin exists, else fallback to standard linux
if [ ! -d "$BIN_PATH" ]; then
    BIN_PATH="/usr/bin"
fi

# Create the executable file
cat <<EOF > "$BIN_PATH/bomb"
#!/bin/bash
cd \$HOME/BOMBER && python3 main.py "\$@"
EOF

# Give permission
chmod +x "$BIN_PATH/bomb"

# Setup alias BOMB as well
cp "$BIN_PATH/bomb" "$BIN_PATH/BOMB"
chmod +x "$BIN_PATH/BOMB"

echo -e "${GREEN}[✔] Installation Complete!${NC}"
echo -e "${CYAN}----------------------------------------${NC}"
echo -e "   Type ${GREEN}bomb${NC} or ${GREEN}BOMB${NC} to run the tool."
echo -e "${CYAN}----------------------------------------${NC}"
