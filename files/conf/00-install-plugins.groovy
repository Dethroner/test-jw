import jenkins.model.*
import hudson.plugins.sshslaves.*;
import hudson.model.Node.Mode
import hudson.slaves.*
import jenkins.model.Jenkins

def deployPlugin(plugin) {
  if (! plugin.isEnabled() ) {
    plugin.enable()
  }
  plugin.getDependencies().each { 
    deployPlugin(pm.getPlugin(it.shortName)) 
  }
}

def needRestart = false;

pm = Jenkins.instance.pluginManager
pm.doCheckUpdatesServer()

[   'ant',
    'antisamy-markup-formatter',
    'build-timeout',
    'command-launcher',
    'email-ext',
    'github-branch-source',
    'jaxb',
    'jdk-tool',
    'ldap',
    'matrix-auth',
    'pam-auth',
    'pipeline-github-lib',
    'pipeline-stage-view',
    'ssh-slaves',
    'timestamper',
    'workflow-aggregator',
    'ws-cleanup',
//
    'active-directory',
    'authorize-project',
    'conditional-buildstep',
    'discard-old-build',
    'greenballs',
    'gradle',
    'hidden-parameter',
    'locale',
//    'mask-passwords',
//    'maven-plugin',
    'multiple-scms',
//    'htmlpublisher',
    'parameterized-trigger',
    'publish-over-ssh',
    'role-strategy',
//    'vsphere-cloud',
].each{ plugin ->
pm = Jenkins.instance.updateCenter.getPlugin(plugin);
println plugin;
println pm.getInstalled()
try {
    if (pm.getInstalled() == null) {
      println ">>>> install plugin "+plugin;
      try {
          deployment = Jenkins.instance.updateCenter.getPlugin(plugin).deploy(true)
          deployment.get()
          needRestart = true;   
      } catch (all) {
          println "Error:"+all;
      }
    }
  
} catch (e) {
  println "${e}"
}
}

pm = Jenkins.instance.pluginManager
pm.doCheckUpdatesServer()
//Jenkins.instance.updateCenter.doUpgrade(null);
plugins = pm.plugins
plugins = Jenkins.instance.updateCenter.getUpdates()

println "update plugins";
plugins.each {
  
  println it.name;
  Jenkins.instance.updateCenter.getPlugin(it.name).getNeededDependencies().each {
    println ">>>> update plugin "+it.name;
    it.deploy(true)
  }
  needRestart = true;
  it.deploy(true);
  
}

println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

println "need reboot "+(Jenkins.instance.updateCenter.isRestartRequiredForCompletion() | needRestart)

if (Jenkins.instance.updateCenter.isRestartRequiredForCompletion() | needRestart) {
    hudson.model.Hudson.instance.doSafeRestart(null)
}
println ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"

