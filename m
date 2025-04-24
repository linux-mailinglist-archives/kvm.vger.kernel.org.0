Return-Path: <kvm+bounces-44029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 99208A99F2F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:04:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8BFB5194311C
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BA431A23AC;
	Thu, 24 Apr 2025 03:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="haiXz99N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9C679D0;
	Thu, 24 Apr 2025 03:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745463871; cv=none; b=KFfZCKzqrIC7HvpH7FkLLvvdp0rccFQUuPCkUeXbttnYkT5zn3jQ0XFwcQi7wSt/drSeln2FLXS1paNVEgosx2d7PpSBsa0mk4R//9AoDf8oa4Q43b2EEINPeVamCYFbkctCoGOHG3WwLXJwQ9itwrtjeEiI5mG48yZHcmRMQHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745463871; c=relaxed/simple;
	bh=FBuMCz98dRxZxnNfNDUwwxkSyUYk5JHRBFbSQhaGAPo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FxOgefEd4AM9mywUWtTl86zeEPVcWTxSn72r55C7eb3FEGUKS6DFbXl5Viqkw0CHjSXr0pme72aUHe+1MGupa1Liutg3T25KoTDMDC1emps/iJGkGi9bqjrvbmtAZ6Zc15GGmPERZy+h3CV75tr79iDM5wHh6LNsGabjLV1Q/s8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=haiXz99N; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745463869; x=1776999869;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FBuMCz98dRxZxnNfNDUwwxkSyUYk5JHRBFbSQhaGAPo=;
  b=haiXz99Nt6JW7lpI3vTorcYHd9ia5Ba5ihmpqKyE3WIYX+Rn4JAgADMl
   6SLdNazy3FfI9fdo0BX51SnyAypnxojVV1R4WHSJRIVL8aRL9MlKlz4Jj
   wSNaSfmmJQsEutzGgxVqjUQuH00KeIhHX7ozh6lPlnQQ+3mDvLl/M5/Ls
   bZGXDXM6rIvJZbIU/vAi4l5yokQmGDVVy6UdCmW47D5ScD8sJ9eyJs9Qd
   M9AfXRs8II1YE3rm/Jgk/WhYVrs81AmYf5qtkuKM8orrBXSgtPUDA/j6z
   oo15Nbk9F5ZKUw0NYLrX2bNSTwJ9/z7t+LNCf91XuE4yEAOLqVitWlEM+
   g==;
X-CSE-ConnectionGUID: O3N4s/L1RnC1Nz1CoRqdsg==
X-CSE-MsgGUID: EBCf+KcSSduj6HXc2N5f/A==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47094218"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47094218"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:04:28 -0700
X-CSE-ConnectionGUID: IKqJdi5yR6O/tdOmT5F6tg==
X-CSE-MsgGUID: YGEx9l6BR+iIk+PV5IFqDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="133014863"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:04:24 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	chao.p.peng@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 00/21] KVM: TDX huge page support for private memory
Date: Thu, 24 Apr 2025 11:00:32 +0800
Message-ID: <20250424030033.32635-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is an RFC series to support huge pages in TDX. It's an evolution of
the previous patches from Isaku [0]. (Please find the main changes to [0]
at a later section).

As the series of enabling guest_memfd to support 1GB huge page with
in-place conversion [1] is still under development, we temporarily based
the TDX work on top of the series from Michael Roth that enables basic 2M
guest_memfd support without in-place conversion[2].  The goal is to have an
early review and discussion of the TDX huge page work (including changes to
KVM core MMU and the TDX specific code), which should remain stable, with
only minor adjustments, regardless the changes coming in guest_memfd.

The series is currently focused on supporting 2MB huge pages only.

Tip folks, there are some SEAMCALL wrapper changes in this series, but we
need to have some discussion on the KVM side to figure out what it needs
still. Please feel free to ignore it for now.


Design
======
guest_memfd
-----------
TDX huge page support has a basic assumption to guest_memfd: guest_memfd
allocates private huge pages whenever alignment of GFN/index, range size
and the consistency of page attributes allow.

Patch 01 (based on [2]) in this RFC acts as glue code to ensure this
assumption is met for TDX. It can be absorbed into any future
guest_memfd series (e.g., future in-place conversion series) in any form.

