import jenkins.model.*
import org.jenkinsci.plugins.*
import hudson.security.csrf.DefaultCrumbIssuer
import hudson.plugins.locale.PluginImpl

println("--- Configuring URL")
jlc = JenkinsLocationConfiguration.get()
jlc.setUrl("http://10.50.10.10:8080/") 
println("    "+jlc.getUrl())
jlc.save() 

println("--- Configuring global getting")
def instance = Jenkins.getInstance()
instance.setNumExecutors(3)
instance.setCrumbIssuer(new DefaultCrumbIssuer(true))
instance.setNoUsageStatistics(true)
instance.save()

println("--- Configuring locale")
PluginImpl localePlugin = (PluginImpl)instance.getPlugin("locale")
localePlugin.systemLocale = "en_US"
localePlugin.@ignoreAcceptLanguage=true

println("--- Configuring Location")
def location = JenkinsLocationConfiguration.get()
location.setAdminAddress("Ruslan Dethroner <r.d@sam-solutions.com>")
location.save()

println("--- Configuring git global options")
def desc = instance.getDescriptor("hudson.plugins.git.GitSCM")
desc.setGlobalConfigName("jenkins")
desc.setGlobalConfigEmail("jenkins@example.com")
desc.save()

// println("--- Configuring mail server")
// def desc = inst.getDescriptor("hudson.tasks.Mailer")
// desc.setSmtpAuth("[SMTP user]", "[SMTP password]")
// desc.setReplyToAddress("[reply to email address]")
// desc.setSmtpHost("[SMTP host]")
// desc.setUseSsl([true or false to use SLL])
// desc.setSmtpPort("[SMTP port]")
// desc.setCharset("[character set]")
// desc.save()

println("--- Configuring protocols")
Set<String> agentProtocolsList = ['JNLP4-connect', 'Ping']
if(!instance.getAgentProtocols().equals(agentProtocolsList)) {
    instance.setAgentProtocols(agentProtocolsList)
    println "Agent Protocols have changed.  Setting: ${agentProtocolsList}"
    instance.save()
}
else {
    println "    Nothing changed.  Agent Protocols already configured: ${instance.getAgentProtocols()}"
}