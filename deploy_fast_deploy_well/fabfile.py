from fabric.api import *

env.hosts = ['158.69.84.192']
env.user = "admin"

def deploy():
	put ("home/home.css", "/usr/share/nginx/html/")
	put ("home/index.html", "/usr/share/nginx/html/")
	put ("home/projects.html", "/usr/share/nginx/html/")
	put ("home/resume.html", "/usr/share/nginx/html/")

def hostname():
	run("hostname")
