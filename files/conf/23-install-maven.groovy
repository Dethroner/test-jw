import jenkins.model.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*

println("--- Configuring Maven")
mavenName = "maven3"
mavenVersion = "3.2.5"
println("Checking Maven installations...")
mavenPlugin = Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]
maven3Install = mavenPlugin.installations.find {
  install -> install.name.equals(mavenName)
}
if(maven3Install == null) {
  println("No Maven install found. Adding...")
  newMavenInstall = new hudson.tasks.Maven.MavenInstallation(mavenName, null,
   [new hudson.tools.InstallSourceProperty([new hudson.tasks.Maven.MavenInstaller(mavenVersion)])]
)

  mavenPlugin.installations += newMavenInstall
  mavenPlugin.save()
}
