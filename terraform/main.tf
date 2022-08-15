terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    k8s = {
      version = "0.8.0"
      source  = "banzaicloud/k8s"
    }
  }
  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "k8s" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "minikube"
}

resource "kubernetes_namespace" "goserver-namespace" {
  metadata {
    name = "gowebserver"

    labels = {
      name = "gowebserver"
    }
  }
}


data "template_file" "goserver-deployment" {
  template = "${file("../kubernetes/app.yaml")}"
}

resource "k8s_manifest" "goserver-deployment" {
  content   = "${data.template_file.goserver-deployment.rendered}"
  namespace = "gowebserver"
}

resource "kubernetes_manifest" "goserver-service" {
  manifest = {
    "apiVersion" = "v1"
    "kind"       = "Service"
    "metadata" = {
      "name"      = "gowebserver-service"
      "namespace" = "gowebserver"
    }
    "spec" = {
      "ports" = [
        {
          "port"       = 8080
          "protocol"   = "TCP"
          "targetPort" = 8080
        },
      ]
      "selector" = {
        "app" = "gowebserver"
      },
      "type" = "LoadBalancer"
    }
  }

}
