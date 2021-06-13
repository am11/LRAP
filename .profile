clock() {
  ~/.tty-clock/tty-clock -cf%d.%m.%Y
}

weather() {
  ~/.weather/show
}

testmojis() {
  echo "♥😀😂👌😎👍😍🙊🥱🥺✨✅🎊🏄"
}

export HTOPRC="$HOME"/.config/htop/htoprc2

if [ -z "$DISPLAY" ] && [ "$(tty)" = /dev/tty1 ]; then
    startx
fi
