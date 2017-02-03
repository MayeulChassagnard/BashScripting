#!bin/bash

script_dir="`cd $(dirname $0); pwd`"

# Install automatically every cmd located in /BashScripting/cmd

# give execution write to all files inside /BashScripting/cmd
cd $script_dir/cmd
ls > ../tmp_cmd_name_file.txt
for fn in `cat '../tmp_cmd_name_file.txt'`; do
  chmod +x $fn
done
# Remove tmp file
rm $script_dir/tmp_cmd_name_file.txt

# Update PATH in ~/.profile (even after restarting the computer)
echo '
# set PATH to include personal cmd from' $script_dir'/cmd' >> $HOME/.profile
echo 'export PATH=$PATH":'$script_dir'/cmd"
' >> $HOME/.profile

# Update the PATH right now
export PATH=$PATH":$script_dir/cmd"
