# Essential Terraform Commands

## Initialization

### `terraform init`
Initializes a Terraform configuration, preparing the working directory for use.
- Downloads provider plugins.
- Initializes backend settings.

```bash
terraform init
```

## Formatting and Validation

### `terraform fmt`
Formats your Terraform configuration files to the canonical format.
```bash
terraform fmt
```

### `terraform validate`
Validates the configuration files in a directory.
```bash
terraform validate
```

## Planning and Applying

### `terraform plan`
Creates an execution plan, showing what actions will be taken to achieve the desired state.
```bash
terraform plan
```

### `terraform apply`
Applies the changes required to reach the desired state of the configuration.
```bash
terraform apply
```

## Destroying Resources

### `terraform destroy`
Destroys the Terraform-managed infrastructure.
```bash
terraform destroy
```

## State Management

### `terraform state list`
Lists all resources in the Terraform state.
```bash
terraform state list
```

### `terraform state show <resource>`
Shows details about a specific resource in the Terraform state.
```bash
terraform state show <resource>
```

### `terraform state mv <source> <destination>`
Moves a resource from one location to another in the state file.
```bash
terraform state mv <source> <destination>
```

### `terraform state rm <resource>`
Removes a resource from the Terraform state file.
```bash
terraform state rm <resource>
```

## Workspace Management

### `terraform workspace list`
Lists all available Terraform workspaces.
```bash
terraform workspace list
```

### `terraform workspace new <name>`
Creates a new Terraform workspace.
```bash
terraform workspace new <name>
```

### `terraform workspace select <name>`
Switches to the specified Terraform workspace.
```bash
terraform workspace select <name>
```

### `terraform workspace delete <name>`
Deletes the specified Terraform workspace.
```bash
terraform workspace delete <name>
```

## Miscellaneous

### `terraform output`
Displays the output values from the Terraform state file.
```bash
terraform output
```

### `terraform taint <resource>`
Marks a resource for recreation during the next `terraform apply`.
```bash
terraform taint <resource>
```

### `terraform untaint <resource>`
Removes the 'tainted' state from a resource, preventing its recreation.
```bash
terraform untaint <resource>
```

### `terraform import <address> <id>`
Imports existing infrastructure into your Terraform state.
```bash
terraform import <address> <id>
```

### `terraform graph`
Generates a visual representation of the Terraform configuration or execution plan.
```bash
terraform graph
```