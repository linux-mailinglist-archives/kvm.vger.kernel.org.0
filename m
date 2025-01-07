Return-Path: <kvm+bounces-34723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE423A050A3
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:28:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4CB7166796
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F201717C20F;
	Wed,  8 Jan 2025 02:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PbFiYDo3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B381514EE;
	Wed,  8 Jan 2025 02:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303308; cv=none; b=pc/ae/6MC5LEOdwOdP61C8pbn/FhyLAZp0OrWSqQU7zoESQa6SIO+KWLQnsb5GXPSy9LPSuelyMlwuyI40BdahmPN6dqKPWG3ygMllEFiMeBaJD1N0UQXjpl/aHtclg3sHLraj4eQN6y/m35Wd02UA2zSK1QsA+mXZY4gty8qVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303308; c=relaxed/simple;
	bh=Ay7CEjqJqMuReuELrej+UP2nTbpuB1cB4m2GMizgYL8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=VIZK8pn5mG0msXA9ACDCJGDj5lI9lHloxhFkHyOcbmeM4BT7ZT1XWpJ5tizK9ID5nlk3CADuJ+bEX/FSS98ovG4GXzd5OhiObqYPQ+RKS+RMma7kaUuDo6yV1PhpVjT6s+I064g91R0xF+MOPglHOi+meFpTjbPWoYD3Q9pXjXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PbFiYDo3; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736303306; x=1767839306;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ay7CEjqJqMuReuELrej+UP2nTbpuB1cB4m2GMizgYL8=;
  b=PbFiYDo3rsRdlmzNM6pCQCFWW2Op3NB7i0vx5UxZCSwDQmi67k1Pr/s0
   nhBdOuos/5du4HR2BMTSSov4dpf/AlLRVFQqinUta/1Gg5DG0U/gX2Bwy
   1EjPMrsA5iwQzXoV3/I2aq4Maw/an6JqNulJ6ODw4z3NdxDfDC99DMHdm
   qWl5zr85X+xskmu0jnOW1WSpjPAiBVOjYefjLdibn35k7r1QTiMpd3mp7
   dBmnV0qfIHAKmyuup7Ofzn3JYk3jEcmHCz+ANKRmm02MZkDHSy9skYHR5
   QjMNrfxt+CC+VFHN06cyy+RiE8IvFvI9ieROMFHSdsAOyNOzuEkljB2SY
   Q==;
X-CSE-ConnectionGUID: ecSayIVTQ7iKTlfhgiFL/A==
X-CSE-MsgGUID: xbe94biBTkSrQXb53U22Ow==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47010424"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="47010424"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:28:25 -0800
X-CSE-ConnectionGUID: IjX2KD4DRvWn2y2lDgL/lg==
X-CSE-MsgGUID: ns1dDh5TRwO03YmXd3mg/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103793527"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 07 Jan 2025 18:28:20 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	vivek.kasireddy@intel.com,
	dan.j.williams@intel.com,
	aik@amd.com
Cc: yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: [RFC PATCH 00/12] Private MMIO support for private assigned dev
Date: Tue,  7 Jan 2025 22:27:07 +0800
Message-Id: <20250107142719.179636-1-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is based on an earlier kvm-coco-queue version (v6.12-rc2)
which includes all basic TDX patches.

The series is to start the early stage discussion of the private MMIO
handling for Coco-VM, which is part of the Private Device
Assignment (aka TEE-IO, TIO) enabling. There are already some
disscusion about the context of TIO:

https://lore.kernel.org/linux-coco/173343739517.1074769.13134786548545925484.stgit@dwillia2-xfh.jf.intel.com/
https://lore.kernel.org/all/20240823132137.336874-1-aik@amd.com/

Private MMIOs are resources owned by Private assigned devices. Like
private memory, they are also not intended to be accessed by host, only
accessible by Coco-VM via some secondary MMUs (e.g. Secure EPT). This
series is for KVM to map these MMIO resources without firstly mapping
into the host. For this purpose, This series uses the FD based MMIO
resources for secure mapping, and the dma-buf is chosen as the FD based
backend, just like guest_memfd for private memory. Patch 6 in this
series has more detailed description.


