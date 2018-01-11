LN_FLAGS = -sfnv
MKDIR_FLAGS = -pv

home_symlinks = gnupg/dirmngr.conf \
	gnupg/gpg.conf \
	ncmpcpp/bindings \
	ncmpcpp/config \
	profile \
	terminfo \
	tmux.conf \
	weechat/perl \
	weechat/alias.conf \
	weechat/plugins.conf \
	Xkbmap \
	Xresources \
	zshrc

config_copy = systemd/user/autossh@.service \
	systemd/user/gpg-agent.service

config_symlinks = alot/themes \
	ansible/ansible.cfg \
	compton.conf \
	cower/config \
	dunst/dunstrc \
	gtk-2.0/gtkrc \
	gtk-3.0/gtk.css \
	gtk-3.0/settings.ini \
	i3 \
	i3status \
	mpv/mpv.conf \
	nvim/init.vim \
	pacman/makepkg.conf \
	ranger/rc.conf \
	ranger/rifle.conf \
	rofi \
	roxterm.sourceforge.net \
	termite \
	vim \
	xpra \
	zsh

all: install

install: alot ansible compton.conf dunst gnupg gtk-2.0 gtk-3.0 i3 i3status \
	mpv nvim ranger rofi roxterm.sourceforge.net systemd terminfo termite \
	tmux.conf vim Xkbmap xpra Xresources zsh zprofile zshrc

.PHONY: $(home_symlinks)
$(home_symlinks):
	$(eval DESTDIR := $(shell dirname ~/.$@))
	mkdir $(MKDIR_FLAGS) $(DESTDIR)
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

.PHONY: $(config_copy)
$(config_copy):
	$(eval DESTDIR := $(shell dirname ~/.config/$@))
	mkdir $(MKDIR_FLAGS) $(DESTDIR)
	test -e $(CURDIR)/$@ && cp --remove-destination -p $(CURDIR)/$@ ~/.config/$@

.PHONY: $(config_symlinks)
$(config_symlinks):
	$(eval DESTDIR := $(shell dirname ~/.config/$@))
	mkdir $(MKDIR_FLAGS) $(DESTDIR)
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.config/$@

alot: alot/themes

ansible: ansible/ansible.cfg

dunst: dunst/dunstrc

gnupg: gnupg/dirmngr.conf gnupg/gpg.conf

gtk-2.0: gtk-2.0/gtkrc

gtk-3.0: gtk-3.0/gtk.css gtk-3.0/settings.ini

i3status: i3status

mpv: mpv/mpv.conf

ncmpcpp: ncmpcpp/bindings ncmpcpp/config

nvim: nvim/init.vim

ranger: ranger/rc.conf ranger/rifle.conf

systemd: systemd/user/autossh@.service systemd/user/gpg-agent.service

terminfo: terminfo/x/xterm-termite

termite: termite/config

weechat: weechat/perl weechat/alias.conf weechat/plugins.conf

xpra: xpra/xpra.conf

zprofile:
	test -e $(CURDIR)/profile && ln $(LN_FLAGS) $(CURDIR)/profile ~/.zprofile
