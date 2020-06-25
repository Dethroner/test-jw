import jenkins.model.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*

println("--- Configuring jdk")
def descriptor = new JDK.DescriptorImpl();
def List<JDK> installations = []
javaTools=[
    ['name':'jdk7', 'home':'/jdk7/jdk1.7.0_80'],
    ['name':'jdk8', 'home':'/jdk8/jdk1.8.0_202'],
    ['name':'jdk11', 'home':'/jdk11/jdk-11.0.1']]
javaTools.each { javaTool ->
    println("Setting up tool: ${javaTool.name}")
    def jdk = new JDK(javaTool.name, "/var/lib/jenkins/tools/hudson.model.JDK"+javaTool.home)
	installations.add(jdk)
}
descriptor.setInstallations(installations.toArray(new JDK[installations.size()]))
descriptor.save()

