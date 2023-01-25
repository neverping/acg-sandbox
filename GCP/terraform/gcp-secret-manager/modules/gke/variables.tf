variable "name" {
  type        = string
  description = "The cluster name."
}

variable "project_id" {
  type        = string
  description = "The project ID."
}

variable "location" {
  type        = string
  description = "The cluster location, such as 'us-central1'."
}

variable "node_count" {
  type        = number
  description = "How many nodes for the cluster"
  default     = 2
}

variable "k8s_version" {
  type        = string
  description = "The Kubernetes version to be used."
}

variable "release_channel" {
  type        = string
  description = "The Kubernetes release channel. Be careful to not set a 'k8s_version' that is not available on the chosen channel."
}

variable "service_account" {
  type        = string
  description = "The Service Account to be used on the K8s cluster."
}
