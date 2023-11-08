Worklog
*******


The first five minutes
----------------------
I don't like this architecture.
Why would anyone give a bastion host a NFS share?
Why give someone shell access?
Rather than a security choke-point this seems like a
staging area for deployment.
From what I can see, you'd have to manage SSH keys, which
are long-lived credentials that can easily be stolen.

For a situation like this, maybe Session Manager with
a PrivateLink endpoint would be a better solution.
The credentials would then be managed through IAM.
It is also possible to do session recording.

On a medium scale, you could use a stripped-down
bastion host, with session recording turned on.
The end-user would not have shell access on the
bastion host -- it is only a secure proxy to the
final endpoint.
If shell access is required you can limit the
commands the user can run using SELinux and
`fapolicyd <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/assembly_blocking-and-allowing-applications-using-fapolicyd_security-hardening>`_.
Then SSH creds can be issued by an OpenSSH CA.
You would have to operate the CA.

On a much larger scale, there are solutions like
goteleport.com and StrongDM, but those are complex.
It requires a team to deploy and operate.

I'll implement the ticket and share my thoughts
about the architecture in the presentation video.

