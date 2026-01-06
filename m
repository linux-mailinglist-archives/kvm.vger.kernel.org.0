Return-Path: <kvm+bounces-67108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1533CCF7C33
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BE6BE30386B3
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A903246FE;
	Tue,  6 Jan 2026 10:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DRLYO0xt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90DB12DF152;
	Tue,  6 Jan 2026 10:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694743; cv=none; b=ns3OwSRdORy1ZNI+AD4nNKwMmhIzVb+DxPxg4eS0+cOPniCPaLN14LYO7GmvsMtHOE8nlIrUmxDYROiIrqiF0CQslF3Wt297TYWXBY99zCMdBbWPnMpNgUdHEVK9d7edTteqiTLXVgN9dMMLM+OrViwYTSbuY3/DKYawu1OtH9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694743; c=relaxed/simple;
	bh=lbBLCAvP8yBQKcsfv+Wpgvs0F4uKdWCmBOOY8EvXjco=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=mgimn++Le+p3aXV6lpsUdYHW8uq+Znn38nU0qVbg4vxmQaaRJTfB2GDAU9lmxA3EV+U5rojeH4fenYO7tofR6LkD13PhL2NEeVoZMFBhYSIlwP8P/1CGTBqxl2/iXReGbZEFl+kDf88NlnwSQlxpzewrThN41kw8zAiZD2yzUPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DRLYO0xt; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694740; x=1799230740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lbBLCAvP8yBQKcsfv+Wpgvs0F4uKdWCmBOOY8EvXjco=;
  b=DRLYO0xt1riA/i11I0IeoEzG3XDSrTGD0doVdgDHSCxUnuud1zXdYbee
   RKU8LhHDQfdTyG+dvIyvkIDR6z2wneR5j8idOp5cVZz1ukP3lSZcNoeM0
   jzVTbAIejLiscBw+mEc0IYc5sTqhBvLBSJappYKGcZLEChuGuwxLIMT5W
   AuhdA8TxJvOon9+LqJutNs2MbMYTodSiHWMMwfWBdEz2lGF0eYUnpNy3U
   AnR1STToEF3kNlLtwj+MfEksHMIyVmcPO9/MGqoB5FdphSBDdH9+yr/su
   tD8RZTKzBfr2Ivxq2L6ZNVKE+S5DRjrmDOiKzmorwb0GBa6BuNp10+mia
   Q==;
X-CSE-ConnectionGUID: uEWk9nU8TZqoJPm+DzGwbQ==
X-CSE-MsgGUID: K8c4RlFmR0+0xJTvM5tHlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80176595"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80176595"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:19:00 -0800
X-CSE-ConnectionGUID: NUN6vpvOQtCIq3MA1VtjLg==
X-CSE-MsgGUID: AxfZRJkTQt+PFXLBTrbiBg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202869501"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:18:53 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 00/24] KVM: TDX huge page support for private memory
Date: Tue,  6 Jan 2026 18:16:42 +0800
Message-ID: <20260106101646.24809-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is v3 of the TDX huge page series. There aren’t any major changes to
the design, just the incorporation of various comments of RFC v2 [0] and
switching to use external cache for splitting to align with changes in
DPAMT v4 [3]. The full stack is available at [4].

Dave/Kirill/Rick/x86 folks, the patches that will eventually need an ack
are patches 1-5. I would appreciate some review on them, with the
understanding that they may need further refinement before they're ready
for ack.
 
Sean, I'm feeling pretty good about the design at this point, however,
there are few remaining design opens (see next section with references to
specific patches). I'm wondering if we can close these as part of the
review of this revision. Thanks a lot!


Highlight
-------------
- Request review of the tip part (patches 1-5)

  Patches 1-5 contain SEAMCALL wrappers updates, which are under tip.
  Besides introducing a SEAMCALL wrapper for demote, the other changes are
  mainly to convert mapping/unmapping related SEAMCALL wrappers from using
  "struct page *page" to "struct folio *folio" and "unsigned long
  start_idx" for huge pages.

