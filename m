Return-Path: <kvm+bounces-33690-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D17789F052F
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 08:09:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 767CC1889A4E
	for <lists+kvm@lfdr.de>; Fri, 13 Dec 2024 07:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6E5118E377;
	Fri, 13 Dec 2024 07:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KHbDrdYs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5171372
	for <kvm@vger.kernel.org>; Fri, 13 Dec 2024 07:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734073759; cv=none; b=S0UzXxSQKexiF3NFLhb+pWARNjV5hThSziMbdKaRe9RHzvX/m7l8NGfHjrxMVo7r9Dyq5eLE1Q6sRgoLqDgq84IvQzqOEnJqxwnAEEWtdHV7PW8f16ypihQjiELAOVaWUhaX0gaAWu6d8D6/+CKXUGyzKcwg2s+U+VQGbidRKIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734073759; c=relaxed/simple;
	bh=0IjN+0MCgw2Kfh512oUfcZYlwhsgCE7z2ZafiBOLqqs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=P5wsW/KbDKNbQq3Ixedyono7joObTzSBd5pxhD1/KHvBrQesFBLvM6w6QogCxk9c9HjSZ7eBEcJdXNgzikx1raf0DTvWqrV2MWgEZtcdOlVU5f+AAIRZHzRKcu+PJJ58hTnbHELflf/UyUL77DDoGIKxk2KSTgpanGppd7cQbvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KHbDrdYs; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734073757; x=1765609757;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0IjN+0MCgw2Kfh512oUfcZYlwhsgCE7z2ZafiBOLqqs=;
  b=KHbDrdYs3k/Gr3/eNuWoSZU3/yn7OvkI7m1WNQw+cgmKKZnZHtgY9ppV
   iXB7qttTeyaB+ikTpbCFee8EqMGj2PJOE5zwl78CDCWojI86yhtNg04x3
   KFTHLDpDPw0gokgHA698SKkzkJrWGGXLW4J2zxSjVOROQ0MzR0TWvpQxM
   ETLaTQYRHxVEBmWxmczWWZ91A5Kk4YjTMnwqBRiuoBAlK708hEEdoN+CT
   7mygiDZeDig1DWIuWtC1ClJ9eHrZ9cIcYLf/gonOyO14Xz9UIb7q9x+ny
   yrOUaKrYfIVERcm9plXLIdWMNW2MLlq2pTWPljiV+buX3/doB/X2XzdS6
   g==;
X-CSE-ConnectionGUID: Ox7xK+C2S0mp+MVnFcm3ww==
X-CSE-MsgGUID: YmsegzRDSO2g6iZ0DdGzbg==
X-IronPort-AV: E=McAfee;i="6700,10204,11284"; a="51937061"
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="51937061"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:16 -0800
X-CSE-ConnectionGUID: awN3I9MKSHqDQVXc8J2szA==
X-CSE-MsgGUID: MTGxQwfkRQ+XmeIdh72Srg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,230,1728975600"; 
   d="scan'208";a="96365528"
Received: from emr-bkc.sh.intel.com ([10.112.230.82])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Dec 2024 23:09:13 -0800
From: Chenyi Qiang <chenyi.qiang@intel.com>
To: David Hildenbrand <david@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Michael Roth <michael.roth@amd.com>
Cc: Chenyi Qiang <chenyi.qiang@intel.com>,
	qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	Williams Dan J <dan.j.williams@intel.com>,
	Peng Chao P <chao.p.peng@intel.com>,
	Gao Chao <chao.gao@intel.com>,
	Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 0/7] Enable shared device assignment
