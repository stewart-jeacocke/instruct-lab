# SPDX-License-Identifier: Apache-2.0

#FROM nvcr.io/nvidia/cuda:12.4.1-devel-ubi9
FROM fedora:40
RUN dnf install -y python3.11 python3.11-devel git python3-pip make automake gcc gcc-c++
WORKDIR /instructlab
RUN python3.11 -m ensurepip

ARG GIT_TAG=v0.18.4
RUN CMAKE_ARGS="-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS" python3.11 -m pip install -r https://raw.githubusercontent.com/instructlab/instructlab/${GIT_TAG}/requirements.txt --force-reinstall --no-cache-dir llama-cpp-python
RUN python3.11 -m pip install git+https://github.com/instructlab/instructlab.git@${GIT_TAG}

RUN ilab config init --non-interactive
RUN ilab model download

# get hold of Stewart's example knowledge file
RUN mkdir ~/.local/share/instructlab/taxonomy/knowledge/world_trade_organization
RUN curl -sSL https://raw.githubusercontent.com/stewart-jeacocke/instruct-lab/main/qna.yaml -o ~/.local/share/instructlab/taxonomy/knowledge/world_trade_organization/qna.yaml

CMD ["/bin/bash"]

LABEL com.redhat.component="instructlab"
