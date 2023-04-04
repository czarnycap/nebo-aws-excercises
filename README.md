this repo documents progress with implementing NEBO tasks for personal development

### create PEM key to connect to EC2

```
terraform plan
terraform apply
terraform output #as test only
terraform show -json|jq '.values.outputs.key_private.value'

```

### provision VPCs
```
export $PROVISION_VPC_DIR = ...
export $PROVISION_VM_DIR = ....
```

```
cd "$(PROVISION_VPC_DIR)"
terraform plan
terraform apply
terraform output > variable.append
```

### provision VMs
```
cat $PROVISION_VPC_DIR/variable.append >> $PROVISION_VM_DIR/variables.tfvars
terraform plan -var-file="variables.tfvars
terraform apply -var-file="variables.tfvars"
terraform output > variables.append
```

### hints
enable logs
'set TF_LOG=DEBUG'

