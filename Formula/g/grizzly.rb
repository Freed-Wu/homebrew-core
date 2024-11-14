class Grizzly < Formula
  desc "Command-line tool for managing and automating Grafana dashboards"
  homepage "https://grafana.github.io/grizzly/"
  url "https://github.com/grafana/grizzly/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "bd5ed75eb4d7cf96cf58e58f7f134c9a4e803bf2237a8a8a1b9bc99176fc147d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a20f521bb3ae13405678789d52a07ee6f19354626683e68e1a8f62d8d56a831"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a20f521bb3ae13405678789d52a07ee6f19354626683e68e1a8f62d8d56a831"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1a20f521bb3ae13405678789d52a07ee6f19354626683e68e1a8f62d8d56a831"
    sha256 cellar: :any_skip_relocation, sonoma:        "a94e90480ae8eadaf52343c7b83ee56204cffdc47093701a23e6a70b738a5df7"
    sha256 cellar: :any_skip_relocation, ventura:       "a94e90480ae8eadaf52343c7b83ee56204cffdc47093701a23e6a70b738a5df7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb9ea3eda63a25f7f85872dc2a18c70b3950d958620c715922e2f910f3dd0ff"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/grafana/grizzly/pkg/config.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:, output: bin/"grr"), "./cmd/grr"
  end

  test do
    sample_dashboard = testpath/"dashboard_simple.yaml"
    sample_dashboard.write <<~EOS
      apiVersion: grizzly.grafana.com/v1alpha1
      kind: Dashboard
      metadata:
        folder: sample
        name: prod-overview
      spec:
        schemaVersion: 17
        tags:
          - templated
        timezone: browser
        title: Production Overview
        uid: prod-overview
    EOS

    assert_match "prod-overview", shell_output("#{bin}/grr list #{sample_dashboard}")

    assert_match version.to_s, shell_output("#{bin}/grr --version 2>&1")
  end
end
