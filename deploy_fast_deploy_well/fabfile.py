from fabric.api import *

env.hosts = ['158.69.84.192']
env.user = "admin"

def deploy():
	put ("home/home.css", "/usr/share/nginx/html/")
	put ("home/index.html", "/usr/share/nginx/html/")
	put ("home/projects.html", "/usr/share/nginx/html/")
	put ("home/resume.html", "/usr/share/nginx/html/")

def deploy_maintenance():
	put ("home/maintenance.html", "/usr/share/nginx/html/maintenance_off.html")

def maintenance_on():
	run ("mv /usr/share/nginx/html/index.html /usr/share/nginx/html/index_maintenance.html")
	run ("mv /usr/share/nginx/html/maintenance_off.html /usr/share/nginx/html/maintenance.html")
	sudo ("service nginx reload")

def maintenance_off():
	run ("mv /usr/share/nginx/html/maintenance.html /usr/share/nginx/html/maintenance_off.html")
	run ("mv /usr/share/nginx/html/index_maintenance.html /usr/share/nginx/html/index.html")
	sudo ("service nginx reload")