TDX interacts with guest_memfd through interfaces kvm_gmem_populate() and
kvm_gmem_get_pfn(), obtaining the allocated page and its order.

The remaining TDX code should remain stable despite future changes in
guest_memfd.


Basic huge page mapping/unmapping
---------------------------------
- TD build time
  This series enforces that all private mappings be 4KB during the TD build
  phase, due to the TDX module's requirement that tdh_mem_page_add(), the
  SEAMCALL for adding private pages during TD build time, only supports 4KB
  mappings. Enforcing 4KB mappings also simplifies the implementation of
  code for TD build time, by eliminating the need to consider merging or
  splitting in the mirror page table during TD build time.
  
  The underlying pages allocated from guest_memfd during TD build time
  phase can still be large, allowing for potential merging into 2MB
  mappings once the TD is running.

- TD runtime
  This series allows a private fault's max_level to be 2MB after TD is
  running. KVM core MMU will map/unmap 2MB mappings in the mirror page
  table according to a fault's goal_level as what're done for normal VMs.
  Changes in the mirror page table are then propagated to the S-EPT.

  For transitions from non-present to huge leaf in the mirror page table,
  hook set_external_spte is invoked, leading to the execution of
  tdh_mem_page_aug() to install a huge leaf in the S-EPT.

  Conversely, during transitions from a huge leaf to non-present, the
  remove_external_spte hook is invoked to execute SEAMCALLs that remove the
  huge leaf from the S-EPT.

  (For transitions from huge leaf to non-leaf, or from non-leaf to huge
   leaf, SPTE splitting/merging will be triggered. More details are in
   later sections.)

- Specify fault max_level
  In the TDP MMU, a fault's max_level is initially set to the 1GB level for
  x86. KVM then updates the fault's max_level by determining the lowest
  order among fault->max_level, the order of the allocated private page,
  and the TDX-specified max_level from hook private_max_mapping_level.
  For TDX, a private fault's req_level, and goal_level finally equal to the
  fault's max_level as TDX platforms do not have the flaw for NX huge page.
  
  So, if TDX has specific requirements to influence a fault's goal_level
  for private memory (e.g., if it knows an EPT violation is caused by a
  TD's ACCEPT operation, mapping at the ACCEPT's level is preferred), this
  can be achieved either by affecting the initial value of fault->max_level
  or through the private_max_mapping_level hook.

  The former approach requires more changes in the KVM core (e.g., by using
  some bits in the error_code passed to kvm_mmu_page_fault() and having
  KVM check for them). This RFC opts for the latter, simpler method, using
  the private_max_mapping_level hook.
  

Page splitting (page demotion)
------------------------------
Page splitting occurs in two paths:
(a) with exclusive kvm->mmu_lock, triggered by zapping operations,

    For normal VMs, if zapping a narrow region that would need to split a
    huge page, KVM can simply zap the surrounding GFNs rather than
    splitting a huge page. The pages can then be faulted back in, where KVM
    can handle mapping them at a 4KB level.

    The reason why TDX can't use the normal VM solution is that zapping
    private memory that is accepted cannot easily be re-faulted, since it
    can only be re-faulted as unaccepted. So KVM will have to sometimes do
    the page splitting as part of the zapping operations.

    These zapping operations can occur for few reasons:
    1. VM teardown.
    2. Memslot removal.
    3. Conversion of private pages to shared.
    4. Userspace does a hole punch to guest_memfd for some reason.

    For case 1 and 2, splitting before zapping is unnecessary because
    either the entire range will be zapped or huge pages do not span
    memslots.
    
    Case 3 or case 4 requires splitting, which is also followed by a
    backend page splitting in guest_memfd.

(b) with shared kvm->mmu_lock, triggered by fault.

    Splitting in this path is not accompanied by a backend page splitting
    (since backend page splitting necessitates a splitting and zapping
     operation in the former path).  It is triggered when KVM finds that a
    non-leaf entry is replacing a huge entry in the fault path, which is
    usually caused by vCPUs' concurrent ACCEPT operations at different
    levels.

    This series simply ignores the splitting request in the fault path to
    avoid unnecessary bounces between levels. The vCPU that performs ACCEPT
    at a lower level would finally figures out the page has been accepted
    at a higher level by another vCPU.

    A rare case that could lead to splitting in the fault path is when a TD
    is configured to receive #VE and accesses memory before the ACCEPT
    operation. By the time a vCPU accesses a private GFN, due to the lack
    of any guest preferred level, KVM could create a mapping at 2MB level.
    If the TD then only performs the ACCEPT operation at 4KB level,
    splitting in the fault path will be triggered. However, this is not
    regarded as a typical use case, as usually TD always accepts pages in
    the order from 1GB->2MB->4KB. The worst outcome to ignore the resulting
    splitting request is an endless EPT violation. This would not happen
    for a Linux guest, which does not expect any #VE.

