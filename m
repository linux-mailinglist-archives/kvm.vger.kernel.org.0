Return-Path: <kvm+bounces-17395-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D97F78C5E7E
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:00:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 172E82827D1
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:00:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9FA18C11;
	Wed, 15 May 2024 01:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HiaImoDg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F307263A5;
	Wed, 15 May 2024 01:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734804; cv=none; b=VQpyXTqdpxQeYHoZVMdA9EHWfZsXrMilgY+NEyw9REf7c8G+PZcyIpNVBfcetWRN0pIKmRjg4+6EQT31KJW6NBW96LaQYja+h7i2ESWUCojc8JkdgM3wK7PU5JJCcAPc/gEy9ahbEcfDwnPyGkh+IMf+9sLZjIDhUJljAMJFZSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734804; c=relaxed/simple;
	bh=Cp/taW4aU5xTl1ywQG+QuRJ8YOKpTFHECwpY5rydtKE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=J01izAJQnVI2rG0L6+BYSNdYdvYaJOeXkmdnybKx9rbYP7so2mFIzMLkCA/KuDedhggrMZJISbK6tfpG3zxdsJhLJhO9F0TpOHGEoWKyH8BKuWyOCizmsSYbC6AbpmY2z5NiSONQ9esqUaWblxM+zn61ON1I3uhOakUvRIG1Qs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HiaImoDg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734802; x=1747270802;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Cp/taW4aU5xTl1ywQG+QuRJ8YOKpTFHECwpY5rydtKE=;
  b=HiaImoDgz1fcK4MyWe0a1WfhTYtI30fkkTXlqkCPVh7Ra9tU7pBwKVns
   MgvGljNh7G/AshtUOcshgh70FkUSGK0yurWtyMZj/Sf3GhGl05L+H1tee
   zD6X7iRxOtGfZ0SzDQep5eVLKRP7j3hFiKciicsiZEXwUiQpQwNe3O9ye
   GHhQ/DR1G8rpOheKm5EU+WppuxTpE5NVCNzwDt2ybJPsxGE29txIvUEc6
   ifcFfeYIzVsGXbwl21ufslIBg13SEgYtX8qm8dqeHiKQNO89mgaQ5kg3g
   GMkhsB8w5RqBirZRBZT0fvhCi2bpXa8uQ5ExAbC6yPuEXmzf56FAXObsZ
   A==;
X-CSE-ConnectionGUID: OZK4+JSzRdaRAygCDgJDhQ==
X-CSE-MsgGUID: NWx9TqyrRwC66rzO27mo8g==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613916"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613916"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:01 -0700
X-CSE-ConnectionGUID: ujLYQ3aoShWi/tON3UM5/A==
X-CSE-MsgGUID: +nQmj1TbQ7WC6durqMJHAg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942701"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:00 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 00/16] TDX MMU prep series part 1
Date: Tue, 14 May 2024 17:59:36 -0700
Message-Id: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

This is a TDX prep series, split out of the giant 130 patch TDX base
enabling series [0]. It is focusing on the changes to the KVM MMU to
support TDX’s separation of private/shared EPT. A future breakout series
will include the changes to interact with the TDX module to actually map
private memory. The purpose of sending out a smaller series is to focus
review, and hopefully rapidly iterate on the smaller series.

It is not quite ready for upstream inclusion yet, but it as reached another
point where more public comments could help.

There is a larger team working on TDX KVM base enabling. Most patches were
originally authored by Sean Christopherson and Isaku Yamahata, with recent
work by Yan Y Zhao, Isaku and myself.

The series has been tested as part of a development branch for the TDX
base series [1]. The testing so far consists TDX kvm-unit-tests [2] and
booting a Linux TD, and regular KVM selftests (not the TDX ones).

Contents of the series
======================
There are some simple preparatory patches mixed into the series, which is
ordered with bisectability in mind. The patches that most likely need
further discussion are:

KVM: x86/mmu: Introduce a slot flag to zap only slot leafs on slot deletion
  Looking at expanding the need for TDX to zap only the specific PTEs for a 
  memslot on deletion, into a general KVM feature.

KVM: Add member to struct kvm_gfn_range for target alias
  Discussion on how to target zapping to the appropriate private/shared
  alias.

KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is called for TDX
  A change that includes a discussion on how to handle cache attributes on
  shared memory.

KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
  A big "how to do private/shared split" patch.
  
Patches 11-15:
  Handling the separate aliases on MMU operations, first started in "Add 
  member to struct kvm_gfn_range for target alias"


