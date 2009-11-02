#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

from urlparse import urlparse

def domainMap(uri):
	"""Map the domain to the appropriate module directory"""
	u = urlparse(uri)
	host = u.netloc

	if host == 'slashdot.org' or host.endswith('.slashdot.org'):
		return "slashdot"

	if host == "reddit.com" or host.endswith('.reddit.com'):
		return "reddit"

	return False
