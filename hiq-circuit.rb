# frozen_string_literal: true

# ==============================================================================
#
# Copyright 2020 <Huawei Technologies Co., Ltd>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ==============================================================================

class HiqCircuit < Formula
  include Language::Python::Virtualenv

  desc "Huawei-HiQ HiQSimulator"
  homepage "https://hiq.huaweicloud.com/en/"
  url "https://pypi.io/packages/source/h/hiq-circuit/hiq-circuit-0.0.2.tar.gz"
  version "0.0.2"
  sha256 "1c0d28f4ff0f51f3314f047e3a0bf874238c519d1c24153afa45f3e2c6256541"
  license "Apache-2.0"
  revision 0

  depends_on "boost-mpi"
  depends_on "cmake" => :build
  depends_on "glog"
  depends_on "huawei/hiq/hiq-projectq"
  depends_on "hwloc"
  depends_on "mpi4py"
  depends_on "python@3.8"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    site_packages = "lib/python#{version}/site-packages"

    virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")

    llvm_bin = Formula["llvm"].opt_bin

    ENV["CC"] = "#{llvm_bin}/clang"
    ENV["CXX"] = "#{llvm_bin}/clang++"

    system libexec/"bin/pip3", "install", "-v", buildpath

    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-hiq-circuit.pth").write pth_contents
  end

  test do
    system "mpirun", "-np", "2", Formula["python@3.8"].opt_bin/"python3", "-c", <<~EOS
      from projectq.ops import H, Measure
      from hiq.projectq.backends import SimulatorMPI
      from hiq.projectq.cengines import GreedyScheduler, HiQMainEngine

      from mpi4py import MPI

      eng = HiQMainEngine(SimulatorMPI(gate_fusion=True, num_local_qubits=4))

      q1 = eng.allocate_qubit()
      H | q1
      Measure | q1
      eng.flush()

      print("Measured: {}".format(int(q1)))
    EOS
  end
end
