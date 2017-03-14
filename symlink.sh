cd $(dirname $0)
for dotfile in .?*
do
    if [ $dotfile != '..' ] && [ $dotfile != '.git' ]
    then
        ln -fs "$PWD/$dotfile" "$HOME/$dotfile"
    fi
done
