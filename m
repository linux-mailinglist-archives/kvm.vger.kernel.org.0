Return-Path: <kvm+bounces-38331-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D0610A37CF1
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 09:18:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8AD521885794
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 08:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6813119C553;
	Mon, 17 Feb 2025 08:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ibRKupyI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 656A5155C82
	for <kvm@vger.kernel.org>; Mon, 17 Feb 2025 08:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739780331; cv=none; b=eTEMPCl4mcVt5t2TZPDsIWZC7GBns/E9L5MX7Dh9V20Q2jkLBAnbu8dDwn+imQOzZKjCucctBFPxeoRRtgFt4oKUyMv5Gv2YyyoARbrEHdCzsiAHEyG0KikCg9VP0MVWmfknW4eQLUWr2gBwZ/3TUYnxf/vphksDm/ywKyttO4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739780331; c=relaxed/simple;
	bh=wc6TIz6eCVeVGn8h0Vq5MmD8aIAeFnI7/irUmf2viIM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eDwgIUW5SuXr9m8E/AzAqoTDF4ao4wsZ4MQfkt2OILGCWwwWEDEil+MaGd5MO2yMVkGXC9yka7acwxrc+eqrwVQStwee6LuF6A7cfxwkkjTeucxaaRxTqMpXGFgRzPeWw28I5pyQAkdqiMHboL+tDuh4D0pjxs6TbV2fTsxOp58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ibRKupyI; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739780329; x=1771316329;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wc6TIz6eCVeVGn8h0Vq5MmD8aIAeFnI7/irUmf2viIM=;
  b=ibRKupyIBJkUQ0UHMSilGLEdMt2Zh+6k3H4xmYmmOjHIVuc5aYv9HmT1
   +4GseM1/Y0uy4BMZypd50WfhV9abUBzhSUZV+iWOp4YPOs0JqLEf9oje3
   NbMCSTvNgkWQqjETfvedQWgEVxaIHe7xHujjip+cLblpMrrXvbBSY1Gml
   kZfyQ/Xf90GnuWQhJzjCOc1E2sXTxlOB+fSQUQOsQfzGtMXQloPGDmsCW
   sp8posBjeL3N6NCPDSOVAKGNhvG0cypoF1/YkMX++311P4LSuEpt8uomC
   G/aIag+nPkLu/t64G38iQR1xEwGyJwPmi0ibG1LWDMSOV+3lUbIi7slBo
   Q==;
X-CSE-ConnectionGUID: SXh8BWS7SsaFhU3ZOtU+eA==
X-CSE-MsgGUID: KEdEcLXBRxCZRkE1E2XsZw==
X-IronPort-AV: E=McAfee;i="6700,10204,11347"; a="50668956"
X-IronPort-AV: E=Sophos;i="6.13,292,1732608000"; 
   d="scan'208";a="50668956"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:18:48 -0800
X-CSE-ConnectionGUID: qfXuWP3aT1m9kTZfWoVB6w==
X-CSE-MsgGUID: T5uxHi2zQqiLC1w/6MbbKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="118690152"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2025 00:18:45 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>,
	Li Xiaoyao <xiaoyao.li@intel.com>
Subject: [PATCH v2 0/6] Enable shared device assignment
Date: Mon, 17 Feb 2025 16:18:19 +0800
Message-ID: <20250217081833.21568-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v2 series of the shared device assignment support.

The overview of this series:
- Patch 1-2: preparation patches. One is to export a helper to get
  intersection of a MemoryRegionSection with a given range. The other is
  to change the memory_region_set_ram_discard_manager() to return the
  result.
- Patch 3-4: Introduce a new object to implement RamDiscardManager
  interface and a callback to notify the shared/private state change.
- Patch 5: Store the new object including guest_memfd information in
  RAMBlock. Register the RamDiscardManager instance to the target
  RAMBlock's MemoryRegion so that the object can notify the page
  conversion events to other systems.
- Patch 6: Unlock the coordinate discard so that the shared device
  assignment (VFIO) can work with guest_memfd.

Compared with v1 series, the main changes are:

- Rename the class name from GuestMemfdManager to MemoryAttributeManager.
- Add a new field in RAMBlock to store the guest_memfd information.
- Add patch 02 to make memory_region_set_ram_discard_manager() return the result.
- Drop the patch 07 in v1 series which is an extension and not necessary for the current series.
- v1: https://lore.kernel.org/qemu-devel/20241213070852.106092-1-chenyi.qiang@intel.com/

More small changes or details can be found in the individual patches.

Background
==========
Confidential VMs have two classes of memory: shared and private memory.
Shared memory is accessible from the host/VMM while private memory is
not. Confidential VMs can decide which memory is shared/private and
convert memory between shared/private at runtime.