- Splitting for private-to-shared conversion or punch hole
  Splitting of a huge mapping requires the allocation of page table page
  and the corresponding shadow structures. This memory allocation can fail.
  So, while the zapping operations in the two scenarios don't have an
  understanding of failure, the overall operations do. Therefore, the RFC
  introduces a separate step kvm_split_boundary_leafs() to split huge
  mappings ahead of the zapping operation.

  Patches 16-17 implement this change. As noted in the patch log, the
  downside of the current approach is that although
  kvm_split_boundary_leafs() is invoked before kvm_unmap_gfn_range() for
  each GFN range, the entire zapping range may consist of several GFN
  ranges. If an out-of-memory error occurs during the splitting of a GFN
  range, some previous GFN ranges may have been successfully split and
  zapped, even though their page attributes remain unchanged due to the
  splitting failure. This may not be a significant issue, as the user can
  retry the ioctl to split and zap the full range. However, if it becomes
  problematic, further modifications to invoke kvm_unmap_gfn_range() after
  executing kvm_mmu_invalidate_range_add() and kvm_split_boundary_leafs()
  for all GFN ranges could address the problem.
  
  Alternatively, a possible solution could be pre-allocating sufficiently
  large splitting caches at the start of the private-to-shared conversion
  or hole punch process. The downside is that this may allocate more memory
  than necessary and require more code changes.

- The full call stack for huge page splitting

  With exclusive kvm->mmu_lock,
  kvm_vm_set_mem_attributes/kvm_gmem_punch_hole
     |kvm_split_boundary_leafs
     |   |kvm_tdp_mmu_gfn_range_split_boundary
     |       |tdp_mmu_split_boundary_leafs
     |           |tdp_mmu_alloc_sp_for_split
     |           |tdp_mmu_split_huge_page
     |               |tdp_mmu_link_sp
     |                   |tdp_mmu_iter_set_spte
     |                       |tdp_mmu_set_spte
     |                           |split_external_spt
     |                               |kvm_x86_split_external_spt
     |                                   | BLOCK, TRACK, DEMOTION
     |kvm_mmu_unmap_gfn_range

 
  With shared kvm->mmu_lock,
  kvm_tdp_mmu_map
     |tdp_mmu_alloc_sp
     |kvm_mmu_alloc_external_spt
     |tdp_mmu_split_huge_page
         |tdp_mmu_link_sp
             |tdp_mmu_set_spte_atomic
                 |__tdp_mmu_set_spte_atomic
		    |set_external_spte_present
		        |split_external_spt
			    |kvm_x86_split_external_spt


- Handle busy & errors

  Splitting huge mappings in S-EPT requires to execute
  tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
  tdh_mem_page_demote() in sequence.

  Possible errors during the process include TDX_OPERAND_BUSY or
  TDX_INTERRUPTED_RESTARTABLE.

  With exclusive kvm->mmu_lock, TDX_OPERAND_BUSY can be handled similarly
  to removing a private page, i.e., by kicking off all vCPUs and retrying,
  which should succeed on the second attempt.
  
  TDX_INTERRUPTED_RESTARTABLE occurs when there is a pending interrupt on
  the host side during SEAMCALL tdh_mem_page_demote(). The approach is to
  retry indefinitely in KVM for TDX_INTERRUPTED_RESTARTABLE, because the
  interrupts are for host only in current exclusive kvm->mmu_lock path.

  
