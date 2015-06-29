LN_FLAGS = -sfnv
MKDIR_FLAGS = -pv

home_symlinks = gnupg/gpg.conf \
	ncmpcpp/bindings \
	ncmpcpp/config \
	profile \
	tmux.conf \
	weechat/perl \
	weechat/alias.conf \
	weechat/plugins.conf \
	Xkbmap \
	Xresources \
	zshrc

config_symlinks = alot/themes \
	ansible/ansible.cfg \
	cower/config \
	dunst/dunstrc \
	gtk-2.0/gtkrc \
	gtk-3.0/gtk.css \
	gtk-3.0/settings.ini \
	i3 \
	mpv/mpv.conf \
	pacman/makepkg.conf \
	ranger/rc.conf \
	roxterm.sourceforge.net \
	vim \
	zsh

all: install

install: alot ansible dunst gnupg gtk-2.0 gtk-3.0 i3 mpv roxterm.sourceforge.net tmux.conf vim Xkbmap Xresources zsh zshenv zshrc

.PHONY: $(home_symlinks)
$(home_symlinks):
	$(eval DESTDIR := $(shell dirname ~/.$@))
	mkdir $(MKDIR_FLAGS) $(DESTDIR)
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

.PHONY: $(config_symlinks)
$(config_symlinks):
	$(eval DESTDIR := $(shell dirname ~/.config/$@))
	mkdir $(MKDIR_FLAGS) $(DESTDIR)
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.config/$@

alot: alot/themes
	mkdir $(MKDIR_FLAGS) ~/.config/alot

ansible: ansible/ansible.cfg
	mkdir $(MKDIR_FLAGS) ~/.config/ansible

dunst: dunst/dunstrc
	mkdir $(MKDIR_FLAGS) ~/.config/dunst

gnupg: gnupg/gpg.conf
	mkdir $(MKDIR_FLAGS) ~/.gnupg

gtk-2.0: gtk-2.0/gtkrc
	mkdir $(MKDIR_FLAGS) ~/.config/gtk-2.0

gtk-3.0: gtk-3.0/gtk.css gtk-3.0/settings.ini
	mkdir $(MKDIR_FLAGS) ~/.config/gtk-3.0

mpv: mpv/mpv.conf
	mkdir $(MKDIR_FLAGS) ~/.config/mpv

ncmpcpp: ncmpcpp/bindings ncmpcpp/config
	mkdir $(MKDIR_FLAGS) ~/.ncmpcpp

ranger: ranger/rc.conf
	mkdir $(MKDIR_FLAGS) ~/.config/ranger

weechat: weechat/perl weechat/alias.conf weechat/plugins.conf
	mkdir $(MKDIR_FLAGS) ~/.weechat

zshenv:
	test -e $(CURDIR)/profile && ln $(LN_FLAGS) $(CURDIR)/profile ~/.zshenv
