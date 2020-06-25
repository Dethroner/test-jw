import jenkins.*
import jenkins.model.*
import hudson.model.*
import java.util.logging.Logger
import org.jenkinsci.main.modules.sshd.*
Logger logger = Logger.getLogger("")

// Disable CLI access over TCP listener (separate port)
def p = AgentProtocol.all()
p.each { x ->
    if (x.name?.contains("CLI")) {
        logger.info("Removing protocol ${x.name}")
        p.remove(x)
    }
}

// Disable CLI access over /cli URL
def removal = { lst ->
    lst.each { x ->
        if (x.getClass().name.contains("CLIAction")) {
            logger.info("Removing extension ${x.getClass().name}")
            lst.remove(x)
        }
    }
}

def j = Jenkins.instance
removal(j.getExtensionList(RootAction.class))
removal(j.actions)

// Disable CLI over Remoting
jenkins.CLI.get().setEnabled(false)

// Allow SSH connections
def sshdExtension = Jenkins.instance.getExtensionList(SSHD.class)[0]
sshdExtension.setPort(22222)
sshdExtension.save()

// Configure Slave-to-Master Access Control
// https://wiki.jenkins-ci.org/display/JENKINS/Slave+To+Master+Access+Control

def rule = Jenkins.instance.getExtensionList(jenkins.security.s2m.MasterKillSwitchConfiguration.class)[0].rule
if(!rule.getMasterKillSwitch()) {
    rule.setMasterKillSwitch(true);
    logger.info('Disabled agent -> master security for cobertura.');
}
else {
    logger.info('Nothing changed.  Agent -> master security already disabled.');
}

// Do not annoy with Slave-to-Master Access Control warning
Jenkins.instance.getExtensionList(jenkins.security.s2m.MasterKillSwitchWarning.class)[0].disable(true);
Jenkins.instance.save()