# Experimenting with provisioning AWS resources, and deploying containers manually
This folder contains scripts for building Docker images for nodes, and for creating, provisioning and deploying them in AWS.  It's minimal and intended to be semi-automated rather than a one-button "turn on the cloud" experience.

For this example, let's say we want three Rails nodes, and we want them to connect to a primary Postgres database, with two slaves for failover.



# Caveats
There's little benefit for using containers over running on the instances directly.  Containers here are used mostly just a way to minimize the setup for development and production environments, and there's nothing packing multiple containers into an instance or doing any resource isolation.

The approach of using bash scripts to provision instances and create DNS records has the drawbacks of programming shell scripts and also of difficulty with sharing configuration information.  An example of this is sharing the Postgres IP addresses with Rails instances; currently this is entirely manual.  Configuration management and service discovery are not things that are supported at all here; using something like Chef might be a better solution, or a cluster management system like Kubernetes that can take advantage of the containerized services and better support discovery.

I'm only experimenting and learning about AWS here, and so it's possible there are suggestions here that are not great security practices, particularly for large-scale public deployments.  You should probably read all of these articles before proceeding:

  - http://docs.aws.amazon.com/general/latest/gr/aws-access-keys-best-practices.html
  - http://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html
  - http://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_SecurityGroups.html



# config.sh
This defines configuration variables.  You should perform the setup manually to set this up in AWS (or write a new script to do so), and then set these configuration values here.  Other scripts source this script for the environment variables it defines, and so this needs to be set up correctly for any scripts to work.

The security group names should be fairly self-descriptive.  You should set these up manually in the AWS UI (or write a new script).



# Create the instances
#### Rails instances
First, let's create the Rails nodes.  This will also tag them with names, and create DNS A records for them.  Our configuration here assumes it's using the domain `yourdomainname.com`.  If you're curious about the particular configuration of these nodes (eg., what instance type and AMI image, just check out the script).

```
$ time scripts/rails_create.sh rails2001
Creating Rails instance rails2001...
Created i-2156cfe5...
Waiting for instance to be 'pending'...
done.
Creating rails2001 name tag...
Waiting for instance to be 'running'...
.......done.
Adding DNS entry for rails2001.yourdomainname.com...
Looking up IP address for i-2156cfe5...
IP address is: 52.33.84.44
Creating temporary file for DNS configuration: /var/folders/7b/603kvhbd7bs0c9pc3wvx93s40000gn/T/tmp.ND3FfBSe...
Creating an A record for rails2001.yourdomainname.com to point to 52.33.84.44...
Submitted at 2015-11-12T15:48:42.033Z.
Done creating DNS record.
rails2001.yourdomainname.com
Done creating Rails instance.
i-2156cfe5

real  0m40.003s
user  0m5.257s
sys 0m0.980s
```

After that, we can create two more in the same way:
```
$ scripts/rails_create.sh rails2002
...

$ scripts/rails_create.sh rails2003
...
```

#### Postgres instances
Next we'll do the same for the three Postgres instances.

These instances have the same kind of creation script, but it also creates a separate EBS volume for mounting the database's data.  This means the data is stored separately from the EC2 instance running the process, so even if you (or Amazon) terminates the instance, you can start another instance that can mount the same data.  So the `postgres_create.sh` script will create an instance, create an EBS volume, and attach the volume and mount it at `/mnt/ebs-a` where the Postgres deploy scripts expect it to be.

So the output will have a few more steps:
```
$ time scripts/postgres_create.sh postgres2001
Creating Postgres instance postgres2001...
Created instance i-001188c4...
Waiting for instance to be 'pending'...
done.
Creating postgres2001 name tag...
Waiting for instance to be 'running'...
.........done.
Adding DNS entry for postgres2001.yourdomainname...
Looking up IP address for i-001188c4...
IP address is: 52.32.208.24
Creating temporary file for DNS configuration: /var/folders/7b/603kvhbd7bs0c9pc3wvx93s40000gn/T/tmp.oV5RjbDW...
Creating an A record for postgres2001.yourdomainname to point to 52.32.208.24...
Submitted at 2015-11-12T17:27:23.118Z.
Done creating DNS record.
postgres2001.yourdomainname
Creating a new EBS volume for data...
Created volume vol-6bcfc19f.
Creating postgres2001-volume name tag for volume...
Waiting for volume to be 'available'...
.done.
Attaching EBS volume vol-6bcfc19f to instance i-001188c4...
Waiting for volume to be 'in-use'...
done.
Done creating Postgres instance.
i-001188c4

real  0m32.563s
user  0m8.410s
sys 0m1.539s
```

Afterward, you can create the other two Postgres instances:
```
$ scripts/postgres_create.sh postgres2002
$ scripts/postgres_create.sh postgres2003
...

```


## Provision the instances
Awesome, so we created the nodes.  Now let's provision them so they have the proper users for accessing them through SSH, and have the packages installed that they'll need to run production containers.  This will be semi-automated, with scripts doing some work and walking you through the manual steps around enabling SSH access for users.


#### Set up user accounts
To setup user accounts for SSH access, we need to know which accounts we want to create, and the public SSH keys for those accounts.  We'll walk through doing this for one account, and you can repeat the same process if you have several admins or developers who you want to grant access.  In order to do this process, we need the root EC2 user credentials, and this assumes you have that PEM file locally.

This is semi-automated since there are restrictions on running sudo commands without a TTY.  I'm not sure how other provisioning systems work around this.

Keep in mind this is intended for a small number of admins and developers actively working on the system, so for now there's not any more sophisticated permissioning system.  Granting them ssh access gives them full access.

# TODO(kr) run scripts to provision
# http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html

