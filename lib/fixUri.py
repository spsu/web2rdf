#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

from urlparse import urlparse

def fixUri(uri):
	"""Fixes any problems with a URI, such as missing protocol, the presence
	of xml/html entities like '&amp;', or non-urlencodedness."""
	
	# Assume http:// protocol as default if missing.
	u = urlparse(uri)
	if not u.scheme or not u.netloc:
		uri = "http://" + uri

	# Got to be a better way of doing this...
	uri = uri.replace("&amp;", "&")
	uri = uri.replace(" ", "%20")

	return uri

