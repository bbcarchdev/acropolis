# This Makefile is used internally by BBC Archive Development to update the
# published sample configuration files from our internal Puppet manifest tree,
# which isn't public. It isn't really useful in any other context.

TEMPLATES = $(HOME)/adops/puppet/modules/global/templates/res

update: crawl.conf quilt.conf twine.conf

crawl.conf: $(TEMPLATES)/crawl.conf.erb
	cat vars.erb $< | erb -v > $@

quilt.conf: $(TEMPLATES)/quilt.conf.erb
	cat vars.erb $< | erb -v > $@

twine.conf: $(TEMPLATES)/twine.conf.erb
	cat vars.erb $< | erb -v > $@

