from django.db import models

# Create your models here.

class User(models.Model):
	username = models.CharField(max_length=100)
	homepage = models.CharField(max_length=100)
	userid = models.IntegerField()

class Story(models.Model):
	title = models.CharField(max_length=255)
	content = models.TextField()
	#pub_date = models.DateTimeField('date published')

class Post(models.Model):
	#story = models.ForeignKey(Story)
	#parent = models.ForeignKey('self')
	#author = models.ForeignKey(User)
	title = models.CharField(max_length=255)
	content = models.TextField()