Page merging (page promotion)
-----------------------------
  The RFC disallows the page merging on the mirror page table.

  Unlike normal VMs, private memory in TDX requires the guest's ACCEPT
  operation. Therefore, transitioning from a non-leaf entry to a huge leaf
  entry in the S-EPT requires the non-leaf entry to be initially populated
  with small child entries, all in PENDING or ACCEPTED status.
  Subsequently, the merged huge leaf can be set to either PENDING or
  ACCEPTED status.
  
  Therefore, counter-intuitively, converting a partial range (e.g., one
  4KB) of a 2MB range from private to shared and then converting back to
  private does not result in a successful page promotion in the S-EPT.
  After converting a shared 4KB page back to private:
  a) Linux Guest: Accepts the 4K page prior to accessing memory, prompting
     KVM to map it at the 4KB level, which prevents further EPT violations
     and avoids triggering page promotion.
  b) Non-Linux Guest: May access the page before executing the ACCEPT
     operation. KVM identifies the physical page is 2MB contiguous and maps
     it at 2MB, causing a non-leaf to leaf transition in the mirror page
     table. However, after the preparation step, only 511 child entries in
     the S-EPT are in ACCEPTED status, with 1 newly mapped entry in PENDING
     status. The promotion request to the S-EPT fails due to this mixed
     status. If KVM re-enters the guest and triggers #VE for the guest to
     accept the page, the guest must accept the page at the 4KB level, as
     no 2MB mapping is available. After the ACCEPT operation, no further
     EPT violations occur to trigger page promotion.

  
  So, also to avoid the comprehensive BUSY handling and rolling back code
  due to shared kvm->mmu_lock, the RFC disallows the page merging on the
  mirror page table. This should have minimal performance impact in
  practice, as up to now no page merging is observed for a real guest,
  except for the selftests.
 

Patches layout
==============
Patch 01: Glue code to [2].
          It allows kvm_gmem_populate() and kvm_gmem_get_pfn() to get a
          2MB private huge page from guest_memfd whenever GFN/index
          alignment, remaining size, and page attribute layout.
          Though this patch may not be needed after guest_memfd supporting
          in-place conversion in future, the guest_memfd needs to ensure
          something similar.
Patches 02-03: SEAMCALL changes under x86/virt.
Patches 04-09: Basic private huge page mapping/unmapping.
           04: For build time, no huge pages, forced to 4KB.
        05-07: Enhancements of tdx_clear_page(),tdx_reclaim_page,
               tdx_wbinvd_page() to handle huge pages.
           08: inc/dec folio ref count for huge pages.
               The increasing of private folio ref count should be dropped
               after guest_memfd supporting in-place conversion. TDX will
               then only acquire private folio ref count upon errors during
               the page removing/reclaiming stage.
           09: Turn on mapping/unmapping of huge pages for TD runtime.
Patch 10: Disallow page merging in the mirror page table.
Patches 11-12: Allow guest's ACCEPT level to determine page mapping size. 
Patches 13-19: Basic page splitting support (with exclusive kvm->mmu_lock)
           13: Enhance tdp_mmu_alloc_sp_split() for external page table
           14: Add code to propagate splitting request to external page
               table in tdp_mmu_set_spte(), which updates SPTE under
               exclusive kvm->mmu_lock.
           15: TDX's counter part to patch 14. Implementation of hook
               split_external_spt.
        16-19: Split private huge pages for private-to-shared conversion
               and punch hole.
Patches 20-21: Ignore page splitting request with shared kvm->mmu_lock


Main changes to [0]:
===================
- Disallow huge mappings in TD build time.
- Use hook private_max_mapping_level to convey TDX's mapping level info
  instead of having KVM MMU core to check certain bits in error_code to
  determine a fault's max_level.
- Move tdh_mem_range_block() for page splitting to TDX's implementation of
  hook split_external_spt.
- Do page splitting before tdp_mmu_zap_leafs(). So instead of BUG_ON() the
  tdp_mmu_zap_leafs(), out-of-memory failure for splitting can fail the
  ioctl KVM_SET_MEMORY_ATTRIBUTES or punch hole.
- Restrict page splitting to be under exclusive kvm->mmu_lock and ignore
  the page splitting under shared kvm->mmu_lock.
- Drop page merging support.


Testing
-------
The series is based on kvm/next.

This patchset is also available at: [3]
It is able to launch TDs with page demotion working correctly. Though it's
still unable to trigger page promotion with a linux guest yet, the part of
page promotion code is tested working with a selftest.

