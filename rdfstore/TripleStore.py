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

class TripleStore(object):
	"""A class for helping open/manage RDFLib stores.
	Has additional methods to remove contexts, manage data, etc."""

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
		"""Return the underlying RDFLib store."""
		return self.store

	def isOpen(self):
		"""Determine if the store is open."""
		return self.isOpen

	def open(self):
		"""Opens the store."""
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

	# ============================= DATA MANAGEMENT ===========================#

	def deleteGraph(self, context):
		"""Removes the graph context from the triplestore."""
		uriContext = context			
		if type(context) == rdflib.Graph.Graph:
			uriContext = context.identifier

		if type(uriContext) != str:
			raise Exception, "deleteGraph must be supplied a graph or URI."
		self.store.remove((None, None, None), uriContext)
		self.store.commit()

	def getGraph(self, context):
		"""Fetches the graph context requested from the triplestore."""
		if type(context) == str:
			context = URIRef(context)

		if type(context) != URIRef:
			raise Exception, "getGraph requires a string or URIRef."

		graph = Graph(self.store, identifier=context)
		return graph.default_context


