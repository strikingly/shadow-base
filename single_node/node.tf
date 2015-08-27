resource "google_compute_instance_template" "shadow" {
    name = "shadow-basic-template"
    description = "basic instance for shadow"
    instance_description = "dockerlize shadowsocks server"
    machine_type = "n1-standard-1"
    can_ip_forward = false
    automatic_restart = true
    tags = ["name", "shadow"]

    # Create a new boot disk from an image
    disk {
        source_image = "packer-shadow"
        auto_delete = true
        boot = true
    }

    network_interface {
        network = "default"
        access_config {}
    }

    service_account {
        scopes = ["userinfo-email", "compute-ro", "storage-ro"]
    }

}

resource "google_compute_http_health_check" "default" {
    name = "shadow-monitor"
    request_path = "/docker/shadow"
    check_interval_sec = 10
    timeout_sec = 10
    port = 80
}

resource "google_compute_target_pool" "default" {
    name = "lb-shadow-basic"
    health_checks = [ "${google_compute_http_health_check.default.name}" ]
}

resource "google_compute_forwarding_rule" "default" {
    name = "shadow-443"
    target = "${google_compute_target_pool.default.self_link}"
    port_range = "80-443"
}

resource "google_compute_instance_group_manager" "shadow" {
    description = "Shadowsocks instance group for strikingly"
    name = "strikingly-shadow"
    instance_template = "${google_compute_instance_template.shadow.self_link}"
    target_pools = ["${google_compute_target_pool.default.self_link}"]
    base_instance_name = "shadow"
    zone = "asia-east1-a"
    target_size = 2
}
