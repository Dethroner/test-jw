import jenkins.model.*
import hudson.model.*
import hudson.tasks.*
import hudson.tools.*
import hudson.plugins.gradle.*

println("--- Configuring gradle")
gradleName = "gradle"
gradleVersion = "4.4.1"

def gradleInstallationDescriptor =
Jenkins.getActiveInstance().getDescriptorByType(GradleInstallation.DescriptorImpl.class)
installations = new GradleInstallation(gradleName, null, [new InstallSourceProperty([new GradleInstaller(gradleVersion)])])
gradleInstallationDescriptor.setInstallations(installations)