Return-Path: <kvm+bounces-40599-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75181A58DEA
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 09:20:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A54B016A8C4
	for <lists+kvm@lfdr.de>; Mon, 10 Mar 2025 08:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4564522257E;
	Mon, 10 Mar 2025 08:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ABjhcdoW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96135965
	for <kvm@vger.kernel.org>; Mon, 10 Mar 2025 08:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741594819; cv=none; b=VnGFi+JjdnlTdVvb9bNca9XlS71pIrvgNKaA+3QEp+0JipDEHaaIyzElxsYGMTgzRfbnGpVHXVLgxQx8E8pp7uh1WQjlgTMwjRslS7puTZOG1AqjlsAzobLDBLD0E76ipqBxCyKoIwfwo5KpznlazUVzh2ITgdsgFINTeqWpQXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741594819; c=relaxed/simple;
	bh=LXWNHMvLvXD0VwhJ6IcIyTnGaD9zgRK8HpIgyy3vA6E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IYEG0w5knMwBh2W6ZxL0coaqB2ZeM38ZPMo6iq9OTLR+WFAYXPTBR9HmkONeLSBr9pb0AFBtDC8285d8vkJIAqcJpn2TcI99XfjuuoElKSqP3I5nXmwu1Pfr5oOmf84i5Gdewvj34A6dUFkmjYd4Tm4BARm9XKKG4g5CLeNWfR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ABjhcdoW; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741594817; x=1773130817;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=LXWNHMvLvXD0VwhJ6IcIyTnGaD9zgRK8HpIgyy3vA6E=;
  b=ABjhcdoWEpCTsZaw8XZRA3qr5G81ozn/3uF2LxHW92sqxXi/VJ9aKT0O
   kfFylQyCASFIibuRwRi1VkmGjUv2vPH+YoOZEbaNHVugY5r8cEFd//Vva
   3IZoQpRCUdqsz7m5XI7vCS9tdLSJcvY+id5uqDzeUWBnY13Y7ikZxiv8u
   qlJ5ooxlQqkWs217DsPy+3GoFXdzfpx3trhph4py7BlU3to9b4KvY6SdC
   6P4jpAtZKclpu+1F6D7qEDfUW6zYxVuFOBdG9GwtKpx1/A8WrsJnzoPTY
   c6kJXmrA1zqoux+c7pjTQHAn1/ZoHjEeqnGyoXWmPHVsbBVtevuH/0QNf
   A==;
X-CSE-ConnectionGUID: MUrml70DQT+dbjnT33bptg==
X-CSE-MsgGUID: 36UKrJlkR7aaWt3dvie/Yg==
X-IronPort-AV: E=McAfee;i="6700,10204,11368"; a="42688441"
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="42688441"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:16 -0700
X-CSE-ConnectionGUID: 8jJCGZSLQg+TyO4E3PI0/w==
X-CSE-MsgGUID: rn7e5Ph6R2+rfXMhZWE4GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,235,1736841600"; 
   d="scan'208";a="150862776"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2025 01:20:13 -0700
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
Subject: [PATCH v3 0/7] Enable shared device assignment
Date: Mon, 10 Mar 2025 16:18:28 +0800
Message-ID: <20250310081837.13123-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is the v3 series of the shared device assignment support.

The overview of this series:
- Patch 1-3: preparation patches. The function exposure and some
  defintion change to return values.
- Patch 4-5: Introduce a new object to implement RamDiscardManager
  interface and a callback to notify the shared/private state change.
- Patch 6: Store the new object including guest_memfd information in
  RAMBlock. Register the RamDiscardManager instance to the target
  RAMBlock's MemoryRegion so that the object can notify the page
  conversion events to other systems.
- Patch 7: Unlock the coordinate discard so that the shared device
  assignment (VFIO) can work with guest_memfd.

Compared with v2 series, the main changes are:

- Introduce the new patch 04 to unify the definiton of ReplayRamPopulate()
  and ReplayRamDiscard().
- In state_change() callback, fallback to a "1 block at a time" handling in case of
  mixed state. In addition, change the bitmap before calling the
  listener so that the listener can do the change according to the
  latest status.
- In kvm_convert_memory(), use ReplayPopulated() and ReplayDiscard()
  interface to trigger set_attribute() and add the undo operation if
  state_change() failed.
- v2: https://lore.kernel.org/qemu-devel/20250217081833.21568-1-chenyi.qiang@intel.com/

More small changes or details can be found in the individual patches.

---
Original cover letter:

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
KVM: https://github.com/intel/tdx/tree/kvm-coco-queue-snapshot/kvm-coco-queue-snapshot-20250308
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2025-03-10

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

Chenyi Qiang (7):
  memory: Export a helper to get intersection of a MemoryRegionSection
    with a given range
  memory: Change memory_region_set_ram_discard_manager() to return the
    result
  memory: Unify the definiton of ReplayRamPopulate() and
    ReplayRamDiscard()
  memory-attribute-manager: Introduce MemoryAttributeManager to manage
    RAMBLock with guest_memfd
  memory-attribute-manager: Introduce a callback to notify the
    shared/private state change
  memory: Attach MemoryAttributeManager to guest_memfd-backed RAMBlocks
  RAMBlock: Make guest_memfd require coordinate discard

 accel/kvm/kvm-all.c                       |  50 ++-
 hw/virtio/virtio-mem.c                    |  81 ++--
 include/exec/memory.h                     |  64 ++-
 include/exec/ramblock.h                   |   2 +
 include/system/memory-attribute-manager.h |  60 +++
 migration/ram.c                           |   5 +-
 system/memory-attribute-manager.c         | 471 ++++++++++++++++++++++
 system/memory.c                           |  22 +-
 system/meson.build                        |   1 +
 system/physmem.c                          |  17 +-
 10 files changed, 690 insertions(+), 83 deletions(-)
 create mode 100644 include/system/memory-attribute-manager.h
 create mode 100644 system/memory-attribute-manager.c

-- 
2.43.5


