#!/usr/bin/ruby -w
# -----------------------------------
# web server directory enumerator
# replaces my defdirs bash script
# which was a weak wrapper for wget
# -----------------------------------
# takes a host name and optionally
# a port number (in that order) as
# paramaters.
# -----------------------------------
# author: rossja <algorythm /at/ gmail /dot/ com
# version: 0.2
# -----------------------------------
# TODO:
# - support skipfish wordlist import
# - handle ARG correctly
# - support https
# - actually use rubydoc for comments
# -----------------------------------
# Example usage/output:
# $ ./defdirs.rb localhost |grep -v 404
# [403]  http://localhost/.htaccess
# [403]  http://localhost/.htpasswd
# [200]  http://localhost/index
# [301]  http://localhost/javascript
# [403]  http://localhost/javascript
# [200]  http://localhost/main
# [200]  http://localhost/server-status
# [301]  http://localhost/store
# [200]  http://localhost/store
#
# -----------------------------------

require 'net/http'

HOST = ARGV[0]
PORT = ARGV[1] || 80

$h = Net::HTTP.new(HOST, PORT)

$hdrs = %Q{
Host: #{HOST}
Accept: *.*
Connection: Keep-Alive
User-Agent: Mozilla/5.0 (compatible; Googlebot/2.1;  +http://www.google.com/bot.html)
}

$dirs = %w{
/access
/account
/accounting
/accounts
/ad
/adclick
/admin
/admin
/_admin
/ADMIN
/administrator
/ads
/adv
/affiliate
/affiliates
/album
/albums
/api
/apis
/app
/apps
/AppsLocalLogin
/AppsLogin
/asset
/assets
/atom
/auth
/authors
/b2b
/back
/backdoor
/backup
/backups
/bak
/banner
/banners
/.bash_history
/.bashrc
/batch
/bb
/bb-hist
/bb-histlog
/bboard
/bbs
/bin
/bkup
/blog
/blogger
/bloggers
/blogs
/broken
/build
/BUILD
/c
/cal
/calendar
/cart
/cart
/carts
/cat
/catalog
/catalogs
/cc
/ccbill
/cf
/cfcache
/cfdocs
/cfg
/cfide
/cfm
/cfusion
/cgi
/cgibin
/cgi-bin
/cgi-bin2
/cgi-home
/cgi-local
/cgi-pub
/cgi-script
/cgi-shl
/cgi-sys
/cgi-web
/cgi-win
/cgiwrap
/cisco
/cisweb
/citrix
/client
/clientaccesspolicy
/clients
/cmd
/cms
/CMS
/cnf
/cnt
/cocoon
/code
/coldfusion
/commerce
/common
/company
/conf
/config
/configs
/contact
/contacts
/content
/control
/controlpanel
/corp
/corporate
/cpanel
/css
/css
/custom_log
/custom-log
/CVS
/.cvsignore
/data
/database
/databases
/db
/DB
/dba
/dbase
/dbman
/debug
/default
/demo
/demos
/dev
/devel
/developer
/developers
/development
/devs
/dir
/directories
/directory
/dirs
/disclaimer
/django
/dll
/docs
/download
/downloads
/drupal
/dummy
/ecommerce
/ejb
/export
/ezshopper
/faq
/faqs
/fcgi-bin
/FCKeditor
/feed
/feedback
/feeds
/file
/files
/_files
/flash
/flv
/folder
/folders
/form
/formmail
/forms
/forum
/forum1
/forum2
/forumdisplay
/forums
/frontend
/func
/funcs
/function
/functions
/fusion
/galleries
/gallery
/game
/games
/garbage
/gitweb
/glimpse
/global
/globals
/group
/groupcp
/groups
/hadoop
/hidden
/hipaa
/.history
/home
/horde
/hosting
/hosts
/hta
/.htaccess
/htbin
/htdoc
/htdocs
/htm
/html
/htpasswd
/.htpasswd
/i
/icon
/icons
/iisadmin
/iisadmpwd
/iissamples
/image
/imagefolio
/images
/images
/img
/imgs
/in
/inbound
/inc
/incl
/include
/_include
/includes
/incoming
/index
/index1
/index_1
/index2
/index_2
/inetpub
/inetsrv
/inf
/internal
/intranet
/isapi
/j
/j2ee
/j2me
/jakarta
/java
/javadoc
/java-plugin
/javascript
/javax
/jboss
/jdbc
/jhtml
/jigsaw
/jj
/jmx-console
/JMXSoapAdapter
/joomla
/journal
/jre
/jrun
/js
/json
/jsp
/jsx
/juniper
/junk
/jvm
/keys
/labs
/large
/layout
/layouts
/ldap
/legacy
/legal
/lenya
/lib
/library
/libs
/license
/LICENSE
/licenses
/login
/logins
/logon
/logs
/mail
/mailman
/main
/manager
/manifest
/MANIFEST.MF
/mem
/member
/members
/membership
/meta
/META-INF
/mirror
/mirrors
/msadc
/msadm
/msql
/mssql
/ms-sql
/myfaces
/myphpnuke
/new
/news
/OA
/OAErrorDetailPage
/OA_HTML
/oa_servlets
/oauth
/obdc
/obsolete
/odbc
/oem
/old
/old
/_old
/oprocmgr-status
/ora
/oracle
/oracle.xml.xsql.XSQLServlet
/oscommerce
/out
/outgoing
/output
/owa
/ows
/ows-bin
/people
/phf
/phorum
/php
/php3
/phpbb
/phpBB
/phpBB2
/phpEventCalendar
/phpmyadmin
/phpMyAdmin
/phpnuke
/phps
/pipermail
/portal
/portals
/portfolio
/postgres
/postgresql
/postnuke
/premium
/preview
/previews
/private
/_private
/prv
/pub
/public
/pubs
/readme
/Readme
/README
/remove
/removed
/rep
/repl
/replica
/replicas
/replicate
/replicated
/replication
/replicator
/_res
/research
/resource
/resources
/rest
/restricted
/robots.txt
/rss
/rwservlet
/script
/script
/scriptlet
/scriptlets
/scripts
/scripts
/sdk
/sec
/secret
/secure
/secured
/security
/server-info
/server-status
/servlet
/servlets
/session
/sessions
/setting
/settings
/setup
/shop
/shop
/shopping
/shops
/shtml
/sites
/SiteScope
/SiteServer
/soap
/soaprouter
/sql
/SQL
/sqlnet
/squirrel
/squirrelmail
/src
/_src
/.ssh
/ssi
/sslvpn
/store
/strut
/struts
/.svn
/swf
/temp
/temp
/TEMP
/tmp
/tomcat
/trunk
/tsweb
/ubb
/uds
/umts
/union
/vault
/viewcvs
/viewforum
/viewonline
/views
/viewsource
/view-source
/viewsvn
/viewtopic
/viewvc
/_vti_bin
/_vti_cnf
/_vti_pvt
/_vti_txt
/way-board
/wbboard
/web
/.web
/webaccess
/webadmin
/webagent
/webalizer
/webapp
/webb
/webbbs
/web-beans
/webboard
/webcalendar
/webcart
/webcasts
/webcgi
/webchat
/web-console
/webdata
/webdav
/WEB-INF
/weblog
/weblogic
/weblogs
/webmail
/webplus
/webshop
/website
/websphere
/webstats
/websvn
/webwork
/wordpress
/wp
/wp-content
/wp-includes
/wp-login
/ws
/ws-client
/ws_ftp
/WS_FTP
/www
/x
/xalan
/xerces
/xhtml
/xml
/xmlrpc
/xsl
/xslt
/xsql
/zboard
/zend
/zip
/zipfiles
/zips
/zope
/2000
/2001
/2002
/2003
/2004
/2005
/2006
/2007
/2008
/2009
/2010
/2011
/2012
}

def dirwalk()
  $dirs.each { |dir|
    res = GetHead(dir)
    #res.each {|key, val| printf "%-14s = %-40.40s\n", key, val } 
    puts "[#{res.code}]  http://#{HOST}#{dir}"
    while res.code == ('301'||'302') do # follow the white rabbit
       follow = GetHead(res['location'])
       puts "[#{follow.code}]  http://#{HOST}#{dir}"
       res = GetHead(res['location']) # without this, infinite loop
    end
  }
end

def GetHead(uri)
  begin
    res = $h.head(uri, nil)
  rescue Exception
    print "An error occurred: ",$!, "\n"
    exit
  end
  return res
end

def FetchDoc(uri)
  begin
    res = $h.get(uri, nil)
  rescue Exception
    print "An error occurred: ",$!, "\n"
    exit
  end
    return res
end

dirwalk