- EPT mapping size and folio size

  This series is built upon the rule in KVM that the mapping size in the
  KVM-managed secondary MMU is no larger than the backend folio size.
  
  Therefore, there are sanity checks in the SEAMCALL wrappers in patches
  1-5 to follow this rule, either in tdh_mem_page_aug() for mapping
  (patch 1) or in tdh_phymem_page_wbinvd_hkid() (patch 3),
  tdx_quirk_reset_folio() (patch 4), tdh_phymem_page_reclaim() (patch 5)
  for unmapping.

  However, as Vishal pointed out in [7], the new hugetlb-based guest_memfd
  [1] splits backend folios ahead of notifying KVM for unmapping. So, this
  series also relies on the fixup patch [8] to notify KVM of unmapping
  before splitting the backend folio during the memory conversion ioctl.


- Enable TDX huge pages only on new TDX modules (patch 2, patch 24)

  This v3 detects whether the TDX module supports feature
  TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY and disables TDX huge
  page support for private memory on TDX modules without this feature.

  Additionally, v3 provides a new module parameter "tdx_huge_page" to turn
  off TDX huge pages for private memory by executing
  "modprobe kvm_intel tdx_huge_page=N".

- Dynamic PAMT v4 integration (patches 17-23)

  Currently, DPAMT's involvement with TDX huge pages is limited to page
  splitting. v3 introduces KVM x86 ops for the per-VM external cache for
  splitting (patches 19, 20).

  The per-VM external cache holds pre-allocated pages (patch 19), which are
  dequeued during TDX's splitting operations for installing PAMT pages
  (patches 21-22).

  The general logic of managing the per-VM external cache remains similar
  to the per-VM cache in RFC v2; the difference is that KVM MMU core now
  notifies TDX to implement page pre-allocation/enqueuing, page count
  checking, and page freeing. The external way makes it easier to add a
  lock to protect page enqueuing (in topup_external_per_vm_split_cache()
  op) and page dequeuing (in the split_external_spte() op) for the per-VM
  cache. (See more details in the DPAMT bullet in the "Full Design"
  section).

  Since the basic DPAMT design (without huge pages) is not yet settled,
  feel free to ignore the reviewing request for this part. However, we
  would appreciate some level of review given the differences between the
  per-VM cache and per-vCPU cache.


Changes from RFC v2
-------------------
- Dropped 2 patches:
  "KVM: TDX: Do not hold page refcount on private guest pages"
  (pulled by Sean separately),

  "x86/virt/tdx: Do not perform cache flushes unless CLFLUSH_BEFORE_ALLOC
   is set"
   (To be consistent with the always-clflush policy.
    The DPAMT-related bug in TDH.PHYMEM.PAGE.WBINVD only existed in the
    old unreleased TDX modules for DPAMT).

- TDX_INTERRUPTED_RESTARTABLE error handling:
  Disable TDX huge pages if the TDX module does not support
  TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY.

- Added a module parameter to turn on/off TDX huge pages.

- Renamed tdx_sept_split_private_spt() to tdx_sept_split_private_spte(),
  passing parameter "old_mirror_spte" instead of "pfn_for_gfn". Updated the
  function implementation to align with Sean's TDX cleanup series.

- Updated API kvm_split_cross_boundary_leafs() to not flush TLBs internally
  or return split/flush status, and added a default implementation for
  non-x86 platforms.

- Renamed tdx_check_accept_level() to tdx_honor_guest_accept_level().
  Returned tdx_honor_guest_accept_level() error to userspace instead of
  retry in KVM.

- Introduced KVM x86 ops for the per-VM external cache for splitting to
  align with DPAMT v4, re-organized the DPAMT related patches, refined
  parameter names for better readability, and added missing KVM_BUG_ON()
  and warnings.

- Changed nth_page() to folio_page() in SEAMCALL wrappers, corrected a
  minor bug in handling reclaimed size mismatch error.

- Removed unnecessary declarations, fixed typos and improved patch logs and
  comments.


Patches Layout
--------------
- Patches 01-05: Update SEAMCALL wrappers/helpers for huge pages.

- Patch 06:      Disallow page merging for TDX.

