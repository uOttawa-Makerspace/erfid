# ERFID

A simple ruby script for the rasbperry pi to let people sign in and out of a makerspace

## INSTALLATION

 1. Install libnfc. Follow this great [Adafruit guide](https://learn.adafruit.com/adafruit-nfc-rfid-on-raspberry-pi/building-libnfc)
 2. Run `bundle install`
 3. Wire the reader via UART (see WIRING)
 4. copy `erfid.sh` to `/etc/init.d/erfid.sh`
 5. `chmod 755 /etc/init.d/erfid.sh`
 6. run `sudo update-rc.d erfid defaults` to have the script start at boot

## DEBUGGING

Run `sudo tmux attach -t erfid` to see logs

## WIRING

Set the PN532 to UART mode by setting both jumpers to off

Connect a 5V pin on the Pi to 5v on the breakout
Connect a GND pin to GND on the breakout board
Connect GPIO 14 (TXD) to TXD on breakout board
Connect GPIO 15 (RXD) to RXD on breakout board
Connect GPIO 23 to a SUCCESS LED
Connect GPIO 24 to a FAILURE LED
