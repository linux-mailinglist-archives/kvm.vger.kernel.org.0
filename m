Return-Path: <kvm+bounces-27296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3FEA97E7B0
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 10:39:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D3241F21CDE
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2024 08:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1E7E1885B9;
	Mon, 23 Sep 2024 08:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i+UEnW4y"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D810719343D
	for <kvm@vger.kernel.org>; Mon, 23 Sep 2024 08:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727080733; cv=none; b=T42sfeDwDVIITQZe0nmvRDO5NoZrXm+A+9sFnleq/j8Juws2JB/WtOjNdvkXnhOntW8NbjaUPOnLNaAi0z/ds8LWNI1H4gYJKPtjxKXDTn0Alz1NXT3AXPVLqGJtU31eHTWD5la59ATEavum7Jb9wbUiudg+YAIjvzh3LBMSv2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727080733; c=relaxed/simple;
	bh=bsB59pEZNE+QwQkNsYP2MVJsRJuDVofZ4F2oc7np78Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCSBbvK8sRYcMly80YIbLTFodTyA8bQTZ/8LUDPSWfd8JSflAv+ZhD8Isn680f0Gt4XV83A8DV4GYy9srzO4jIcFj7LEAR1CSZTgAgP792cY/+6uISF3kqnDinaOMC0AqqDWDHgNjmMstGZDyL0D9isZUgUrrQW8quZvL3uK4+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i+UEnW4y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034B5C4CEC4;
	Mon, 23 Sep 2024 08:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727080733;
	bh=bsB59pEZNE+QwQkNsYP2MVJsRJuDVofZ4F2oc7np78Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i+UEnW4yL/Uko5LyiPqzEJ8CdbPhR1uALRsVJYy4EoxIR6QjTp/losbSnO505ijiH
	 3DiWz/C+Avb7yYSWIB2X1ADD5A6f9x1j87kCEFmpOpYGsClxwOFGbSkNXe2/CkUC3M
	 7fs2RsNCfdm8A81Rx4/GSLX6lK/6DXpWFNe0NE61SaRABtdCTh8xEOPF991SaGB47j
	 WgBoiyFJtG5xjWNb5PsxartfW9urWm1HgR+FxnqGCTDeRkCGO+ltBJV1EnytVExU6g
	 ZZ4bbIBvPU3jjLqlyH6cpJHr3EZRzufeIWrLOTWyBUI6eB4OKJUZ3GfUrUcFFCRk/N
	 x67JXrHLaAd0g==
Date: Mon, 23 Sep 2024 10:38:47 +0200
From: Danilo Krummrich <dakr@kernel.org>
To: Zhi Wang <zhiw@nvidia.com>
Cc: kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, jgg@nvidia.com,
	airlied@gmail.com, daniel@ffwll.ch, acurrid@nvidia.com,
	cjia@nvidia.com, smitra@nvidia.com, ankita@nvidia.com,
	aniketa@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	zhiwang@kernel.org, bskeggs@nvidia.com
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <ZvEpF91AtaZ6vGA5@pollux>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <20240922161121.000060a0.zhiw@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240922161121.000060a0.zhiw@nvidia.com>

On Sun, Sep 22, 2024 at 04:11:21PM +0300, Zhi Wang wrote:
> On Sun, 22 Sep 2024 05:49:22 -0700
> Zhi Wang <zhiw@nvidia.com> wrote:
> 
> +Ben.
> 
> Forget to add you. My bad. 

Please also add the driver maintainers!

