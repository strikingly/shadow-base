resource "google_compute_firewall" "shadow-basic" {
    name = "shadow-basic"
    network = "default"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = ["80", "443"]
    }

    target_tags = ["shadow"]
    source_ranges = ["0.0.0.0/0"]
}
