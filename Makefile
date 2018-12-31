#
# makefile for common devops / automation tasks
#

LOCALDIR := $(PWD)/local/
PERLVERSION := 5.28.1
PERLINSTALLTARGETDIR := $(LOCALDIR)perl-$(PERLVERSION)
PERLBUILDURL := https://raw.githubusercontent.com/tokuhirom/Perl-Build/master/perl-build
CPANMURL := http://cpanmin.us/
LOCALPERL := $(PERLINSTALLTARGETDIR)/bin/perl$(PERLVERSION)
LOCALEXEC := $(LOCALDIR)exec
RUNTESTS := --notest 
LOCALCONFIGTARGET := ./rangersccg_web_local.pl
PERLJOBS := 9
help::
	@echo ""
	@echo "==> Setup and Dependency Management"
	@echo "setup		-- Install Perl to $(LOCALDIR) and bootstrap dependencies"
	@echo "installdeps	-- Install 'cpanfile' dependencys to $(LOCALDIR)"
	@echo "installdevelop 	-- Install 'cpanfile --with-develop' dependencys to $(LOCALDIR)"
	@echo "buildperl	-- Install Perl to $(PERLINSTALLTARGETDIR)"
	@echo "locallib		-- Bootstrap a local-lib to $(LOCALDIR)"
	@echo "buildexec	-- Create $(LOCALDIR)/exec script"
	@echo "db_sandbox	-- create a local db"
	@echo ""
	@echo "==> Server Control"
	@echo "server		-- Start the application in the foreground process"
	@echo ""

buildperl::
	@echo "Installing Perl to $(LOCALDIR)"
	curl $(PERLBUILDURL) | perl - --jobs $(PERLJOBS) $(RUNTESTS) --noman $(PERLVERSION) $(PERLINSTALLTARGETDIR)

locallib::
	@echo "Bootstrapping local::lib to $(LOCALDIR)"
	curl -L $(CPANMURL) | $(LOCALPERL) - -l $(LOCALDIR) --verbose local::lib
	eval $$($(LOCALPERL) -I$(LOCALDIR)lib/perl5 -Mlocal::lib=--deactivate-all); \
	 PERL_USE_UNSAFE_INC=1 curl -L $(CPANMURL) | $(LOCALPERL) - -L $(LOCALDIR) $(RUNTESTS) --reinstall \
	  local::lib \
	  App::cpanminus \
	  App::local::lib::helper 

buildexec::
	@echo "Creating exec program to $(LOCALEXEC)"
	@echo '#!/usr/bin/env bash' > $(LOCALEXEC)
	@echo 'eval $$($(LOCALPERL) -I$(LOCALDIR)lib/perl5 -Mlocal::lib=--deactivate-all)' >> $(LOCALEXEC)
	@echo 'source $(LOCALDIR)bin/localenv-bashrc' >> $(LOCALEXEC)
	@echo 'PATH=$(LOCALDIR)bin:$(PERLINSTALLTARGETDIR)/bin:$$PATH' >> $(LOCALEXEC)
	@echo 'exec  "$$@"' >> $(LOCALEXEC)
	@chmod 755 $(LOCALEXEC)

generatelocalconfig::
	@echo "Creating config_local"
	@echo 'my $$config = +{' > $(LOCALCONFIGTARGET)
	@echo '  "Model::Schema" => {' >> $(LOCALCONFIGTARGET)
	@echo '    connect_info => [' >> $(LOCALCONFIGTARGET)
	@echo '      "dbi:Pg:dbname=$(DBNAME);host=$(DBHOST);port=5432",' >> $(LOCALCONFIGTARGET)
	@echo '      "$(DBUSER)", "",' >> $(LOCALCONFIGTARGET)
	@echo '      { pg_enable_utf8 => 1 },' >> $(LOCALCONFIGTARGET)
	@echo '      { on_connect_do => [ "SET search_path TO aaa, public" ] }' >> $(LOCALCONFIGTARGET)
	@echo '    ],' >> $(LOCALCONFIGTARGET)
	@echo '  },' >> $(LOCALCONFIGTARGET)
	@echo '};' >> $(LOCALCONFIGTARGET)

installdeps::
	@echo "Installing application dependencies"
	$(LOCALEXEC) cpanm -v $(RUNTESTS) --installdeps .

installdevelop::
	@echo "Installing application dependencies (with development libraries)"
	$(LOCALEXEC) cpanm -v $(RUNTESTS) --with-develop --installdeps .

setup:: buildperl locallib buildexec installdevelop

server::
	$(LOCALEXEC) perl -Ilib lib/TodoMVC/Web/Server.pm --server Gazelle 