I had to fetch the patchset from the KVM list, since they did not hit the
nouveau list (I'm trying to get @nvidia.com addresses whitelisted).

- Danilo

>  
> 
> > 1. Background
> > =============
> > 
> > NVIDIA vGPU[1] software enables powerful GPU performance for workloads
> > ranging from graphics-rich virtual workstations to data science and
> > AI, enabling IT to leverage the management and security benefits of
> > virtualization as well as the performance of NVIDIA GPUs required for
> > modern workloads. Installed on a physical GPU in a cloud or enterprise
> > data center server, NVIDIA vGPU software creates virtual GPUs that can
> > be shared across multiple virtual machines.
> > 
> > The vGPU architecture[2] can be illustrated as follow:
> > 
> >  +--------------------+    +--------------------+
> > +--------------------+ +--------------------+ | Hypervisor         |
> >   | Guest VM           | | Guest VM           | | Guest VM
> > | |                    |    | +----------------+ | |
> > +----------------+ | | +----------------+ | | +----------------+ |
> > | |Applications... | | | |Applications... | | | |Applications... | |
> > | |  NVIDIA        | |    | +----------------+ | | +----------------+
> > | | +----------------+ | | |  Virtual GPU   | |    |
> > +----------------+ | | +----------------+ | | +----------------+ | |
> > |  Manager       | |    | |  Guest Driver  | | | |  Guest Driver  | |
> > | |  Guest Driver  | | | +------^---------+ |    | +----------------+
> > | | +----------------+ | | +----------------+ | |        |
> > |    +---------^----------+ +----------^---------+
> > +----------^---------+ |        |           |              |
> >              |                      | |        |
> > +--------------+-----------------------+----------------------+---------+
> > |        |                          |                       |
> >              |         | |        |                          |
> >                |                      |         |
> > +--------+--------------------------+-----------------------+----------------------+---------+
> > +---------v--------------------------+-----------------------+----------------------+----------+
> > | NVIDIA                  +----------v---------+
> > +-----------v--------+ +-----------v--------+ | | Physical GPU
> >     |   Virtual GPU      | |   Virtual GPU      | |   Virtual GPU
> >  | | |                         +--------------------+
> > +--------------------+ +--------------------+ |
> > +----------------------------------------------------------------------------------------------+
> > 
> > Each NVIDIA vGPU is analogous to a conventional GPU, having a fixed
> > amount of GPU framebuffer, and one or more virtual display outputs or
> > "heads". The vGPU’s framebuffer is allocated out of the physical
> > GPU’s framebuffer at the time the vGPU is created, and the vGPU
> > retains exclusive use of that framebuffer until it is destroyed.
> > 
> > The number of physical GPUs that a board has depends on the board.
> > Each physical GPU can support several different types of virtual GPU
> > (vGPU). vGPU types have a fixed amount of frame buffer, number of
> > supported display heads, and maximum resolutions. They are grouped
> > into different series according to the different classes of workload
> > for which they are optimized. Each series is identified by the last
> > letter of the vGPU type name.
> > 
> > NVIDIA vGPU supports Windows and Linux guest VM operating systems. The
> > supported vGPU types depend on the guest VM OS.
> > 
> > 2. Proposal for upstream
> > ========================
> > 
> > 2.1 Architecture
> > ----------------
> > 
> > Moving to the upstream, the proposed architecture can be illustrated
> > as followings:
> > 
> >                             +--------------------+
> > +--------------------+ +--------------------+ | Linux VM           |
> > | Windows VM         | | Guest VM           | | +----------------+ |
> > | +----------------+ | | +----------------+ | | |Applications... | |
> > | |Applications... | | | |Applications... | | | +----------------+ |
> > | +----------------+ | | +----------------+ | ... |
> > +----------------+ | | +----------------+ | | +----------------+ | |
> > |  Guest Driver  | | | |  Guest Driver  | | | |  Guest Driver  | | |
> > +----------------+ | | +----------------+ | | +----------------+ |
> > +---------^----------+ +----------^---------+ +----------^---------+
> > |                       |                      |
> > +--------------------------------------------------------------------+
> > |+--------------------+ +--------------------+
> > +--------------------+| ||       QEMU         | |       QEMU
> > | |       QEMU         || ||                    | |
> >  | |                    || |+--------------------+
> > +--------------------+ +--------------------+|
> > +--------------------------------------------------------------------+
> > |                       |                      |
> > +-----------------------------------------------------------------------------------------------+
> > |
> > +----------------------------------------------------------------+  |
> > |                           |                                VFIO
> >                        |  | |                           |
> >                                                    |  | |
> > +-----------------------+ | +------------------------+
> > +---------------------------------+|  | | |  Core Driver vGPU     | |
> > |                        |  |                                 ||  | |
> > |       Support        <--->|                       <---->
> >                     ||  | | +-----------------------+ | | NVIDIA vGPU
> > Manager    |  | NVIDIA vGPU VFIO Variant Driver ||  | | |    NVIDIA
> > GPU Core    | | |                        |  |
> >         ||  | | |        Driver         | |
> > +------------------------+  +---------------------------------+|  | |
> > +--------^--------------+
> > +----------------------------------------------------------------+  |
> > |          |                          |                       |
> >                |          |
> > +-----------------------------------------------------------------------------------------------+
> > |                          |                       |
> >     |
> > +----------|--------------------------|-----------------------|----------------------|----------+
> > |          v               +----------v---------+
> > +-----------v--------+ +-----------v--------+ | |  NVIDIA
> >      |       PCI VF       | |       PCI VF       | |       PCI VF
> >   | | |  Physical GPU            |                    | |
> >        | |                    | | |                          |
> > (Virtual GPU)    | |   (Virtual GPU)    | |    (Virtual GPU)   | | |
> >                         +--------------------+ +--------------------+
> > +--------------------+ |
> > +-----------------------------------------------------------------------------------------------+
> > 
> > The supported GPU generations will be Ada which come with the
> > supported GPU architecture. Each vGPU is backed by a PCI virtual
> > function.
> > 
> > The NVIDIA vGPU VFIO module together with VFIO sits on VFs, provides
> > extended management and features, e.g. selecting the vGPU types,
> > support live migration and driver warm update.
> > 
> > Like other devices that VFIO supports, VFIO provides the standard
> > userspace APIs for device lifecycle management and advance feature
> > support.
> > 
> > The NVIDIA vGPU manager provides necessary support to the NVIDIA vGPU
> > VFIO variant driver to create/destroy vGPUs, query available vGPU
> > types, select the vGPU type, etc.
> > 
> > On the other side, NVIDIA vGPU manager talks to the NVIDIA GPU core
> > driver, which provide necessary support to reach the HW functions.
> > 
> > 2.2 Requirements to the NVIDIA GPU core driver
> > ----------------------------------------------
> > 
> > The primary use case of CSP and enterprise is a standalone minimal
> > drivers of vGPU manager and other necessary components.
> > 
> > NVIDIA vGPU manager talks to the NVIDIA GPU core driver, which provide
> > necessary support to:
> > 
> > - Load the GSP firmware, boot the GSP, provide commnication channel.
> > - Manage the shared/partitioned HW resources. E.g. reserving FB
> > memory, channels for the vGPU mananger to create vGPUs.
> > - Exception handling. E.g. delivering the GSP events to vGPU manager.
> > - Host event dispatch. E.g. suspend/resume.
> > - Enumerations of HW configuration.
> > 
> > The NVIDIA GPU core driver, which sits on the PCI device interface of
> > NVIDIA GPU, provides support to both DRM driver and the vGPU manager.
> > 
> > In this RFC, the split nouveau GPU driver[3] is used as an example to
> > demostrate the requirements of vGPU manager to the core driver. The
> > nouveau driver is split into nouveau (the DRM driver) and nvkm (the
> > core driver).
> > 
> > 3 Try the RFC patches
> > -----------------------
> > 
> > The RFC supports to create one VM to test the simple GPU workload.
> > 
> > - Host kernel:
> > https://github.com/zhiwang-nvidia/linux/tree/zhi/vgpu-mgr-rfc
> > - Guest driver package: NVIDIA-Linux-x86_64-535.154.05.run [4]
> > 
> >   Install guest driver:
> >   # export GRID_BUILD=1
> >   # ./NVIDIA-Linux-x86_64-535.154.05.run
> > 
> > - Tested platforms: L40.
> > - Tested guest OS: Ubutnu 24.04 LTS.
> > - Supported experience: Linux rich desktop experience with simple 3D
> >   workload, e.g. glmark2
> > 
> > 4 Demo
> > ------
> > 
> > A demo video can be found at: https://youtu.be/YwgIvvk-V94
> > 
> > [1] https://www.nvidia.com/en-us/data-center/virtual-solutions/
> > [2]
> > https://docs.nvidia.com/vgpu/17.0/grid-vgpu-user-guide/index.html#architecture-grid-vgpu
> > [3]
> > https://lore.kernel.org/dri-devel/20240613170211.88779-1-bskeggs@nvidia.com/T/
> > [4]
> > https://us.download.nvidia.com/XFree86/Linux-x86_64/535.154.05/NVIDIA-Linux-x86_64-535.154.05.run
> > 
> > Zhi Wang (29):
> >   nvkm/vgpu: introduce NVIDIA vGPU support prelude
> >   nvkm/vgpu: attach to nvkm as a nvkm client
> >   nvkm/vgpu: reserve a larger GSP heap when NVIDIA vGPU is enabled
> >   nvkm/vgpu: set the VF partition count when NVIDIA vGPU is enabled
> >   nvkm/vgpu: populate GSP_VF_INFO when NVIDIA vGPU is enabled
> >   nvkm/vgpu: set RMSetSriovMode when NVIDIA vGPU is enabled
> >   nvkm/gsp: add a notify handler for GSP event
> >     GPUACCT_PERFMON_UTIL_SAMPLES
> >   nvkm/vgpu: get the size VMMU segment from GSP firmware
> >   nvkm/vgpu: introduce the reserved channel allocator
> >   nvkm/vgpu: introduce interfaces for NVIDIA vGPU VFIO module
> >   nvkm/vgpu: introduce GSP RM client alloc and free for vGPU
> >   nvkm/vgpu: introduce GSP RM control interface for vGPU
> >   nvkm: move chid.h to nvkm/engine.
> >   nvkm/vgpu: introduce channel allocation for vGPU
> >   nvkm/vgpu: introduce FB memory allocation for vGPU
> >   nvkm/vgpu: introduce BAR1 map routines for vGPUs
> >   nvkm/vgpu: introduce engine bitmap for vGPU
> >   nvkm/vgpu: introduce pci_driver.sriov_configure() in nvkm
> >   vfio/vgpu_mgr: introdcue vGPU lifecycle management prelude
> >   vfio/vgpu_mgr: allocate GSP RM client for NVIDIA vGPU manager
> >   vfio/vgpu_mgr: introduce vGPU type uploading
> >   vfio/vgpu_mgr: allocate vGPU FB memory when creating vGPUs
> >   vfio/vgpu_mgr: allocate vGPU channels when creating vGPUs
> >   vfio/vgpu_mgr: allocate mgmt heap when creating vGPUs
> >   vfio/vgpu_mgr: map mgmt heap when creating a vGPU
> >   vfio/vgpu_mgr: allocate GSP RM client when creating vGPUs
> >   vfio/vgpu_mgr: bootload the new vGPU
> >   vfio/vgpu_mgr: introduce vGPU host RPC channel
> >   vfio/vgpu_mgr: introduce NVIDIA vGPU VFIO variant driver
> > 
> >  .../drm/nouveau/include/nvkm/core/device.h    |   3 +
> >  .../drm/nouveau/include/nvkm/engine/chid.h    |  29 +
> >  .../gpu/drm/nouveau/include/nvkm/subdev/gsp.h |   1 +
> >  .../nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h  |  45 ++
> >  .../nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h    |  12 +
> >  drivers/gpu/drm/nouveau/nvkm/Kbuild           |   1 +
> >  drivers/gpu/drm/nouveau/nvkm/device/pci.c     |  33 +-
> >  .../gpu/drm/nouveau/nvkm/engine/fifo/chid.c   |  49 +-
> >  .../gpu/drm/nouveau/nvkm/engine/fifo/chid.h   |  26 +-
> >  .../gpu/drm/nouveau/nvkm/engine/fifo/r535.c   |   3 +
> >  .../gpu/drm/nouveau/nvkm/subdev/gsp/r535.c    |  14 +-
> >  drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild  |   3 +
> >  drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c  | 302 +++++++++++
> >  .../gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c  | 234 ++++++++
> >  drivers/vfio/pci/Kconfig                      |   2 +
> >  drivers/vfio/pci/Makefile                     |   2 +
> >  drivers/vfio/pci/nvidia-vgpu/Kconfig          |  13 +
> >  drivers/vfio/pci/nvidia-vgpu/Makefile         |   8 +
> >  drivers/vfio/pci/nvidia-vgpu/debug.h          |  18 +
> >  .../nvidia/inc/ctrl/ctrl0000/ctrl0000system.h |  30 +
> >  .../nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h    |  33 ++
> >  .../ctrl/ctrl2080/ctrl2080vgpumgrinternal.h   | 152 ++++++
> >  .../common/sdk/nvidia/inc/ctrl/ctrla081.h     | 109 ++++
> >  .../nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h | 213 ++++++++
> >  .../common/sdk/nvidia/inc/nv_vgpu_types.h     |  51 ++
> >  .../common/sdk/vmioplugin/inc/vmioplugin.h    |  26 +
> >  .../pci/nvidia-vgpu/include/nvrm/nvtypes.h    |  24 +
> >  drivers/vfio/pci/nvidia-vgpu/nvkm.h           |  94 ++++
> >  drivers/vfio/pci/nvidia-vgpu/rpc.c            | 242 +++++++++
> >  drivers/vfio/pci/nvidia-vgpu/vfio.h           |  43 ++
> >  drivers/vfio/pci/nvidia-vgpu/vfio_access.c    | 297 ++++++++++
> >  drivers/vfio/pci/nvidia-vgpu/vfio_main.c      | 511
> > ++++++++++++++++++ drivers/vfio/pci/nvidia-vgpu/vgpu.c           |
> > 352 ++++++++++++ drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c       | 144
> > +++++ drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h       |  89 +++
> >  drivers/vfio/pci/nvidia-vgpu/vgpu_types.c     | 466 ++++++++++++++++
> >  include/drm/nvkm_vgpu_mgr_vfio.h              |  61 +++
> >  37 files changed, 3702 insertions(+), 33 deletions(-)
> >  create mode 100644 drivers/gpu/drm/nouveau/include/nvkm/engine/chid.h
> >  create mode 100644
> > drivers/gpu/drm/nouveau/include/nvkm/vgpu_mgr/vgpu_mgr.h create mode
> > 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/Kbuild create mode
> > 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vfio.c create mode
> > 100644 drivers/gpu/drm/nouveau/nvkm/vgpu_mgr/vgpu_mgr.c create mode
> > 100644 drivers/vfio/pci/nvidia-vgpu/Kconfig create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/Makefile create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/debug.h create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl0000/ctrl0000system.h
> > create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080gpu.h
> > create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrl2080/ctrl2080vgpumgrinternal.h
> > create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/ctrl/ctrla081.h
> > create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/dev_vgpu_gsp.h
> > create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/nvidia/inc/nv_vgpu_types.h
> > create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/common/sdk/vmioplugin/inc/vmioplugin.h
> > create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/include/nvrm/nvtypes.h create mode
> > 100644 drivers/vfio/pci/nvidia-vgpu/nvkm.h create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/rpc.c create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/vfio.h create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/vfio_access.c create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/vfio_main.c create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/vgpu.c create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.c create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/vgpu_mgr.h create mode 100644
> > drivers/vfio/pci/nvidia-vgpu/vgpu_types.c create mode 100644
> > include/drm/nvkm_vgpu_mgr_vfio.h
> > 
> 

