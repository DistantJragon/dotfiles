# This function creates a new bash script file with executable permissions.
function new-bash-script
    if test (count $argv) -ne 1
        echo "Usage: new-bash-script <script-name>"
        return 1
    end

    set script_name $argv[1]

    # Check if the file already exists
    if test -e $script_name
        echo "Error: File '$script_name' already exists."
        return 1
    end

    # Create the bash script file with a shebang line
    printf '#!/usr/bin/env bash\n\n' > $script_name

    # Make the script executable
    chmod +x $script_name

    echo "Created new bash script: $script_name"
end