It's able to check huge mapping count in KVM at runtime at
/sys/kernel/debug/kvm/pages_2m.
(Though this node includes huge mapping count for both shared and private
memory, currently there're not many shared huge pages. In future,
guest_memfd in-place conversion requires all shared pages to be 4KB. So
there's no need to expand this interface).

[0] https://lore.kernel.org/all/cover.1708933624.git.isaku.yamahata@intel.com
[1] https://lore.kernel.org/lkml/cover.1726009989.git.ackerleytng@google.com
[2] https://lore.kernel.org/all/20241212063635.712877-1-michael.roth@amd.com
[3] https://github.com/intel/tdx/tree/huge_page_kvm_next_2025_04_23


Edgecombe, Rick P (1):
  KVM: x86/mmu: Disallow page merging (huge page adjustment) for mirror
    root

Isaku Yamahata (1):
  KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table
    splitting

Xiaoyao Li (5):
  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()
  KVM: TDX: Enhance tdx_clear_page() to support huge pages
  KVM: TDX: Assert the reclaimed pages were mapped as expected
  KVM: TDX: Add a helper for WBINVD on huge pages with TD's keyID
  KVM: TDX: Support huge page splitting with exclusive kvm->mmu_lock

Yan Zhao (14):
  KVM: gmem: Allocate 2M huge page from guest_memfd backend
  x86/virt/tdx: Enhance tdh_mem_page_aug() to support huge pages
  KVM: TDX: Enforce 4KB mapping level during TD build Time
  KVM: TDX: Increase/decrease folio ref for huge pages
  KVM: TDX: Enable 2MB mapping size after TD is RUNNABLE
  KVM: x86: Add "vcpu" "gfn" parameters to x86 hook
    private_max_mapping_level
  KVM: TDX: Determine max mapping level according to vCPU's ACCEPT level
  KVM: x86/tdp_mmu: Invoke split_external_spt hook with exclusive
    mmu_lock
  KVM: x86/mmu: Introduce kvm_split_boundary_leafs() to split boundary
    leafs
  KVM: Change the return type of gfn_handler_t() from bool to int
  KVM: x86: Split huge boundary leafs before private to shared
    conversion
  KVM: gmem: Split huge boundary leafs for punch hole of private memory
  KVM: x86: Force a prefetch fault's max mapping level to 4KB for TDX
  KVM: x86: Ignore splitting huge pages in fault path for TDX

 arch/arm64/kvm/mmu.c               |   4 +-
 arch/loongarch/kvm/mmu.c           |   4 +-
 arch/mips/kvm/mmu.c                |   4 +-
 arch/powerpc/kvm/book3s.c          |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c   |   4 +-
 arch/riscv/kvm/mmu.c               |   4 +-
 arch/x86/include/asm/kvm-x86-ops.h |   1 +
 arch/x86/include/asm/kvm_host.h    |   7 +-
 arch/x86/include/asm/tdx.h         |   2 +
 arch/x86/kvm/mmu/mmu.c             |  67 +++++---
 arch/x86/kvm/mmu/mmu_internal.h    |   2 +-
 arch/x86/kvm/mmu/paging_tmpl.h     |   2 +-
 arch/x86/kvm/mmu/tdp_mmu.c         | 200 +++++++++++++++++++----
 arch/x86/kvm/mmu/tdp_mmu.h         |   1 +
 arch/x86/kvm/svm/sev.c             |   5 +-
 arch/x86/kvm/svm/svm.h             |   5 +-
 arch/x86/kvm/vmx/main.c            |   8 +-
 arch/x86/kvm/vmx/tdx.c             | 244 +++++++++++++++++++++++------
 arch/x86/kvm/vmx/tdx.h             |   4 +
 arch/x86/kvm/vmx/tdx_arch.h        |   3 +
 arch/x86/kvm/vmx/tdx_errno.h       |   1 +
 arch/x86/kvm/vmx/x86_ops.h         |  14 +-
 arch/x86/virt/vmx/tdx/tdx.c        |  31 +++-
 arch/x86/virt/vmx/tdx/tdx.h        |   1 +
 include/linux/kvm_host.h           |  13 +-
 virt/kvm/guest_memfd.c             | 183 ++++++++++------------
 virt/kvm/kvm_main.c                |  38 +++--
 27 files changed, 612 insertions(+), 244 deletions(-)

-- 
2.43.2


