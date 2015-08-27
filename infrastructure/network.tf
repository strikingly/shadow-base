resource "google_compute_firewall" "shadow-node" {
    name = "shadow-node"
    network = "default"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = ["10000-65535"]
    }

    allow {
        protocol = "udp"
        ports = ["10000-65535"]
    }

    target_tags = ["shadow"]
    source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "shadow-cc" {
    name = "shadow-cc"
    network = "default"

    allow {
        protocol = "icmp"
    }

    allow {
        protocol = "tcp"
        ports = ["80-443"]
    }

    target_tags = ["shadow-cc"]
    source_ranges = ["0.0.0.0/0"]
}
