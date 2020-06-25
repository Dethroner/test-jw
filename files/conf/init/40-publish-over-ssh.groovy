import jenkins.model.*
import jenkins.plugins.publish_over_ssh.BapSshHostConfiguration
import jenkins.plugins.publish_over_ssh.BapSshCommonConfiguration

def inst = Jenkins.getInstance()
def publish_ssh = inst.getDescriptor('jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin')

println "--- Publish-Over-SSH - Common Configuration"
def common = new BapSshCommonConfiguration(null, null, "", false)
common.setPassphrase("mypassphrase")
publish_ssh.setCommonConfig(common)

println "--- Publish-Over-SSH - Creating global list of Server/Paths"
def hosts = [
/* Example:
name,hostname,username,encryptedPassword,remoteRootDir,port,timeout,overrideKey,keyPath,key,disableExec
['Hostalias','hostname','user','encryptedPassword','remoteRootDir',22,30000,false,'','',true]
*/
    ['node1','10.50.10.20','appuser','','',22,30000,true,'./secrets/appuser','',false]
]

println '--- Publish-Over-SSH-Server configuration'
hosts.each { host->
  def configuration = new BapSshHostConfiguration(host[0],host[1],host[2],host[3],host[4],host[5],host[6],host[7],host[8],host[9],host[10])
  println " - SSH-Host ${host[0]}"
  publish_ssh.removeHostConfiguration(host[1])
  publish_ssh.addHostConfiguration(configuration)
}