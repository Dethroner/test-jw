import jenkins.model.*
import hudson.security.*

println("--- Allow anonimus access")
def instance = Jenkins.getInstance()
def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
strategy.setAllowAnonymousRead(true)
instance.setAuthorizationStrategy(strategy)
instance.save()