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
You can set up runtime integrity checking, or keep
the rootfs read only.
`runtime integrity checking <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/assembly_ensuring-system-integrity-with-keylime_security-hardening>`_.
All logs should go to a log server.
If shell access is required you can limit the
commands the user can run using SELinux and
`fapolicyd <https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/security_hardening/assembly_blocking-and-allowing-applications-using-fapolicyd_security-hardening>`_.
Then SSH creds can be issued by an OpenSSH CA.
You would have to operate the CA.

On a larger scale, there are solutions like
goteleport.com and StrongDM, but those are complex.
It requires a team to deploy.

I'll implement the ticket and share my thoughts
about the architecture in the presentation video.

Relevant links:

https://www.oreilly.com/radar/how-netflix-gives-all-its-engineers-ssh-access/

https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager.html

https://goteleport.com/

https://www.bastionzero.com/

https://medium.com/swlh/run-netflix-bless-ssh-certificate-authority-in-aws-lambda-f507a620e42


The next twenty minutes
-----------------------
Researching Session Manager.


The next hour
-------------
I manually set upt the LB, ASG, and a handful of SGs.
Then I noticed that the ASG is terminating the instances and recreating them.
I decided to scrap everything I made manually and start over,
beginning with the EFS fs.
I tried mounting a few different ways for practice: in /etc/fstab using EFS
helper, in fstab as a nfsv4, as a systemd mount unit, as a systemd automount
unit, with autofs.

https://rayagainstthemachine.net/linux%20administration/systemd-automount/

https://access.redhat.com/solutions/1411233

https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/9/html/managing_file_systems/mounting-nfs-shares_managing-file-systems


After a few days
----------------
The NLB was not working because I had the
network mapping set up wrong. The subnets
need to be public-subnet-{1,2}.

I can now ssh into the bastion hosts using
the dns name of the NLB.

But, if I go to a coffee shop, my ip address
changes, and if I try to ssh in, I get this
error:

::

  ∿ ssh  -l ec2-user bastion-host-nlb-6e47771e13521ad7.elb.us
  -east-1.amazonaws.com
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  @    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
  @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!
  Someone could be eavesdropping on you right now (man-in-the-middle attack)!
  It is also possible that a host key has just been changed.
  The fingerprint for the ED25519 key sent by the remote host is
  SHA256:p68si6KNIB3XE5kJ9PI6mRdqLcDR2sb+1b8S0i6MJRE.
  Please contact your system administrator.
  Add correct host key in /var/home/chris/.ssh/known_hosts to get rid of this message.
  Offending ED25519 key in /var/home/chris/.ssh/known_hosts:1
  Host key for bastion-host-nlb-6e47771e13521ad7.elb.us-east-1.amazonaws.com has changed and you have requested strict checking.
  Host key verification failed.
  
  ∿ ssh -o StrictHostKeyChecking=no -l ec2-user bastion-host-
  nlb-6e47771e13521ad7.elb.us-east-1.amazonaws.com
  ec2-user@bastion-host-nlb-6e47771e13521ad7.elb.us-east-1.amazonaws.com: Permission denied (publickey,gssapi-keyex,gssapi-with-mic).
