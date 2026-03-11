function update-djn
    if ! command -q arch-news-checker-djn
        echo "arch-news-checker-djn is not installed. Please install it first."
        return 1
    end

    arch-news-checker-djn -c
    set news_status $status
    if test $news_status -eq 0
        sudo pacman -Syu
        paru -Syu
    else if test $news_status -eq 2
        echo "There are new Arch Linux news items. Please read them before updating. (arch-news-checker-djn -h)"
        return 1
    else
        echo "There was an issue fetching the news. Aborting system update."
        return 1
    end
end
