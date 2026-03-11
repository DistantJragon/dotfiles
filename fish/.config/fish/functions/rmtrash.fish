# Send file(s) to trash with kioclient
function rmtrash
    if test (count $argv) -eq 0
        echo "Usage: rmtrash <file1> <file2> ..."
        return 1
    end

    for file in $argv
        if test -e $file
            kioclient move $file trash:/
        else
            echo "rmtrash: cannot remove '$file': No such file or directory"
        end
    end
end
