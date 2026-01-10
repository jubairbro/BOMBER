#!/bin/bash

# --- COLORS ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- UI ELEMENTS ---
T_TOP="┌──────────────────────────────────────────┐"
T_MID="│"
T_BOT="└──────────────────────────────────────────┘"
SEP="├──────────────────────────────────────────┤"

clear

# --- HEADER ---
echo -e "${CYAN}${T_TOP}"
echo -e "${T_MID}          SENSEI ULTIMATE INSTALLER         ${T_MID}"
echo -e "${T_MID}             Version: 6.7 Pro               ${T_MID}"
echo -e "${CYAN}${T_BOT}${NC}"

# --- STEP 0: PROCEED CONFIRMATION ---
echo -e "\n${CYAN}►${NC} Do you want to proceed with installation? [Y/n]"
read -p "  » " PROCEED
PROCEED=${PROCEED:-Y}

if [[ ! "$PROCEED" =~ ^[Yy]$ ]]; then
    echo -e "${RED}[!] Installation Aborted.${NC}"
    exit 1
fi

# --- STEP 1: OPTIONAL UPDATE ---
echo -e "\n${CYAN}►${NC} Update system packages and mirrors? [y/N]"
read -p "  » " UPDATE_CHOICE
UPDATE_CHOICE=${UPDATE_CHOICE:-N}

if [[ "$UPDATE_CHOICE" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}  » Updating mirrors and core packages...${NC}"
    pkg update -y > /dev/null 2>&1
else
    echo -e "${YELLOW}  » Skipping full update...${NC}"
fi

# --- STEP 2: NECESSARY PACKAGES ---
echo -e "\n${CYAN}┌─ Checking Essential Dependencies${NC}"
for pkg in git python mpv; do
    if command -v $pkg &> /dev/null; then
        echo -e "${CYAN}│${NC}  » $pkg is already installed."
    else
        echo -e "${CYAN}│${NC}  » Installing $pkg..."
        pkg install $pkg -y > /dev/null 2>&1
    fi
done
echo -e "${CYAN}└──────────────────────────────────────────${NC}"

# --- STEP 3: REPOSITORY SETUP ---
echo -e "\n${CYAN}►${NC} Setting up repository in HOME..."
cd $HOME
if [ -d "BOMBER" ]; then
    echo -e "${YELLOW}  » Directory exists. Pulling latest code...${NC}"
    cd BOMBER
    git pull > /dev/null 2>&1
else
    echo -e "${YELLOW}  » Cloning SENSEI repository...${NC}"
    git clone https://github.com/jubairbro/BOMBER > /dev/null 2>&1
    cd BOMBER
fi

# --- STEP 4: PYTHON MODULES ---
echo -e "\n${CYAN}►${NC} Installing Python dependencies..."
pip install requests rich pyfiglet fake-useragent > /dev/null 2>&1

# --- STEP 5: GLOBAL COMMAND SETUP ---
echo -e "\n${CYAN}►${NC} Creating global 'bomb' command..."

# Detect Binary Path
if [ -d "$PREFIX/bin" ]; then
    BIN_DIR="$PREFIX/bin"
else
    BIN_DIR="/usr/bin"
fi

# Create the wrapper
# We use cd $HOME/BOMBER so that git operations and relative paths work perfectly
echo "#!/bin/bash" > "$BIN_DIR/bomb"
echo "cd $HOME/BOMBER && python3 main.py \"\$@\"" >> "$BIN_DIR/bomb"

# Permissions
chmod +x "$BIN_DIR/bomb"
cp "$BIN_DIR/bomb" "$BIN_DIR/BOMB" 2>/dev/null

# --- FINAL FOOTER ---
clear
echo -e "${GREEN}${T_TOP}"
echo -e "${T_MID}       INSTALLATION COMPLETED! (✔)          ${T_MID}"
echo -e "${GREEN}${SEP}"
echo -e "${T_MID}  » Command: ${CYAN}bomb${GREEN} or ${CYAN}BOMB${GREEN}               ${T_MID}"
echo -e "${T_MID}  » Developer: @JubairZ                     ${T_MID}"
echo -e "${GREEN}${T_BOT}${NC}"

echo -e "\n${CYAN}►${NC} Type ${GREEN}bomb${NC} to start the tool now."