"guest_memfd" is a new kind of fd whose primary goal is to serve guest
private memory. In current implementation, shared memory is allocated
with normal methods (e.g. mmap or fallocate) while private memory is
allocated from guest_memfd. When a VM performs memory conversions, QEMU
frees pages via madvise or via PUNCH_HOLE on memfd or guest_memfd from
one side, and allocates new pages from the other side. This will cause a
stale IOMMU mapping issue mentioned in [1] when we try to enable shared
device assignment in confidential VMs.

Solution
========
The key to enable shared device assignment is to update the IOMMU mappings
on page conversion. RamDiscardManager, an existing interface currently
utilized by virtio-mem, offers a means to modify IOMMU mappings in
accordance with VM page assignment. Page conversion is similar to
hot-removing a page in one mode and adding it back in the other.

This series implements a RamDiscardManager for confidential VMs and
utilizes its infrastructure to notify VFIO of page conversions.

Relationship with in-place page conversion
==========================================
To support 1G page support for guest_memfd [2], the current direction is to
allow mmap() of guest_memfd to userspace so that both private and shared
memory can use the same physical pages as the backend. This in-place page
conversion design eliminates the need to discard pages during shared/private
conversions. However, device assignment will still be blocked because the
in-place page conversion will reject the conversion when the page is pinned
by VFIO.

To address this, the key difference lies in the sequence of VFIO map/unmap
operations and the page conversion. It can be adjusted to achieve
unmap-before-conversion-to-private and map-after-conversion-to-shared,
ensuring compatibility with guest_memfd.

Limitation
==========
One limitation is that VFIO expects the DMA mapping for a specific IOVA
to be mapped and unmapped with the same granularity. The guest may
perform partial conversions, such as converting a small region within a
larger region. To prevent such invalid cases, all operations are
performed with 4K granularity. This could be optimized after the
cut_mapping operation [3] is introduced in future. We can alway perform a
split-before-unmap if partial conversions happen. If the split succeeds,
the unmap will succeed and be atomic. If the split fails, the unmap
process fails.

Testing
=======
This patch series is tested based on TDX patches available at:
KVM: https://github.com/intel/tdx/tree/tdx_kvm_dev-2025-02-10
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2025-02-17-v2

To facilitate shared device assignment with the NIC, employ the legacy
type1 VFIO with the QEMU command:

qemu-system-x86_64 [...]
    -device vfio-pci,host=XX:XX.X

The parameter of dma_entry_limit needs to be adjusted. For example, a
16GB guest needs to adjust the parameter like
vfio_iommu_type1.dma_entry_limit=4194304.

If use the iommufd-backed VFIO with the qemu command:

qemu-system-x86_64 [...]
    -object iommufd,id=iommufd0 \
    -device vfio-pci,host=XX:XX.X,iommufd=iommufd0

No additional adjustment required.

Following the bootup of the TD guest, the guest's IP address becomes
visible, and iperf is able to successfully send and receive data.

Related link
============
[1] https://lore.kernel.org/qemu-devel/20240423150951.41600-54-pbonzini@redhat.com/
[2] https://lore.kernel.org/lkml/cover.1726009989.git.ackerleytng@google.com/
[3] https://lore.kernel.org/linux-iommu/7-v1-01fa10580981+1d-iommu_pt_jgg@nvidia.com/

---
Chenyi Qiang (6):
  memory: Export a helper to get intersection of a MemoryRegionSection
    with a given range
  memory: Change memory_region_set_ram_discard_manager() to return the
    result
  memory-attribute-manager: Introduce MemoryAttributeManager to manage
    RAMBLock with guest_memfd
  memory-attribute-manager: Introduce a callback to notify the
    shared/private state change
  memory: Attach MemoryAttributeManager to guest_memfd-backed RAMBlocks
  RAMBlock: Make guest_memfd require coordinate discard

 accel/kvm/kvm-all.c                       |   9 +
 hw/virtio/virtio-mem.c                    |  62 ++-
 include/exec/memory.h                     |  33 +-
 include/exec/ramblock.h                   |   2 +
 include/system/memory-attribute-manager.h |  62 +++
 system/memory-attribute-manager.c         | 440 ++++++++++++++++++++++
 system/memory.c                           |  11 +-
 system/meson.build                        |   1 +
 system/physmem.c                          |  17 +-
 9 files changed, 589 insertions(+), 48 deletions(-)
 create mode 100644 include/system/memory-attribute-manager.h
 create mode 100644 system/memory-attribute-manager.c

-- 
2.43.5