- Patches 07-09: Enable KVM MMU core to propagate splitting requests to TDX
                 and provide the corresponding implementation in TDX.

- Patches 10-11: Introduce a higher level API
                 kvm_split_cross_boundary_leafs() for splitting
                 cross-boundary mappings.

- Patches 12-13: Honor guest accept level in EPT violation handler.

- Patches 14-16: Split huge pages on page conversion/punch hole.

- Patches 17-23: Dynamic PAMT related changes for TDX huge pages.

- Patch 24:      Turn on 2MB huge pages if tdx_huge_page is true.
                 (Added a module parameter for tdx_huge_page and turn it
                 off if the TDX module does not support
                 TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY).


Full Design (optional reading)
--------------------------------------
1. guest_memfd dependency

   According to the rule in KVM that the mapping size in the KVM-managed
   secondary MMU should not exceed the backend folio size, the TDX huge
   page series relies on guest_memfd's ability to allocate huge folios.

   However, this series does not depend on guest_memfd's implementation
   details, except for patch 16, which invokes API
   kvm_split_cross_boundary_leafs() to request KVM splitting of private
   huge mappings that cross the specified range boundary in guest_memfd
   punch hole and private-to-shared conversion ioctls.

   Therefore, the TDX huge page series can also function with 2MB THP
   guest_memfd by updating patch 16 to match the underlying guest_memfd.

2. Restrictions:
   1) Splitting under read mmu_lock is not supported.

      With the current TDX module (i.e., without NON-BLOCKING-RESIZE
      feature), handling BUSY errors returned from splitting operations
      under read mmu_lock requires invoking tdh_mem_range_unblock(), which
      may also encounter BUSY errors. To avoid complicating the lock
      design, splitting under read mmu_lock for TDX is rejected before the
      TDX module supports the NON-BLOCKING-RESIZE feature.

      However, when TDs perform ACCEPT operations at 4KB level after KVM
      creates huge mappings (e.g., non-Linux TDs' ACCEPT operations that
      occur after memory access, or Linux TDs' ACCEPT operations on a
      pre-faulted range), splitting operations in the fault path are
      required, which usually hold read mmu_lock. 

      Ignoring splitting operations in the fault path would cause repeated
      faults. Forcing KVM's mapping to 4KB before the guest's ACCEPT level
      is available would disable huge pages for non-Linux TDs, since the
      TD's later ACCEPT operations at higher levels would return
      TDX_PAGE_SIZE_MISMATCH error to the guest. (See "ACCEPT level and
      lpage_info" bullet).

      This series hold write mmu_lock for splitting operations in the fault
      path. To maintain performance, the implementation only acquires write
      mmu_lock when necessary, keeping the write mmu_lock acquisition count
      at an acceptable level [6].

   2) No huge page if TDX_INTERRUPTED_RESTARTABLE error is possible

      When SEAMCALL TDH_MEM_PAGE_DEMOTE can return error
      TDX_INTERRUPTED_RESTARTABLE (due to interrupts during SEAMCALL
      execution), the TDX module provides no guaranteed maximum retry count
      to ensure forward progress of page demotion. Interrupt storms could
      then result in DoS if host simply retries endlessly for
      TDX_INTERRUPTED_RESTARTABLE. Disabling interrupts before invoking the
      SEAMCALL in the host cannot prevent TDX_INTERRUPTED_RESTARTABLE
      because NMIs can also trigger the error. Therefore, given that
      SEAMCALL execution time for demotion in basic TDX remains at a
      reasonable level, the tradeoff is to have the TDX module not check
      interrupts during SEAMCALL TDH_MEM_PAGE_DEMOTE, eliminating the
      TDX_INTERRUPTED_RESTARTABLE error.
 
      This series detects whether the TDX module supports feature
      TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY and disables TDX huge
      pages on private memory for TDX modules without this feature, thus
      avoiding TDX_INTERRUPTED_RESTARTABLE error for basic TDX (i.e.,
      without TD partition).

