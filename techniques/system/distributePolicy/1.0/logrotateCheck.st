#####################################################################################
# Copyright 2011-2014 Normation SAS
#####################################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, Version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#####################################################################################

bundle agent root_logrotate_check
{

  files:

    (debian_5|debian_6).!ubuntu::
      "/etc/logrotate.d/rudder"
        copy_from => copy_digest("${sys.workdir}/inputs/distributePolicy/logrotate.conf/rudder.old-debian"),
        classes => kept_if_else("rudder_logrotate_conf_ok", "rudder_logrotate_conf_copied", "cannot_copy_rudder_logrotate_conf"),
        comment => "Copying the logrotate configuration for Debian-like system (except Ubuntu)";

    debian.!(debian_5|debian_6).!ubuntu::
      "/etc/logrotate.d/rudder"
        copy_from => copy_digest("${sys.workdir}/inputs/distributePolicy/logrotate.conf/rudder.debian"),
        classes => kept_if_else("rudder_logrotate_conf_ok", "rudder_logrotate_conf_copied", "cannot_copy_rudder_logrotate_conf"),
        comment => "Copying the logrotate configuration for Debian-like system (except Ubuntu)";

    ubuntu::
      "/etc/logrotate.d/rudder"
        copy_from => copy_digest("${sys.workdir}/inputs/distributePolicy/logrotate.conf/rudder.ubuntu"),
        classes => kept_if_else("rudder_logrotate_conf_ok", "rudder_logrotate_conf_copied", "cannot_copy_rudder_logrotate_conf"),
        comment => "Copying the logrotate configuration for Ubuntu system";

    redhat::
      "/etc/logrotate.d/rudder"
        copy_from => copy_digest("${sys.workdir}/inputs/distributePolicy/logrotate.conf/rudder.rhel"),
        classes => kept_if_else("rudder_logrotate_conf_ok", "rudder_logrotate_conf_copied", "cannot_copy_rudder_logrotate_conf"),
        comment => "Copying the logrotate configuration for not Debian-like system";

    !debian.!redhat::
      "/etc/logrotate.d/rudder"
        copy_from => copy_digest("${sys.workdir}/inputs/distributePolicy/logrotate.conf/rudder.suse"),
        classes => kept_if_else("rudder_logrotate_conf_ok", "rudder_logrotate_conf_copied", "cannot_copy_rudder_logrotate_conf"),
        comment => "Copying the logrotate configuration for not Debian-like system";

  reports:

    cfengine::

      "@@DistributePolicy@@result_success@@&TRACKINGKEY&@@Check logrotate configuration@@None@@${g.execRun}##${g.uuid}@#The logrotate configuration is correct"
        ifvarclass => "rudder_logrotate_conf_ok.!rudder_logrotate_conf_copied.!cannot_copy_rudder_logrotate_conf";

      "@@DistributePolicy@@result_repaired@@&TRACKINGKEY&@@Check logrotate configuration@@None@@${g.execRun}##${g.uuid}@#The logrotate configuration has been updated"
        ifvarclass => "rudder_logrotate_conf_copied.!cannot_copy_rudder_logrotate_conf";

      "@@DistributePolicy@@result_error@@&TRACKINGKEY&@@Check logrotate configuration@@None@@${g.execRun}##${g.uuid}@#The logrotate configuration could not be updated"
        ifvarclass => "cannot_copy_rudder_logrotate_conf";

}