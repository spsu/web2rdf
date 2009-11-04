#!/usr/bin/env python2.6

import os.path
import rdflib
from rdflib.Graph import ConjunctiveGraph as Graph
from rdflib import Namespace
from rdflib import Literal
from rdflib import URIRef

from rdflib import plugin
from rdflib.store import Store, NO_STORE, VALID_STORE
from rdflib.store import SQLite
from rdflib.store import MySQL

class RdfStore(object):
	"""A class for helping open/manage RDFLib stores."""

	def __init__(self, params = None, storeType = None):
		"""Initializes the store interface"""
		self.store = None
		self.type = None
		self.sqliteFile = None # Only if SQlite
		self.configStr = None # Only if MySQL
		self.isOpen = False

		typ = type(params)
		if typ == str or ((typ == list or typ == tuple) and \
			len(params) == 1):
				# Assume SQLite
				self.type = 'sqlite'
		elif not storeType:
			# Assume MySQL (TODO: Support memory, bdb, etc.)
			self.type = 'mysql'
		else:
			self.type = storeType

		if self.type == 'sqlite':
			typ = type(params)
			if typ != str and ((typ == list or typ == tuple) and \
				len(params) != 1):
					raise Exception, "SQLite only takes one argument"
			filename = params[0]
			self.sqliteFile = os.path.abspath(filename)
			base = os.path.basename(self.sqliteFile)
			self.store = rdflib.store.SQLite.SQLite(base)

		elif self.type == 'mysql':
			typ = type(params)
			if (typ != list and typ != tuple) or len(params) < 4: # TODO: len 3 
				raise Exception, \
					"MySQL requires 4 arguments: host, user, pass, and dbname."
			# Password or no? (Messy...)
			params = params[0:4]
			if params[2]:
				params = params[0:4]
				self.configStr = "host=%s,user=%s,password=%s,db=%s" % params
			else:
				params = (params[0], params[1], params[3])
				self.configStr = "host=%s,user=%s,db=%s" % params
			self.store = rdflib.store.MySQL.MySQL()

	def get(self):
		"""Return the store."""
		return self.store

	def isOpen(self):
		"""Determine if open."""
		return self.isOpen

	def open(self):
		"""Opens the database"""
		if self.isOpen:
			return True

		if self.type == 'sqlite':
			path = os.path.dirname(self.sqliteFile)
			try:
				# Try connecting to the database first.
				self.store.open(path, create=False)
			except: 
				try:
					self.store.open(path, create=True)
				except:
					return False

			self.isOpen = True
			return True


		elif self.type == 'mysql':
			try:
				# Try connecting to the database first.
				self.store.open(self.configStr, create=False)
			except:
				try:
					self.store.open(self.configStr, create=True)
				except:
					return False

			self.isOpen = True
			return True

		return False

