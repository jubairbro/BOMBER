#!/bin/bash

# --- COLORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${CYAN}==========================================${NC}"
echo -e "${CYAN}      SENSEI AUTOMATIC INSTALLER          ${NC}"
echo -e "${CYAN}==========================================${NC}"

# 1. ENVIRONMENT SETUP
echo -e "${YELLOW}[*] Updating system packages...${NC}"
pkg update -y > /dev/null 2>&1
pkg upgrade -y > /dev/null 2>&1

echo -e "${YELLOW}[*] Installing Git & Python...${NC}"
pkg install git python -y > /dev/null 2>&1

# 2. REPOSITORY MANAGEMENT
cd $HOME
if [ -d "BOMBER" ]; then
    echo -e "${GREEN}[*] Existing directory found. Pulling updates...${NC}"
    cd BOMBER
    git pull > /dev/null 2>&1
else
    echo -e "${GREEN}[*] Cloning repository from GitHub...${NC}"
    git clone https://github.com/jubairbro/BOMBER > /dev/null 2>&1
    cd BOMBER
fi

# 3. DEPENDENCY INSTALLATION
echo -e "${YELLOW}[*] Installing required Python modules...${NC}"
pip install requests rich pyfiglet fake-useragent > /dev/null 2>&1

# 4. GLOBAL COMMAND SETUP
echo -e "${YELLOW}[*] Creating global 'bomb' command...${NC}"

# Detect Binary Path
if [ -d "$PREFIX/bin" ]; then
    BIN_DIR="$PREFIX/bin"
else
    BIN_DIR="/usr/bin"
fi

# Create the executable wrapper
echo '#!/bin/bash' > "$BIN_DIR/bomb"
echo 'cd $HOME/BOMBER && python3 main.py "$@"' >> "$BIN_DIR/bomb"

# Apply Permissions
chmod +x "$BIN_DIR/bomb"
cp "$BIN_DIR/bomb" "$BIN_DIR/BOMB" 2>/dev/null

echo -e "\n${GREEN}[✔] INSTALLATION SUCCESSFUL!${NC}"
echo -e "${CYAN}------------------------------------------${NC}"
echo -e "You can now run the tool by typing: ${GREEN}bomb${NC}"
echo -e "${CYAN}------------------------------------------${NC}"