Private/shared memory in TDX
============================
Confidential computing solutions have concepts of private and shared
memory. Often the guest accesses either private or shared memory via a bit
in the PTE. Solutions like SEV treat this bit more like a permission bit,
where solutions like TDX and ARM CCA treat it more like a GPA bit. In the
latter case, the host maps private memory in one half of the address space
and shared in another. For TDX these two halves are mapped by different
EPT roots. The private half (also called Secure EPT in Intel
documentation) gets managed by the privileged TDX Module. The shared half
is managed by the untrusted part of the VMM (KVM).

In addition to the separate roots for private and shared, there are
limitations on what operations can be done on the private side. TDX wants
to protect against protected memory being reset or otherwise scrambled by
the host. In order to prevent this, the guest has to take specific action
to “accept” memory after changes are made by the VMM to the private EPT.
This prevents the VMM from performing many of the usual memory management
operations that involve zapping and refaulting memory. The private memory
also is always RWX and cannot have VMM specified cache attribute
attributes applied.

TDX KVM MMU Design For Private Memory
=====================================

Private/shared split
--------------------
The operations that actually change the private half of the EPT are
limited and relatively slow compared to reading a PTE. For this reason the
design for KVM is to keep a “mirrored” copy of the private EPT in KVM’s
memory. This will allow KVM to quickly walk the EPT and only perform the
slower private EPT operations when it needs to actually modify mid-level
private PTEs.

To clarify the definitions of the three EPT trees at this point:
private EPT  - Protected by the TDX module, modified via TDX module
               calls.
mirrored EPT - Bookkeeping tree used as an optimization by KVM, not
               mapped.
shared EPT   - Normal EPT that maps unencrypted shared memory.
               Managed like the EPT of a normal VM.

It’s worth noting that we are making an effort to remove optimizations
that have complexity for the base enabling. Although keeping a mirrored
copy of the private page tables kind of fits into that category, it has
been so fundamental to the design for so long, dropping it would be too
disruptive.

Mirrored EPT
------------
The mirrored EPT needs to keep a mirrored version of the private EPT
maintained in the TDX module in order to be able to find out if a GPA’s
mid-level pagetable have already been installed. So this mirrored copy has
the same structure as the private EPT, having a page table present for
every GPA range and level in the mirrored EPT where a page table is
present private. The private page tables also cannot be zapped while the
range has anything mapped, so the mirrored/private page tables need to be
protected from KVM operations that zap any non-leaf PTEs, for example
kvm_mmu_reset_context() or kvm_mmu_zap_all_fast()

Modifications to the mirrored page tables need to also perform the same
operations to the private page tables. The actual TDX module calls to do
this are not covered in this prep series.

For convenience SPs for private page tables are tracked with a role bit
out of convenience. (Note to reviewers, please consider if this is really
needed).

Zapping Changes
---------------
For normal VMs, guest memory is zapped for several reasons, like user
memory getting paged out by the guest, memslots getting deleted or
virtualization operations like MTRRs, and attachment of non-coherent DMA.
For TDX (and SNP) there is also zapping associated with the conversion of
memory between shared and privates. These operations need to take care to
do two things:
1. Not zap any private memory that is in use by the guest.
2. Not zap any memory alias unnecessarily (i.e. Don’t zap anything more
than needed). The purpose of this is to not have any unnecessary behavior
userspace could grow to rely on.

For 1, this is possible because the zapping that is out of the control of
KVM/userspace (paging out of userspace memory) will only apply to shared
memory. Guest mem fd operations are protected from mmu notifier
operations. During TD runtime, zapping of private memory will only be from
memslot deletion and from conversion between private and shared memory
which is triggered by the guest.

For 2, KVM needs to be taught which operations will operate on which
aliases. An enum based scheme is introduced such that operations can
target specific aliases like:
Memslot deletion           - Private and shared
MMU notifier based zapping - Shared only
Conversion to shared       - Private only
Conversion to private      - Shared only
MTRRs, etc                 - Zapping will be avoided all together

For zapping arising from other virtualization based operations, there are
four scenarios:
1. MTRR update
2. CR0.CD update
3. APICv update
4. Non-coherent DMA status update

KVM TDX will not support 1-3. In future changes (after this series) the
features will not be supported for TDX. For 4, there isn’t an easy way to
not support the feature as the notification is just passed to KVM and it
has to act accordingly. However, other proposed changes [3] will avoid the
need for zapping on non-coherent DMA notification for selfsnoop CPUs. So
KVM can follow this logic and just always honor guest PAT for shared
memory. See more details in patch 8.

Prevention of zapping mid-level PTEs
------------------------------------
As mentioned earlier, private PTEs (and so also mirrored PTEs) need to be
zapped at the leafs only. This means for TDX, the fast zap roots
optimization for memslot deletion is not compatible, and instead only the
leafs should be zapped. Behavior like this for memslot deletion was
tried[4] once before for normal VMs, and fortunately it exposed a
mysterious bug affecting an nVidia GPU in a Windows guest that was never
root caused.

