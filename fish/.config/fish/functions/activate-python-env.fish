# Activate a Python virtual environment in Fish shell
function activate-python-env
    if test (count $argv) -eq 0
        # Try to find a virtual environment in the current directory
        if test -d "venv"
            set venv_path "venv"
        else if test -d ".venv"
            set venv_path ".venv"
        else
            echo "No virtual environment found in the current directory."
            return 1
        end
    else
        set venv_path $argv[1]
    end
    if test -d "$venv_path"
        source "$venv_path/bin/activate.fish"
        echo "Activated virtual environment at $venv_path"
    else
        echo "The specified path '$venv_path' is not a valid directory."
        return 1
    end
end
