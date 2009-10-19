#!/usr/bin/env python2.6
# Copyright 2009 Brandon Thomas Suit
# http://possibilistic.org
# echelon@gmail.com
# This code available under the GPL 3 unless otherwise noted.

import hashlib
import os.path
import time

class CacheMap(object):
	"""
	CacheMap

	Hashes each URI to a distinct cache file that can be saved for a certain 
	amount of time so the host server will not be hammered when I test the 
	XSLT templates.
	"""

	PREFIX = './cache/'
	SUFFIX = '.html'

	def __init__(self, uri):
		"""URIs will map to a cache file to prevent flooding a remote server."""
		self.uri = uri

	def getCacheFilename(self):
		"""Return the filename that the URI should map to."""
		return self.__class__.PREFIX + hashlib.md5(self.uri).hexdigest() + \
			   self.__class__.SUFFIX

	def exists(self):
		"""Check if the cache file exists."""
		return os.path.exists(self.getCacheFilename())
		
	def isExpired(self, minutes = 10):
		"""Check if the cache has expired."""
		mTime = int(os.path.getmtime(self.getCacheFilename()))
		now = int(time.time())
		return bool(now - mTime >= 60 * minutes)


