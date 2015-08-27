provider "google" {
    account_file = "${file("../credentials/gc.json")}"
    project = "strikingly-test"
    region = "asia-east1"
}
