SESSION="minecraft"
BASE_DIR="/home/sahilbhingarde404/fcrit"
SERVER_DIR="/home/sahilbhingarde404/fcrit/Minecraft server"
LOGFILE="/home/sahilbhingarde404/fcrit/cron.log"

echo "==== $(date) Restart cycle started ====" >> $LOGFILE

# 1. Notify players
screen -S $SESSION -X stuff "say Server restarting for backup in 10 seconds...\n"
sleep 10

# 2. Save + stop server
screen -S $SESSION -X stuff "save-all\n"
sleep 5
screen -S $SESSION -X stuff "stop\n"

# 3. Wait for shutdown
echo "Waiting for server to stop..." >> $LOGFILE
sleep 30

# 4. Git push from parent repo
cd "$BASE_DIR"

/usr/bin/git add .

/usr/bin/git commit -m "Backup $(date)"

/usr/bin/git push

# 5. Restart server using bootup.sh
echo "Restarting server..." >> $LOGFILE
screen -dmS $SESSION bash -c "cd \"$SERVER_DIR\" && ./bootup.sh"

echo "==== $(date) Restart complete ====" >> $LOGFILE
