FROM jupyter/scipy-notebook:x86_64-ubuntu-22.04

USER root

# dependencies
ENV ARCH x86_64
ENV OSVER ubuntu2204
ENV CUDA_TOOLKIT_VERSION 12-4
ENV CUDA_VERSION 12.4.1
ENV CUDNN_VERSION 9.1.0.70-1

# Install CUDA and cuDNN
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg2 curl ca-certificates && \
    curl -fsSLO https://developer.download.nvidia.com/compute/cuda/repos/${OSVER}/${ARCH}/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    apt-get update && apt-get install -y --no-install-recommends \
    cuda-toolkit-${CUDA_TOOLKIT_VERSION} \
    libcudnn9-cuda-12=${CUDNN_VERSION} \
    libcudnn9-dev-cuda-12=${CUDNN_VERSION} && \
    rm -rf /var/lib/apt/lists/* && \
    rm cuda-keyring_1.1-1_all.deb

# Set environment variables
ENV PATH /usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/cuda/lib64:${LD_LIBRARY_PATH}

# Install PyTorch with pip (https://pytorch.org/get-started/locally/)
RUN pip install --no-cache-dir --extra-index-url=https://pypi.nvidia.com --index-url 'https://download.pytorch.org/whl/cu124' \
    'torch' \
    'torchvision' \
    'torchaudio'  && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"


# USER ${NB_USER}
