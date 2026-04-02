### Create a repo in GitLab UI
* reponame - terraform-kindcluster

### Setup SSH connection to GitLab
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/gitlab.com.system76
ssh -T git@gitlab.com
```
```
Welcome to GitLab, @sailinnthu!
```

### Push an existing Folder from your local computer
```
cd /home/sai/pov-kubernetes/terraform-kindcluster
git config user.name "Sai Linn Thu"
git config user.email "sailinnthu@gmail.com"
```
```
git init --initial-branch=main
```
```
git remote add origin git@gitlab.com:sailinnthu/terraform-kindcluster.git
```

### Verify
```
git remote -v
origin  git@gitlab.com:sailinnthu/terraform-kindcluster.git (fetch)
origin  git@gitlab.com:sailinnthu/terraform-kindcluster.git (push)
```

### Add your files
```
git status
git add .
git commit -m "initial commit"
git push --set-upstream origin main
```
### Output
```
Enumerating objects: 42, done.
Counting objects: 100% (42/42), done.
Delta compression using up to 20 threads
Compressing objects: 100% (42/42), done.
Writing objects: 100% (42/42), 4.65 KiB | 951.00 KiB/s, done.
Total 42 (delta 20), reused 0 (delta 0), pack-reused 0
To gitlab.com:sailinnthu/terraform-kindcluster.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

