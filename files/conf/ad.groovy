import jenkins.model.Jenkins

import hudson.plugins.active_directory.ActiveDirectoryDomain
import hudson.plugins.active_directory.ActiveDirectorySecurityRealm
import hudson.plugins.active_directory.GroupLookupStrategy

String _domain = 'test.lan'
String _site = ''
String _bindName = 'CN=admin, CN=Users, DC=test, DC=lan'
String _bindPassword = 'P@ssw0rd'
String _server = '10.50.10.100'
def hudsonActiveDirectoryRealm = new ActiveDirectorySecurityRealm(_domain, _site, _bindName, _bindPassword, _server)
hudsonActiveDirectoryRealm.getDomains().each({
    it.bindName = hudsonActiveDirectoryRealm.bindName
    it.bindPassword = hudsonActiveDirectoryRealm.bindPassword
    it.site = hudsonActiveDirectoryRealm.site
})
def instance = Jenkins.getInstance()
instance.setSecurityRealm(hudsonActiveDirectoryRealm)
instance.save()