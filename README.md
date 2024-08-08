# Terraform Training Repository

## Description
This repository contains training materials and examples for learning Terraform, an open-source infrastructure as code software tool.

## Prerequisites
- [Terraform](https://www.terraform.io/downloads.html) installed on your local machine.
- Basic understanding of infrastructure as code concepts.

## Installation

### Step 1: Install Terraform
1. **Download Terraform:**
    - Visit the [Terraform downloads page](https://www.terraform.io/downloads.html).
    - Select the appropriate package for your operating system.

2. **Install Terraform:**
    - **MacOS:**
        ```sh
        brew tap hashicorp/tap
        brew install hashicorp/tap/terraform
        ```

    - **Windows:**
        - Download the Windows zip archive from the Terraform downloads page.
        - Extract the zip archive to a directory of your choice.
        - Add the directory to your system's PATH environment variable.

    - **Linux:**
        ```sh
        sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
        sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
        sudo apt-get update && sudo apt-get install terraform
        ```

3. **Verify Installation:**
    ```sh
    terraform -v
    ```

## Usage

### Step 2: Clone the Repository
```sh
git clone https://github.com/yourusername/terraform-training-repo.git
cd terraform-training-repo
```

### Step 3: Login to Azure
You need to login to Azure with AzCLI and select your desired subscription:

```sh
az login
az context set --subscription "whateveryouwant"
```

### Step 4: Initialize Terraform
Navigate to the directory containing the Terraform configuration files and run:

```sh
terraform init
```

### Step 5: Plan and Apply Configuration
Plan the infrastructure changes:
```sh
terraform plan
```

Apply the planned changes:
```sh
terraform apply
```


### Step 6: Destroy Infrastructure
To clean up and destroy the infrastructure created by Terraform, run:
```sh
terraform destroy
```

## Contributing
N/A

## License
This project is intended for internal use.

## Contact
Bernhard Flür - bernhard.fluer@outlook.com