Since the restrictions on not zapping roots is only for private memory,
TDX could minimize the possibility of being exposed to this by always
zapping shared roots, and zapping leafs only for the private alias.
However, designing long term ABI around a bug seems wrong. So instead,
this series explores creating a new memslot flag that allows for
specifying that a memslot should be deleted without zapping other GPA
ranges. The expectation would be for userspace to set this on memslots
used for TDX. Controlling this behavior at the VM level was also explored.
See patch 2 for more information.

Atomically updating private EPT
-------------------------------
Although this prep series does not interact with the TDX module at all to
actually configure the private EPT, it does lay the ground work for doing
this. In some ways updating the private EPT is as simple as plumbing PTE
modifications through to also call into the TDX module, but there is one
tricky property that is worth elaborating on. That is how to handle that
the TDP MMU allows modification of PTEs with the mmu_lock held only for
read and uses the PTEs themselves to perform synchronization.

Unfortunately while operating on a single PTE can be done atomically,
operating on both the mirrored and private PTEs at the same time needs
additional solution. To handle this situation, REMOVED_SPTE is used to
prevent concurrent operations while a call to the TDX module updates the
private EPT. For more information see the documentation in patch 18.

For more detailed discussion see the "The original TDP MMU and race
condition" section of documentation patch [5]

The series is based on kvm-coco-queue.

[0] https://lore.kernel.org/kvm/cover.1708933498.git.isaku.yamahata@intel.com/
[1] https://github.com/intel/tdx/tree/tdx_kvm_dev-2024-05-14-mmu-prep-1
[2] https://lore.kernel.org/kvm/20231218072247.2573516-1-qian.wen@intel.com/
[3] https://lore.kernel.org/kvm/20240309010929.1403984-6-seanjc@google.com/
[4] https://lore.kernel.org/kvm/20200703025047.13987-1-sean.j.christopherson@intel.com/
[5] https://github.com/intel/tdx/commit/70cd3c807e547854ea52f56623ce168c7869679e


Isaku Yamahata (11):
  KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
  KVM: x86/mmu: Add address conversion functions for TDX shared bit of
    GPA
  KVM: Add member to struct kvm_gfn_range for target alias
  KVM: x86/mmu: Add a new is_private member for union kvm_mmu_page_role
  KVM: x86/mmu: Add a private pointer to struct kvm_mmu_page
  KVM: x86/tdp_mmu: Support TDX private mapping for TDP MMU
  KVM: x86/tdp_mmu: Extract root invalid check from tdx_mmu_next_root()
  KVM: x86/tdp_mmu: Introduce KVM MMU root types to specify page table
    type
  KVM: x86/tdp_mmu: Introduce shared, private KVM MMU root types
  KVM: x86/tdp_mmu: Take root types for
    kvm_tdp_mmu_invalidate_all_roots()
  KVM: x86/tdp_mmu: Make mmu notifier callbacks to check kvm_process

Rick Edgecombe (3):
  KVM: x86: Add a VM type define for TDX
  KVM: x86/mmu: Bug the VM if kvm_zap_gfn_range() is called for TDX
  KVM: x86/mmu: Make kvm_tdp_mmu_alloc_root() return void

Sean Christopherson (1):
  KVM: x86/tdp_mmu: Invalidate correct roots

Yan Zhao (1):
  KVM: x86/mmu: Introduce a slot flag to zap only slot leafs on slot
    deletion

 arch/x86/include/asm/kvm-x86-ops.h |   5 +
 arch/x86/include/asm/kvm_host.h    |  45 +++-
 arch/x86/include/uapi/asm/kvm.h    |   1 +
 arch/x86/kvm/mmu.h                 |  36 +++
 arch/x86/kvm/mmu/mmu.c             |  86 +++++-
 arch/x86/kvm/mmu/mmu_internal.h    |  60 ++++-
 arch/x86/kvm/mmu/spte.h            |   5 +
 arch/x86/kvm/mmu/tdp_iter.h        |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 407 ++++++++++++++++++++++++-----
 arch/x86/kvm/mmu/tdp_mmu.h         |  18 +-
 arch/x86/kvm/x86.c                 |  17 ++
 include/linux/kvm_host.h           |   8 +
 include/uapi/linux/kvm.h           |   1 +
 virt/kvm/guest_memfd.c             |   2 +
 virt/kvm/kvm_main.c                |  19 +-
 15 files changed, 632 insertions(+), 80 deletions(-)


base-commit: 698ca1e403579ca00e16a5b28ae4d576d9f1b20e
-- 
2.34.1