3. Page size is forced to 4KB during TD build time.

   Always return 4KB in the KVM x86 hook gmem_max_mapping_level() to force
   4KB mapping size during TD build time, because:

   - tdh_mem_page_add() only adds private pages at 4KB.
   - The amount of initial private memory pages is limited (typically ~4MB).

4. Page size during TD runtime can be up to 2MB.

   Return up to 2MB in the KVM x86 hook gmem_max_mapping_level():
   Use module parameter "tdx_huge_page" to control whether to return 2MB,
   and turn off tdx_huge_page if the TDX module does not support
   TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY.

   When returning 2MB in KVM x86 hook gmem_max_mapping_level(), KVM may
   still map a page at 4KB due to:
   (1) the backend folio is 4KB,
   (2) disallow_lpage restrictions:
       - mixed private/shared pages in the 2MB range,
       - level misalignment due to slot base_gfn, slot size, and ugfn,
       - GUEST_INHIBIT bit set due to guest ACCEPT operation.
   (3) page merging is disallowed (e.g., when part of a 2MB range has been
       mapped at 4KB level during TD build time).

5. ACCEPT level and lpage_info

   KVM needs to honor TDX guest's ACCEPT level by ensuring a fault's
   mapping level is no higher than the guest's ACCEPT level, which is due
   to the current TDX module implementation:
   - If host mapping level > guest's ACCEPT level, repeated faults carrying
     the guest's ACCEPT level info are generated. No error is returned to
     the guest's ACCEPT operation.
   - If host mapping level < guest's ACCEPT level, the guest's ACCEPT
     operation returns TDX_PAGE_SIZE_MISMATCH error.

   It's efficient to pass the guest's ACCEPT level info to KVM MMU core
   before KVM actually creates the mapping.

   Following the suggestions from Sean/Rick, this series introduces a
   global approach (vs. fault-by-fault per-vCPU) to pass the ACCEPT level
   info: setting the GUEST_INHIBIT bit in a slot's lpage_info(s) above the
   specified guest ACCEPT level. The global approach helps simplify vendor
   code while maintaining a global view across vCPUs. 
   
   Since page merging is currently not supported, and given the limitation
   that page splitting under read mmu_lock is not supported, the
   GUEST_INHIBIT bit is set in a one-way manner under write mmu_lock. Once
   set, it will not be unset, and the GFN will not be allowed to be mapped
   at higher levels, even if the mappings are zapped and re-accepted by the
   guest at higher levels later. This approach simplifies the code and
   prevents potential subtle bugs from different ACCEPT levels specified by
   different vCPUs. Tests showed the one-way manner has minimal impact on
   the huge page map count with a typical Linux TD [5].

   Typical scenarios of honoring 4KB ACCEPT level:
   a. If the guest accesses private memory without first accepting it,
      1) Guest accesses private memory.
      2) KVM maps the private memory at 2MB if no huge page restrictions
         exist.
      3) Guest accepts the private memory at 4KB.
      4) KVM receives an EPT violation VMExit, whose type indicates it's
         caused by the guest's ACCEPT operation at 4KB level.
      5) KVM honors the guest's ACCEPT level by setting the GUEST_INHIBIT
         bit in lpage_info(s) above 4KB level and splitting the created 2MB
         mapping.
      6) Guest accepts the private memory at 4KB level successfully and
         accesses the private memory.

   b. If the guest first accepts private memory before accessing,
      1) Guest accepts private memory at 4KB level.
      2) KVM receives an EPT violation VMExit, whose type indicates it's
         caused by guest's ACCEPT operation at 4KB level.
      3) KVM honors the guest's ACCEPT level by setting the GUEST_INHIBIT
         bit in lpage_info(s) above 4KB level, thus creating the mapping at
         4KB level.
      4) Guest accepts the private memory at 4KB level successfully and
         accesses the private memory.

