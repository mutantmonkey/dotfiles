LN_FLAGS = -sfn

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
				  roxterm.sourceforge.net \
				  vim \
				  zsh

all: install

install: alot ansible dunst gnupg gtk-2.0 gtk-3.0 i3 mpv roxterm.sourceforge.net tmux.conf vim Xkbmap Xresources zsh zshenv zshrc

.PHONY: $(home_symlinks)
$(home_symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.$@

.PHONY: $(config_symlinks)
$(config_symlinks):
	test -e $(CURDIR)/$@ && ln $(LN_FLAGS) $(CURDIR)/$@ ~/.config/$@

alot: alot/themes

ansible: ansible/ansible.cfg

dunst: dunst/dunstrc

gnupg: gnupg/gpg.conf

gtk-2.0: gtk-2.0/gtkrc

gtk-3.0: gtk-3.0/settings.ini

mpv: mpv/mpv.conf

ncmpcpp: ncmpcpp/bindings ncmpcpp/config

weechat: weechat/perl weechat/alias.conf weechat/plugins.conf

zshenv:
	test -e $(CURDIR)/profile && ln $(LN_FLAGS) $(CURDIR)/profile ~/.zshenv