```
$ scripts/base_add_user.sh rails2001 krobinson ~/.ssh/krobinson.pub
Copying public key file /Users/krobinson/.ssh/krobinson.pub for krobinson to rails2001.yourdomainname.com...
krobinson.pub                                                                                              100%  409     0.4KB/s   00:00
Copying remote script...
remote_add_user.sh                                                                                             100%  668     0.7KB/s   00:00
Changing permissions...



Ready!
The permissions on the box don't allow running it remotely as a security precaution.
You'll have to run a few commands yourself.

Run this command on your local shell:
  $ ssh -o StrictHostKeyChecking=no -i /Users/krobinson/.ssh/superuser.pem ec2-user@rails2001.yourdomainname.com

And then run this command on the remote box:
  $ sudo /tmp/remote_add_user.sh krobinson && rm /tmp/remote_add_user.sh && exit

After that that user can ssh into the box with:
  $ ssh rails2001.yourdomainname.com

Go ahead...
```

Following those instructions will add the user, set them up for SSH-key-only access, and add them to the `wheel` group so they can perform `sudo` commands.

Afterward, you can also set up password-less sudo, since these users will have SSH-key-only access and won't have passwords.  This will apply to all users.  You can use a helper script to ssh in:

```
$ scripts/base_superuser_ssh.sh rails2001
```

and then remotely run:

```
sudo visudo
```

and uncomment out the line:

```
## Same thing without a password
%wheel        ALL=(ALL)       NOPASSWD: ALL
```

This will let any user in `wheel` run commands as sudo, since they have SSH-key-only access and don't have passwords.


#### Provision the instance to be able to run production containers
Instances don't yet have the packages them need to be able to run services in containers.

First, ssh into the instance:
```
$ scripts/base_superuser_ssh.sh rails2001
```

Then install the needed packages and start the Docker daemon:
```
$ sudo yum update -y && sudo yum install -y docker && sudo service docker start
```

See http://docs.aws.amazon.com/AmazonECS/latest/developerguide/docker-basics.html to learn more.


#### Additional provisioning for Postgres instances
The Postgres instances need some additional provisioning, since they'll need to format and mount the EBS volume that was created and attached to the instance when it was created.

This is semi-automated.  You can use the `scripts/postgres_provision.sh` script to do this, `scp` it to the Postgres node, `chmod` it for `u+x` and then run it to format the volume at mount it at `/mnt/ebs-a` like the deploy script expects.

You should only do this on a newly created instance.  It formats the attached EBS volume, which means it erases any data that was stored on it.  If you're bringing up a new node and attaching an existing EBS volume, you should mount the volume manually.



# Building containers for production
You can do this manually with the `scripts/rails_build.sh` script.  The next step would be to move that to a CI step, (eg. one that's triggered when merging code into master).  It builds the production assets, builds the production container image, and then pushes the image to Docker Hub.

You can run this locally or on a separate EC2 instance, but either way will need Docker installed and the `docker login` to have proper credentials.

TODO(kr) move this to the Travis build



# Deploying containers on production instances
If you're trying to deploy the service for the first time, skip to `First deploy!` below.

Deploying containers is curently a semi-automated process, with help from the script in `scripts/rails_deploy.sh`.  This script needs to be copied to the production instance and run manually.  It works by pulling the production container image from Docker Hub and then running it as a daemon.

First, `scp` the deploy script to the production instance, `ssh` in and `chmod` it so it is `u+x`.  Check out the arguments of the deploy script, since it may require some additional information (eg, IP addresses for another service).  Grabbing these arguments is currently a manual step.

Second, in order to communicate with Docker Hub, you'll need to manually run `docker login` on the production instance to authenticate.  This authorization will be cached.

Third, run the script with the right arguments, and it will start pulling down the image to run it.  This will take a little while on the first run, since it's pulling each layer of the container image.  These are immutable and will be cached going forward.

Example, assuming the user is in the `docker` group:

```
scripts/rails_submit_deploy.sh rails2001 <postgres ip>
```

Check that the service is up!

Note that this is a minimal deploy step, and doesn't do anything sophisticated with setting up monitoring, alerting or even using upstart to ensure that the process restarts.

TODO(kr) create deploy user for this, automate more of the authorization and user steps.  Also clarify where these scripts should be broken up into, how and when configuration gets onto the box.



# First deploy!
The sequence matters here, since we need to seed the production database, and we'd like to use Rails to do that.

  1. Deploy the master Postgres instance like normal, grab its IP address.
  2. Use the `scripts/rails_seed.sh` script to run a production container on a Rails instance and seed the database.  This is currently setup to seed with demo data.
    ```
    # locally
    $ scp scripts/rails_seed.sh rails2001.kevinrobinson-play.com:~
    $ ssh rails2001.kevinrobinson-play.com

    # (now remote)
    $ chmod u+x rails_seed.sh
    $ sudo ./rails_seed.sh <Postgres IP address>

  3. Deploy the Rails instances with `scripts/rails_deploy.sh <Postgres IP address>`
  4. Try it!



# Destroying things
### Instances
You can destroy an instance, which will terminate the EC2 instance and delete the DNS record added by the create script with: `scripts/base_destroy_instance.sh`:


#### DNS records
You can delete DNS records with `scripts/base_delete_dns.sh`:

```
$ scripts/base_delete_dns.sh rails2001
Deleting rails2001.yourdomainname...
Looking up instance-id for rails2001...
Instance id is: i-5946df9d.
Looking up IP address for i-5946df9d...
IP address is: 52.34.47.146
Creating temporary file for DNS configuration: /var/folders/7b/603kvhbd7bs0c9pc3wvx93s40000gn/T/tmp.nqMXXOXY...
Deleting A record for rails2001.yourdomainname...
Submitted at 2015-11-12T17:40:13.279Z.
Done deleting DNS record for rails2001.yourdomainname.
```

