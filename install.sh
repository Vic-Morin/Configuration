#!/bin/bash
###############################################################################
# Replace the file $original with a link to another file $installDir/$2.
# If the file to be replaced exists and is not a link, the the file is renamed
# to $original.bak.
# If the file is already a link, the like replaced by a link to our file.
###############################################################################/
replace_with_link(){
   original=$1
   target=$installDir/$2
   if [ -L $original ] ; then
      rm $original
   elif [ -e $original -o -d $original ] ; then
      mv $original $original.bak
   fi
   ln -s $target $original
}

###############################################################################
# Installs files by replacing existing files (backups are made) with links to
# our files from $installDir.
# The first argument specifies a group of replacements to be made in case we
# want to do some parts selectively.
###############################################################################/
installGroup() {
	local group=$1
case $group in
	bash)
		replace_with_link $HOME/.bashrc bashrc
		replace_with_link $HOME/.bash_profile bash_profile
		;;
	git)
		replace_with_link $HOME/.gitconfig gitconfig
		# replace_with_link $HOME/.git-completion.bash git-completion.bash
		# replace_with_link $HOME/.git-prompt.sh git-prompt.sh
		# replace_with_link $HOME/.gitignore.global gitignore.global
		;;
	*)
		echo Invalid group
		showUsage
		;;
esac
}

###############################################################################
# Prints the usage of our install.sh script.
###############################################################################/
showUsage()
{
	printf "
	A completer: C'est surprenant combien vite on peut oublier comment nos
	programmes fonctinonnent.
"
}

# Get installDir from command line or link target.
# not a 100% robust method, look at
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
# for more detail
if [ `uname` = Darwin ] ; then
   installDir="$( cd "$( dirname $0 )" && pwd)"
elif [ `uname` = Linux ] ; then
   installDir="$( dirname "$( readlink -f "$0" )" )"
fi

# Do the install
group_to_install=$1
if [ "$group_to_install" = full ] ; then
   installGroup bash
   installGroup git
elif [ "$group_to_install" != "" ] ; then
   installGroup $group_to_install
else
   echo Must specify one group or full
   showUsage
fi
