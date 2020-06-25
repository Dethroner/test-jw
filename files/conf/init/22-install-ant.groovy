import jenkins.model.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*

def inst = Jenkins.getInstance()
def desc = inst.getDescriptor("hudson.tasks.Ant")
def versions = [
  "ant-1.9": "1.9.14"
]
def installations = [];
for (v in versions) {
  def installer = new Ant.AntInstaller(v.value)
  def installerProps = new InstallSourceProperty([installer])
  def installation = new Ant.AntInstallation(v.key, "", [installerProps])
  installations.push(installation)
}
desc.setInstallations(installations.toArray(new Ant.AntInstallation[0]))
desc.save()  