6. Page splitting (page demotion)

   With the current TDX module, splitting huge mappings in S-EPT requires
   executing tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
   and tdh_mem_page_demote() in sequence. If DPAMT is involved,
   tdh_phymem_pamt_add() is also required.

   Page splitting can occur due to:
   (1) private-to-shared conversion,
   (2) hole punching in guest_memfd,
   (3) guest's ACCEPT operation at lower level than host mapping level.

   All paths trigger splitting by invoking kvm_split_cross_boundary_leafs()
   under write mmu_lock.

   TDX_OPERAND_BUSY is thus handled similarly to removing a private page,
   i.e., by kicking off all vCPUs and retrying, which should succeed on the
   second attempt. Other errors from tdh_mem_page_demote() are not
   expected, triggering TDX_BUG_ON().

7. Page merging (page promotion)

   Promotion is disallowed, because:

   - The current TDX module requires all 4KB leafs to be either all PENDING
     or all ACCEPTED before a successful promotion to 2MB. This requirement
     prevents successful page merging after partially converting a 2MB
     range from private to shared and then back to private, which is the
     primary scenario necessitating page promotion.

   - tdh_mem_page_promote() depends on tdh_mem_range_block() in the current
     TDX module. Consequently, handling BUSY errors is complex, as page
     merging typically occurs in the fault path under shared mmu_lock.

   - Limited amount of initial private memory (typically ~4MB) means the
     need for page merging during TD build time is minimal.

8. Precise zapping of private memory

   Since TDX requires guest's ACCEPT operation on host's mapping of private
   memory, zapping private memory for guest_memfd punch hole and
   private-to-shared conversion must be precise and preceded by splitting
   private memory.

   Patch 16 serves this purpose and is the only patch in the TDX huge page
   series sensitive to guest_memfd's implementation changes.

9. DPAMT
   Currently, DPAMT's involvement with TDX huge page is limited to page
   splitting.

   As shown in the following call stack, DPAMT pages used by splitting are
   pre-allocated and queued in the per-VM external split cache. They are
   dequeued and consumed in tdx_sept_split_private_spte().

   kvm_split_cross_boundary_leafs
     kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs
       tdp_mmu_split_huge_pages_root
 (*)      1) tdp_mmu_alloc_sp_for_split()
  +-----2.1) need_topup_external_split_cache(): check if enough pages in
  |          the external split cache. Go to 3 if pages are enough.
  |  +--2.2) topup_external_split_cache(): preallocate/enqueue pages in
  |  |       the external split cache.
  |  |    3) tdp_mmu_split_huge_page
  |  |         tdp_mmu_link_sp
  |  |           tdp_mmu_iter_set_spte
  |  |(**)         tdp_mmu_set_spte
  |  |               split_external_spte 
  |  |                 kvm_x86_call(split_external_spte)
  |  |                   tdx_sept_split_private_spte
  |  |                   3.1) BLOCK, TRACK
  +--+-------------------3.2) Dequeue PAMT pages from the external split
  |  |                        cache for the new sept page
  |  |                   3.3) PAMT_ADD for the new sept page
  +--+-------------------3.4) Dequeue PAMT pages from the external split
                              cache for the 2MB guest private memory.
                         3.5) DEMOTE.
                         3.6) Update PAMT refcount of the 2MB guest private
                              memory.

   (*) The write mmu_lock is held across the checking of enough pages in
       cache in step 2.1 and the page dequeuing in steps 3.2 and 3.4, so
       it's ensured that dequeuing has enough pages in cache.

  (**) A spinlock prealloc_split_cache_lock is used inside the TDX's cache
       implementation to protect page enqueuing in step 2.2 and page
       dequeuing in steps 3.2 and 3.4.


10. TDX does not hold page ref count

   TDX previously held folio refcount and didn't release the refcount if it
   failed to zap the S-EPT. However, guest_memfd's in-place conversion
   feature requires TDX not to hold folio refcount. Several approaches were
   explored. RFC v2 finally simply avoided holding page refcount in TDX and
   generated KVM_BUG_ON() on S-EPT zapping failure without propagating the
   failure back to guest_memfd or notifying guest_memfd through out-of-band
   methods, considering the complexity and that S-EPT zapping failure is
   currently only possible due to KVM or TDX module bugs.

   This approach was acked by Sean and the patch to drop holding TDX page
   refcount was pulled separately.


