# terraform-use-core-example
For use with terraform-core

https://github.com/tiddnet/terraform-core is intended to keep certain core aspects of the infrastructure apart from the rest. 
The hope is to prevent accidental damage/rebuilding of the core infrastructure. 
At the same time, these core modules will provide a foundation for other services to rely upon. 
- DNS delegation sets
- public/private subnets 
- vpc creation

Like other modules, the terraform-core exposes data via its outputs. This example provides a single output: 
'data.terraform_remote_state.core_state.aws_route53_delegation_set.main.id', but others can/will be added.

Module state vs Core state

 Core state values should match the values in your terraform-core module.

 module-state-key should differ from core_state_key (so that changes in your module do not impact the core)
 This can be further enforced with s3 bucket permissions and separate buckets.