Patch 1 changes dma-buf core, expose a new kAPI for importers to get
dma-buf's PFN without DMA mapping. KVM could use this kAPI to build
GPA -> HPA mapping in KVM MMU.

Patch 2-4 are from Jason & Vivek, allow vfio-pci to export MMIO
resources as dma-buf. The original series are for native P2P DMA and
focus on p2p DMA mapping opens. I removed these p2p DMA mapping code
just to focus the early stage discussion of private MMIO. The original
series:

https://lore.kernel.org/all/0-v2-472615b3877e+28f7-vfio_dma_buf_jgg@nvidia.com/
https://lore.kernel.org/kvm/20240624065552.1572580-1-vivek.kasireddy@intel.com/

Patch 5 is the implementation of get_pfn() callback for vfio dma-buf
exporter.

Patch 6-7 is about KVM supports the private MMIO memory slot backed by
vfio dma-buf.

Patch 8-10 is about how KVM verifies the user provided dma-buf fd
eligible for private MMIO slot.

Patch 11-12 is the example of how KVM TDX setup the Secure EPT for
private MMIO.


TODOs:

- Follow up the evolving of original VFIO dma-buf series.
- Follow up the evolving of basic TDX patches.


Vivek Kasireddy (3):
  vfio: Export vfio device get and put registration helpers
  vfio/pci: Share the core device pointer while invoking feature
    functions
  vfio/pci: Allow MMIO regions to be exported through dma-buf

Xu Yilun (9):
  dma-buf: Introduce dma_buf_get_pfn_unlocked() kAPI
  vfio/pci: Support get_pfn() callback for dma-buf
  KVM: Support vfio_dmabuf backed MMIO region
  KVM: x86/mmu: Handle page fault for vfio_dmabuf backed MMIO
  vfio/pci: Create host unaccessible dma-buf for private device
  vfio/pci: Export vfio dma-buf specific info for importers
  KVM: vfio_dmabuf: Fetch VFIO specific dma-buf data for sanity check
  KVM: x86/mmu: Export kvm_is_mmio_pfn()
  KVM: TDX: Implement TDX specific private MMIO map/unmap for SEPT

 Documentation/virt/kvm/api.rst     |   7 +
 arch/x86/include/asm/tdx.h         |   3 +
 arch/x86/kvm/mmu.h                 |   1 +
 arch/x86/kvm/mmu/mmu.c             |  25 ++-
 arch/x86/kvm/mmu/spte.c            |   3 +-
 arch/x86/kvm/vmx/tdx.c             |  57 +++++-
 arch/x86/virt/vmx/tdx/tdx.c        |  52 ++++++
 arch/x86/virt/vmx/tdx/tdx.h        |   3 +
 drivers/dma-buf/dma-buf.c          |  90 ++++++++--
 drivers/vfio/device_cdev.c         |   9 +-
 drivers/vfio/pci/Makefile          |   1 +
 drivers/vfio/pci/dma_buf.c         | 273 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_config.c |  22 ++-
 drivers/vfio/pci/vfio_pci_core.c   |  64 +++++--
 drivers/vfio/pci/vfio_pci_priv.h   |  27 +++
 drivers/vfio/pci/vfio_pci_rdwr.c   |   3 +
 drivers/vfio/vfio_main.c           |   2 +
 include/linux/dma-buf.h            |  13 ++
 include/linux/kvm_host.h           |  25 ++-
 include/linux/vfio.h               |  22 +++
 include/linux/vfio_pci_core.h      |   1 +
 include/uapi/linux/kvm.h           |   1 +
 include/uapi/linux/vfio.h          |  34 +++-
 virt/kvm/Kconfig                   |   6 +
 virt/kvm/Makefile.kvm              |   1 +
 virt/kvm/kvm_main.c                |  32 +++-
 virt/kvm/kvm_mm.h                  |  19 ++
 virt/kvm/vfio_dmabuf.c             | 151 ++++++++++++++++
 28 files changed, 896 insertions(+), 51 deletions(-)
 create mode 100644 drivers/vfio/pci/dma_buf.c
 create mode 100644 virt/kvm/vfio_dmabuf.c

-- 
2.25.1