Date: Fri, 13 Dec 2024 15:08:42 +0800
Message-ID: <20241213070852.106092-1-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Commit 852f0048f3 ("RAMBlock: make guest_memfd require uncoordinated
discard") effectively disables device assignment when using guest_memfd.
This poses a significant challenge as guest_memfd is essential for
confidential guests, thereby blocking device assignment to these VMs.
The initial rationale for disabling device assignment was due to stale
IOMMU mappings (see Problem section) and the assumption that TEE I/O
(SEV-TIO, TDX Connect, COVE-IO, etc.) would solve the device-assignment
problem for confidential guests [1]. However, this assumption has proven
to be incorrect. TEE I/O relies on the ability to operate devices against
"shared" or untrusted memory, which is crucial for device initialization
and error recovery scenarios. As a result, the current implementation does
not adequately support device assignment for confidential guests, necessitating
a reevaluation of the approach to ensure compatibility and functionality.

This series enables shared device assignment by notifying VFIO of page
conversions using an existing framework named RamDiscardListener.
Additionally, there is an ongoing patch set [2] that aims to add 1G page
support for guest_memfd. This patch set introduces in-place page conversion,
where private and shared memory share the same physical pages as the backend.
This development may impact our solution.

We presented our solution in the guest_memfd meeting to discuss its
compatibility with the new changes and potential future directions (see [3]
for more details). The conclusion was that, although our solution may not be
the most elegant (see the Limitation section), it is sufficient for now and
can be easily adapted to future changes.

We are re-posting the patch series with some cleanup and have removed the RFC
label for the main enabling patches (1-6). The newly-added patch 7 is still
marked as RFC as it tries to resolve some extension concerns related to
RamDiscardManager for future usage.

The overview of the patches:
- Patch 1: Export a helper to get intersection of a MemoryRegionSection
  with a given range.
- Patch 2-6: Introduce a new object to manage the guest-memfd with
  RamDiscardManager, and notify the shared/private state change during
  conversion.
- Patch 7: Try to resolve a semantics concern related to RamDiscardManager
  i.e. RamDiscardManager is used to manage memory plug/unplug state
  instead of shared/private state. It would affect future users of
  RamDiscardManger in confidential VMs. Attach it behind as a RFC patch[4].

Changes since last version:
- Add a patch to export some generic helper functions from virtio-mem code.
- Change the bitmap in guest_memfd_manager from default shared to default
  private. This keeps alignment with virtio-mem that 1-setting in bitmap
  represents the populated state and may help to export more generic code
  if necessary.
- Add the helpers to initialize/uninitialize the guest_memfd_manager instance
  to make it more clear.
- Add a patch to distinguish between the shared/private state change and
  the memory plug/unplug state change in RamDiscardManager.
- RFC: https://lore.kernel.org/qemu-devel/20240725072118.358923-1-chenyi.qiang@intel.com/

---

Background
==========
Confidential VMs have two classes of memory: shared and private memory.
Shared memory is accessible from the host/VMM while private memory is
not. Confidential VMs can decide which memory is shared/private and
convert memory between shared/private at runtime.

"guest_memfd" is a new kind of fd whose primary goal is to serve guest
private memory. The key differences between guest_memfd and normal memfd
are that guest_memfd is spawned by a KVM ioctl, bound to its owner VM and
cannot be mapped, read or written by userspace.

In QEMU's implementation, shared memory is allocated with normal methods
(e.g. mmap or fallocate) while private memory is allocated from
guest_memfd. When a VM performs memory conversions, QEMU frees pages via
madvise() or via PUNCH_HOLE on memfd or guest_memfd from one side and
allocates new pages from the other side.

Problem
=======
Device assignment in QEMU is implemented via VFIO system. In the normal
VM, VM memory is pinned at the beginning of time by VFIO. In the
confidential VM, the VM can convert memory and when that happens
nothing currently tells VFIO that its mappings are stale. This means
that page conversion leaks memory and leaves stale IOMMU mappings. For
example, sequence like the following can result in stale IOMMU mappings:

1. allocate shared page
2. convert page shared->private
3. discard shared page
4. convert page private->shared
5. allocate shared page
6. issue DMA operations against that shared page

After step 3, VFIO is still pinning the page. However, DMA operations in
step 6 will hit the old mapping that was allocated in step 1, which
causes the device to access the invalid data.

Solution
========
The key to enable shared device assignment is to update the IOMMU mappings
on page conversion.

Given the constraints and assumptions here is a solution that satisfied
the use cases. RamDiscardManager, an existing interface currently
utilized by virtio-mem, offers a means to modify IOMMU mappings in
accordance with VM page assignment. Page conversion is similar to
hot-removing a page in one mode and adding it back in the other.

This series implements a RamDiscardManager for confidential VMs and
utilizes its infrastructure to notify VFIO of page conversions.

Another possible attempt [5] was to not discard shared pages in step 3
above. This was an incomplete band-aid because guests would consume
twice the memory since shared pages wouldn't be freed even after they
were converted to private.

w/ in-place page conversion
===========================
To support 1G page support for guest_memfd, the current direction is to
allow mmap() of guest_memfd to userspace so that both private and shared
memory can use the same physical pages as the backend. This in-place page
conversion design eliminates the need to discard pages during shared/private
conversions. However, device assignment will still be blocked because the
in-place page conversion will reject the conversion when the page is pinned
by VFIO.

To address this, the key difference lies in the sequence of VFIO map/unmap
operations and the page conversion. This series can be adjusted to achieve
unmap-before-conversion-to-private and map-after-conversion-to-shared,
ensuring compatibility with guest_memfd.

Additionally, with in-place page conversion, the previously mentioned
solution to disable the discard of shared pages is not feasible because
shared and private memory share the same backend, and no discard operation
is performed. Retaining the old mappings in the IOMMU would result in
unsafe DMA access to protected memory.

Limitation
==========

One limitation (also discussed in the guest_memfd meeting) is that VFIO
expects the DMA mapping for a specific IOVA to be mapped and unmapped with
the same granularity. The guest may perform partial conversions, such as
converting a small region within a larger region. To prevent such invalid
cases, all operations are performed with 4K granularity. The possible
solutions we can think of are either to enable VFIO to support partial unmap
or to implement an enlightened guest to avoid partial conversion. The former
requires complex changes in VFIO, while the latter requires the page
conversion to be a guest-enlightened behavior. It is still uncertain which
option is a preferred one.

Testing
=======
This patch series is tested with the KVM/QEMU branch:
KVM: https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-11-20
QEMU: https://github.com/intel-staging/qemu-tdx/tree/tdx-upstream-snapshot-2024-12-13

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
[1] https://lore.kernel.org/all/d6acfbef-96a1-42bc-8866-c12a4de8c57c@redhat.com/
[2] https://lore.kernel.org/lkml/cover.1726009989.git.ackerleytng@google.com/
[3] https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?tab=t.0#heading=h.jr4csfgw1uql
[4] https://lore.kernel.org/qemu-devel/d299bbad-81bc-462e-91b5-a6d9c27ffe3a@redhat.com/
[5] https://lore.kernel.org/all/20240320083945.991426-20-michael.roth@amd.com/

Chenyi Qiang (7):
  memory: Export a helper to get intersection of a MemoryRegionSection
    with a given range
  guest_memfd: Introduce an object to manage the guest-memfd with
    RamDiscardManager
  guest_memfd: Introduce a callback to notify the shared/private state
    change
  KVM: Notify the state change event during shared/private conversion
  memory: Register the RamDiscardManager instance upon guest_memfd
    creation
  RAMBlock: make guest_memfd require coordinate discard
  memory: Add a new argument to indicate the request attribute in
    RamDismcardManager helpers

 accel/kvm/kvm-all.c                  |   4 +
 hw/vfio/common.c                     |  22 +-
 hw/virtio/virtio-mem.c               |  55 ++--
 include/exec/memory.h                |  36 ++-
 include/sysemu/guest-memfd-manager.h |  91 ++++++
 migration/ram.c                      |  14 +-
 system/guest-memfd-manager.c         | 456 +++++++++++++++++++++++++++
 system/memory.c                      |  30 +-
 system/memory_mapping.c              |   4 +-
 system/meson.build                   |   1 +
 system/physmem.c                     |   9 +-
 11 files changed, 659 insertions(+), 63 deletions(-)
 create mode 100644 include/sysemu/guest-memfd-manager.h
 create mode 100644 system/guest-memfd-manager.c

-- 
2.43.5


