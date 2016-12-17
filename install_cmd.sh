#!bin/bash

# Install automatically every cmd located in /BashScripting/cmd

# give execution write to all files inside /BashScripting/cmd
cd cmd
ls > ../tmp_cmd_name_file.txt
for fn in `cat '../tmp_cmd_name_file.txt'`; do
  chmod +x $fn
done

# Update PATH in ~/.profile
echo 'export PATH=$PATH":$HOME/personnal_cmd/"' >> '~/.profile' 
