variable "region" {
  default = "us-east-2"
}

/*

 Module state vs Core state 

 Core state values should match the values in your terraform-core module.

 module-state-key should differ from core_state_key (so that changes in your module do not impact the core)
 This can be further enforced with s3 bucket permissions and separate buckets. 
  


*/

//////////////////////////////////////////////////////////////////
// Configuration module state 
//////////////////////////////////////////////////////////////////
//
variable "module_state_region" {
  default = "us-east-2"
}

variable "module_state_bucket" {
  default = "xxxxxxxxxxxxxxxx-terraform-remote-state-storage-s3"
}

variable "module_state_key" {
  default = "terraform/test-1"
}

//////////////////////////////////////////////////////////////////
// Configuration core_state
//////////////////////////////////////////////////////////////////
//
variable "core_state_region" {
  default = "us-east-2"
}

variable "core_state_bucket" {
  default = "xxxxxxxxxxxxxxxx-terraform-remote-state-storage-s3"
}

variable "core_state_key" {
  default = "terraform/core"
}