Base
----
This is based on the latest WIP hugetlb-based guest_memfd code [1], with
"Rework preparation/population" series v2 [2] and DPAMT v4 [3] rebased on
it. For the full stack see [4].

Four issues are identified in the WIP hugetlb-based guest_memfd [1]:

(1) Compilation error due to missing symbol export of
    hugetlb_restructuring_free_folio().

(2) guest_memfd splits backend folios when the folio is still mapped as
    huge in KVM (which breaks KVM's basic assumption that EPT mapping size
    should not exceed the backend folio size).

(3) guest_memfd is incapable of merging folios to huge for
    shared-to-private conversions.

(4) Unnecessary disabling huge private mappings when HVA is not 2M-aligned,
    given that shared pages can only be mapped at 4KB.

So, this series also depends on the four fixup patches included in [4]:

[FIXUP] KVM: guest_memfd: Allow gmem slot lpage even with non-aligned uaddr
[FIXUP] KVM: guest_memfd: Allow merging folios after to-private conversion
[FIXUP] KVM: guest_memfd: Zap mappings before splitting backend folios
[FIXUP] mm: hugetlb_restructuring: Export hugetlb_restructuring_free_folio()

(lkp sent me some more gmem compilation errors. I ignored them as I didn't
 encounter them with my config and env).


Testing
-------
We currently don't have a QEMU that works with the latest in-place
conversion uABI. We plan to increase testing before asking for merging.
This revision is tested via TDX selftests (enhanced to support the in-place
conversion uABI).

Please check the TDX selftests included in tree [4] (under section "Not for
upstream"[9]) that work with the in-place conversion uABI, specifically the
selftest tdx_vm_huge_page for huge page testing.

These selftests require running under "modprobe kvm vm_memory_attributes=N".

The 2MB mapping count can be checked via "/sys/kernel/debug/kvm/pages_2m".

Note #1: Since TDX does not yet enable in-place copy of init memory
         regions, userspace needs to follow the sequence below for init
	 memory regions to work (also shown in commit "KVM: selftests: TDX:
	 Switch init mem to gmem with MMAP flag" [10] in tree [4]):

         1) Create guest_memfd with MMAP flag for the init memory region.
         2) Set the GFNs for the init memory region to shared and copy
	    initial data to the mmap'ed HVA of the guest_memfd.
         3) Create a separate temporary shared memory backend for the init
	    memory region, and copy initial data from the guest_memfd HVA
	    to the temporary shared memory backend.
         4) Convert the GFNs for the init memory region to private.
         5) Invoke ioctl KVM_TDX_INIT_MEM_REGION, passing the HVA of the
	    temporary shared memory backend as source addr and GPAs of the
	    init memory region.
         6) Free the temporary shared memory backend.

Note #2: This series disables TDX huge pages on TDX modules without feature
         TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY. For testing TDX
         huge pages on those unsupported TDX modules (i.e., before
         TDX_1.5.28.00.972), please cherry-pick the workaround patch
         "x86/virt/tdx: Loop for TDX_INTERRUPTED_RESTARTABLE in
         tdh_mem_page_demote()" [11] contained in [4].

Thanks
Yan

[0] RFC v2: https://lore.kernel.org/all/20250807093950.4395-1-yan.y.zhao@intel.com
[1] hugetlb-based gmem: https://github.com/googleprodkernel/linux-cc/tree/wip-gmem-conversions-hugetlb-restructuring-12-08-25
[2] gmem-population rework v2: https://lore.kernel.org/all/20251215153411.3613928-1-michael.roth@amd.com
[3] DPAMT v4: https://lore.kernel.org/kvm/20251121005125.417831-1-rick.p.edgecombe@intel.com
[4] kernel full stack: https://github.com/intel-staging/tdx/tree/huge_page_v3
[5] https://lore.kernel.org/all/aF0Kg8FcHVMvsqSo@yzhao56-desk.sh.intel.com
[6] https://lore.kernel.org/all/aGSoDnODoG2%2FpbYn@yzhao56-desk.sh.intel.com
[7] https://lore.kernel.org/all/CAGtprH9vdpAGDNtzje=7faHBQc9qTSF2fUEGcbCkfJehFuP-rw@mail.gmail.com
[8] https://github.com/intel-staging/tdx/commit/a8aedac2df44e29247773db3444bc65f7100daa1
[9] https://github.com/intel-staging/tdx/commit/8747667feb0b37daabcaee7132c398f9e62a6edd
[10] https://github.com/intel-staging/tdx/commit/ab29a85ec2072393ab268e231c97f07833853d0d
[11] https://github.com/intel-staging/tdx/commit/4feb6bf371f3a747b71fc9f4ded25261e66b8895

