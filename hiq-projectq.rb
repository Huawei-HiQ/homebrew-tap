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

class HiqProjectq < Formula
  include Language::Python::Virtualenv

  desc "Huawei-HiQ ProjectQ"
  homepage "https://hiq.huaweicloud.com/en/"
  url "https://pypi.io/packages/source/h/hiq-projectq/hiq-projectq-0.6.4.post2.tar.gz"
  version "0.6.4"
  sha256 "f404e530cea8a1741062626ca7ebe23e9a3bde1198cd0bf602fde0fe2c9359fe"
  license "Apache-2.0"
  revision 2

  depends_on "llvm"
  depends_on "numpy"
  depends_on "pybind11" => :build
  depends_on "python@3.8"
  depends_on "scipy"

  def install
    version = Language::Python.major_minor_version Formula["python@3.8"].opt_bin/"python3"
    site_packages = "lib/python#{version}/site-packages"

    venv = virtualenv_create(libexec, Formula["python@3.8"].opt_bin/"python3")

    llvm_bin = Formula["llvm"].opt_bin

    ENV["CC"] = "#{llvm_bin}/clang"
    ENV["CXX"] = "#{llvm_bin}/clang++"

    venv.pip_install "matplotlib"
    system libexec/"bin/pip3", "install", "-v", buildpath

    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-hiq-projectq.pth").write pth_contents
  end

  test do
    system Formula["python@3.8"].opt_bin/"python3", "-c", <<~EOS
      from projectq import MainEngine
      import projectq.cengines
      from projectq.ops import X, H, Rx
      
      eng = MainEngine()
      qubit = eng.allocate_qubit()
      X | qubit
      H | qubit
      Rx(1.0) | qubit
      eng.flush()
    EOS
  end
end