### Understanding Local Branch vs Remote Branch
```
$ git branch -a
* main
  remotes/origin/main
```
* `*main` 
    * You have a local branch called `main`
    * The `*` means this is your currently active branch (the one you're on)

* `remotes/origin/main` 
    * There's a remote branch called "main" on your GitLab repository
    * `remotes/` indicates it's a remote branch (not local)
    * `origin/main` means it's the `main` branch from the `origin` remote

### To confirm if your local `main` is tracking the remote `origin/main`.
```
$ git branch -vv
* main 0c8af0d [origin/main] initial commit
```
```
$ git log
commit 0c8af0db3d864238af25aaca23e0fae1778a539f (HEAD -> main, origin/main)
Author: Sai Linn Thu <sailinnthu@gmail.com>
Date:   Sat Jun 28 22:56:41 2025 +0800

    initial commit
```

### Note
```
fatal: The current branch master has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin master
```
* It means that your local `master` branch doesn't know which remote branch it should push to. Git needs you to tell it where to push.
* Local branch: `master` (what `git init` created by default)
* Remote branch: `main` (what exists on GitLab)
* These are different branch names, so `git` doesn't know they should be connected.

### How to fix: Rename your local branch to match the remote
* Option 1
```
# Rename local branch from "master" to "main"
git branch -m main

# Now push and set upstream
git push --set-upstream origin main
```
* Option 2
```
git init --initial-branch=main
```

### How to use terraform modules
* Create a directory called `sg-kindcluster/main.tf` on your laptop.
```
mkdir sg-kindcluster
```
* `main.tf`
    * The `source` argument in a module block tells Terraform where to find the source code for the desired child module.
```
module "sg-kindcluster" {
  source = "git::https://gitlab.com/sailinnthu/terraform-kindcluster.git//terraform-kindcluster-v4?ref=main"

  # Your module variables go here
  # variable1 = "value1"
  # variable2 = "value2"
}
```
* When you don't define any module variables in your `root module`, Terraform will use the default values specified in the **child module's** `variables.tf` file.
* `git::` - Tells Terraform this is a Git repository source
* `.git` - Added to the repository URL (required for Git sources)
* `//terraform-kindcluster-v4` - The double slash indicates the subdirectory path within the repository.
* `?ref=main` - Specifies the branch (you can also use tags or commit hashes)

### Run `terraform init`
```
$ terraform init
Initializing the backend...
Initializing modules...
Downloading git::https://gitlab.com/sailinnthu/terraform-kindcluster.git?ref=main for sg-kindcluster...
- sg-kindcluster in .terraform/modules/sg-kindcluster/terraform-kindcluster-v4
Initializing provider plugins...
- Finding tehcyx/kind versions matching "0.9.0"...
- Installing tehcyx/kind v0.9.0...
- Installed tehcyx/kind v0.9.0 (self-signed, key ID F471C773A530ED1B)
Partner and community providers are signed by their developers.
If you'd like to know more about provider signing, you can read about it here:
https://developer.hashicorp.com/terraform/cli/plugins/signing
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
```

### Create a cluster
```
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve
```
```
$ t apply -auto-approve

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # module.sg-kindcluster.kind_cluster.default will be created
  + resource "kind_cluster" "default" {
      + client_certificate     = (known after apply)
      + client_key             = (known after apply)
      + cluster_ca_certificate = (known after apply)
      + completed              = (known after apply)
      + endpoint               = (known after apply)
      + id                     = (known after apply)
      + kubeconfig             = (known after apply)
      + kubeconfig_path        = (known after apply)
      + name                   = "sg-cluster"
      + node_image             = "kindest/node:v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f"
      + wait_for_ready         = false

      + kind_config {
          + api_version = "kind.x-k8s.io/v1alpha4"
          + kind        = "Cluster"

          + networking {
              + pod_subnet     = "10.253.0.0/16"
              + service_subnet = "10.133.0.0/16"
            }

          + node {
              + role = "control-plane"
            }
          + node {
              + role = "worker"
            }
          + node {
              + role = "worker"
            }
          + node {
              + role = "worker"
            }
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.
module.sg-kindcluster.kind_cluster.default: Creating...
module.sg-kindcluster.kind_cluster.default: Still creating... [10s elapsed]
module.sg-kindcluster.kind_cluster.default: Still creating... [20s elapsed]
module.sg-kindcluster.kind_cluster.default: Creation complete after 20s [id=sg-cluster-kindest/node:v1.32.2@sha256:f226345927d7e348497136874b6d207e0b32cc52154ad8323129352923a3142f]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
### Verify
```
$ kubectl get nodes -o wide
NAME                       STATUS   ROLES           AGE   VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE                         KERNEL-VERSION            CONTAINER-RUNTIME
sg-cluster-control-plane   Ready    control-plane   68s   v1.32.2   172.18.0.3    <none>        Debian GNU/Linux 12 (bookworm)   6.6.10-76060610-generic   containerd://2.0.2
sg-cluster-worker          Ready    <none>          58s   v1.32.2   172.18.0.2    <none>        Debian GNU/Linux 12 (bookworm)   6.6.10-76060610-generic   containerd://2.0.2
sg-cluster-worker2         Ready    <none>          58s   v1.32.2   172.18.0.4    <none>        Debian GNU/Linux 12 (bookworm)   6.6.10-76060610-generic   containerd://2.0.2
sg-cluster-worker3         Ready    <none>          58s   v1.32.2   172.18.0.5    <none>        Debian GNU/Linux 12 (bookworm)   6.6.10-76060610-generic   containerd://2.0.2
```

### Root Module vs Child Module
* The **root module** is:
    * The directory where you run `terraform init`, `terraform plan`, and `terraform apply`.
* The **child module** is (in our example):
    * The remote GitLab repository: `terraform-kindcluster-v4`
* Example Root Module Structure
```
sg-kindcluster/           ← ROOT MODULE
├── main.tf               ← Contains your module block
├── variables.tf          ← Your root module variables
└── .terraform/
    └── modules/
        └── sg-kindcluster/  ← Downloaded CHILD MODULE
            └── terraform-kindcluster-v0
            └── terraform-kindcluster-v1
            └── terraform-kindcluster-v2
            └── terraform-kindcluster-v3
            └── terraform-kindcluster-v4  ← The CHILD MODULE you're using in this example.
```

### `terraform.tfvars` in Child Modules
* When you don't set any variables in your root module, Terraform will:
    * Use the child module's `variables.tf` default values - if they exist.
    * Completely ignore the child module's `terraform.tfvars` - this file will never be used.
* Why `terraform.tfvars` in child module's is ignored:
    * `terraform.tfvars` only applies to the root module where you run `terraform init, terraform plan, terraform apply` commands.
    * Child modules receive values only through **the module block parameters.**
    * There's no mechanism for child modules to read their own `.tfvars` files.
* Example Child Module Structure
```
terraform-kindcluster-v4/
├── variables.tf          ← Defines variables with defaults
├── terraform.tfvars      ← This gets IGNORED
└── main.tf
```