Edgecombe, Rick P (1):
  KVM: x86/mmu: Disallow page merging (huge page adjustment) for mirror
    root

Isaku Yamahata (1):
  KVM: x86/tdp_mmu: Alloc external_spt page for mirror page table
    splitting

Kiryl Shutsemau (4):
  KVM: TDX: Get/Put DPAMT page pair only when mapping size is 4KB
  KVM: TDX: Add/Remove DPAMT pages for the new S-EPT page for splitting
  x86/tdx: Add/Remove DPAMT pages for guest private memory to demote
  x86/tdx: Pass guest memory's PFN info to demote for updating
    pamt_refcount

Xiaoyao Li (1):
  x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()

Yan Zhao (17):
  x86/tdx: Enhance tdh_mem_page_aug() to support huge pages
  x86/tdx: Enhance tdh_phymem_page_wbinvd_hkid() to invalidate huge
    pages
  x86/tdx: Introduce tdx_quirk_reset_folio() to reset private huge pages
  x86/virt/tdx: Enhance tdh_phymem_page_reclaim() to support huge pages
  KVM: x86/tdp_mmu: Introduce split_external_spte() under write mmu_lock
  KVM: TDX: Enable huge page splitting under write mmu_lock
  KVM: x86: Reject splitting huge pages under shared mmu_lock in TDX
  KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
  KVM: x86: Introduce hugepage_set_guest_inhibit()
  KVM: TDX: Honor the guest's accept level contained in an EPT violation
  KVM: Change the return type of gfn_handler_t() from bool to int
  KVM: x86: Split cross-boundary mirror leafs for
    KVM_SET_MEMORY_ATTRIBUTES
  KVM: guest_memfd: Split for punch hole and private-to-shared
    conversion
  x86/virt/tdx: Add loud warning when tdx_pamt_put() fails.
  KVM: x86: Introduce per-VM external cache for splitting
  KVM: TDX: Implement per-VM external cache for splitting in TDX
  KVM: TDX: Turn on PG_LEVEL_2M

 arch/arm64/kvm/mmu.c               |   8 +-
 arch/loongarch/kvm/mmu.c           |   8 +-
 arch/mips/kvm/mmu.c                |   6 +-
 arch/powerpc/kvm/book3s.c          |   4 +-
 arch/powerpc/kvm/e500_mmu_host.c   |   8 +-
 arch/riscv/kvm/mmu.c               |  12 +-
 arch/x86/include/asm/kvm-x86-ops.h |   4 +
 arch/x86/include/asm/kvm_host.h    |  22 +++
 arch/x86/include/asm/tdx.h         |  21 +-
 arch/x86/kvm/mmu.h                 |   3 +
 arch/x86/kvm/mmu/mmu.c             |  90 +++++++--
 arch/x86/kvm/mmu/tdp_mmu.c         | 204 +++++++++++++++++---
 arch/x86/kvm/mmu/tdp_mmu.h         |   3 +
 arch/x86/kvm/vmx/tdx.c             | 299 ++++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.h             |   5 +
 arch/x86/kvm/vmx/tdx_arch.h        |   3 +
 arch/x86/virt/vmx/tdx/tdx.c        | 164 +++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h        |   1 +
 include/linux/kvm_host.h           |  14 +-
 virt/kvm/guest_memfd.c             |  67 +++++++
 virt/kvm/kvm_main.c                |  44 +++--
 21 files changed, 851 insertions(+), 139 deletions(-)

-- 
2.43.2


