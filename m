Return-Path: <kvm+bounces-64028-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D007C76CDD
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:52:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id DB1A028A51
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:51:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD41275B18;
	Fri, 21 Nov 2025 00:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VT2pE56V"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A57C1EEE6;
	Fri, 21 Nov 2025 00:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686303; cv=none; b=r6ajDMBkR0aMFeTrKrLiZhNBcHFAAuJGBBl7tYVd5UIOSuLmJaZVdhvp393VGTjMX4IWY02sj/Dnvrx6x1gMJKR5L28sqZ6ki32Fh7dmh9rgF7Di+ZCMIALttC7XG0BKq6vopxMuxtEyicpCp/xzHI1i+I37fFWrdMrnqWqoXyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686303; c=relaxed/simple;
	bh=g1wy0vRd3bkKbK6J2KNFmkL+aCW2Fjm6xnn10vnyoXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=NUhwsJeRPTKLd033RHUYdNT/IoZYc2o9RwsMOWFyt+8x/dK980CYD0XQDtuODS+9g+8am6jgvdqUyKp3NlPiHZrBv677ZziVYcBvZ8Rnsf7PDELONtcHwqca0Dj2xsrylYGbjyNIjhBMXGy81LMWSdGHoWLNVgBgJDeIgwD/vUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VT2pE56V; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686302; x=1795222302;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=g1wy0vRd3bkKbK6J2KNFmkL+aCW2Fjm6xnn10vnyoXQ=;
  b=VT2pE56VDV8lCvx2dm0fu/PZAlbwyT6XKUZ+8TNT6vEtUusJ1f+S5FTk
   T6PUcs+4FwtHfOupvgWzXi4pJu15V/tmW5aZJ9GB2Ga6aKxfIIFDLRn9a
   RTMFcd6SLqMVjZlOqAK+1eF04zHURyeCHiHsvixHdXUZ+apr/NWuTEdPr
   Hpwu1906OBYWjMDeWunxbkSSBmKkLCYKhpXLW4FqDElsnVCcWnuZCwvt8
   GckeZnd8pTY3ivi9BIhejLjhwV832SX/KAKUJ/4HUPYuu4gr4vUYBYzkF
   Y0Miars+j3mpspDeG6CsMqwKJxqy4LzBfLQMDoH+oA7hBWMl9VROlbTwx
   A==;
X-CSE-ConnectionGUID: jH6m2o2RQp2b8sVS9tKErw==
X-CSE-MsgGUID: uLK56HX7TMy6SBMkJbCxYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780714"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780714"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:41 -0800
X-CSE-ConnectionGUID: AYf5drVFSdavg3SXUQgCzA==
X-CSE-MsgGUID: tLId5LiEQiS5sNgMIM11jQ==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:41 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com
Subject: [PATCH v4 00/16] TDX: Enable Dynamic PAMT
Date: Thu, 20 Nov 2025 16:51:09 -0800
Message-ID: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi, 

This is 4th revision of Dynamic PAMT, which is a new feature that reduces 
the memory use of TDX. For background information, see the v3 
coverletter[0]. V4 mostly consists of incorporating the feedback from v3. 
Notably what it *doesn’t* change is the solution for pre-allocating DPAMT
backing pages. (more info below in “Changes”)

I think this series isn’t quite ready to ask for merging just yet. I’d 
appreciate another round of review especially looking for any issues in the
refcount allocation/mapping and the pamt get/put lock-refcount dance. And
hopefully collect some RBs.

Sean/Paolo, we have mostly banished this all to TDX code except for “KVM: 
TDX: Add x86 ops for external spt cache” patch. That and “x86/virt/tdx: 
Add helpers to allow for pre-allocating pages” are probably the remaining 
possibly controversial parts of your domain. If you only have a short time 
to spend at this point, I’d point you at those two patches.

Since most of the changes are in arch/x86, I’d think this feature could be
a candidate for eventually merging through tip with Sean or Paolo’s ack.
But it is currently based on kvm-x86/next in order to build on top of the 
post-populate cleanup series. Next time I’ll probably target tip if people 
think that is a good way forward.

Changes
=======
There were two good suggestions around the pre-allocated pages solution
last time, but neither ended up working out:

1. Dave suggested to use mempool_t instead of the linked list based 
structure, in order to not re-invent the wheel. This turned out to not 
quite fit. The problems were that there wasn’t really a “topup” mechanism, 
or an atomic fallback (which matches the kvm cache behavior). This results 
in very similar code being built around mempool that was built around the 
linked list. It was an overall harder to follow solution for not much code 
savings. 

I strongly considered going back to Kiryl’s original solution which passed 
a callback function pointer for allocating DPAMT pages, and an opaque
void * that the callback could use to find the kvm_mmu_memory_cache. I
thought that readability issues of passing the opaque void * between
subsystems outweighed the small code duplication in the simple, familiar
patterned linked list-based code. So I ended up leaving it. 

2. Kai suggested (but later retracted the idea) that since the external 
page table cache was moved to TDX code, it could simply install DPAMT 
pages for the cache at topup time. Then the installation of DPAMT backing 
for S-EPT page tables could be done outside of the mmu_lock. It could also 
be argued that it makes the design simpler in a way, because the external
page table cache acts like it did before. Anything in there could be simply
used. 

At the time my argument against this was that whether a huge page would be 
installed (and thus, whether DPAMT backing was needed) for the guest 
private memory would not be known until later, so early install solution
would need special late handling for TDX huge pages. After some internal
discussions I at looked how we could simplify the series by punting on TDX
huge pages needs. 

But it turns out that this other design was actually more complex and had 
more LOC than the previous solution. So it was dropped, and again, I went 
back to the original solution. 


I’m really starting to think that, while the overall solution here isn’t 
the most elegant, we might not have much more to squeeze from it. So 
design-wise, I think we should think about calling it done. 

Testing
=======
Based on kvm-x86/next (4531ff85d925). Testing was the usual, except I also 
tested with TDX modules that don't support DPAMT, and with the two 
optimization patches removed: “Improve PAMT refcounters allocation for 
sparse memory” and “x86/virt/tdx: Optimize tdx_alloc/free_page() helpers”.

[0] https://lore.kernel.org/kvm/20250918232224.2202592-1-rick.p.edgecombe@intel.com/ 


Kirill A. Shutemov (13):
  x86/tdx: Move all TDX error defines into <asm/shared/tdx_errno.h>
  x86/tdx: Add helpers to check return status codes
  x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
  x86/virt/tdx: Allocate reference counters for PAMT memory
  x86/virt/tdx: Improve PAMT refcounts allocation for sparse memory
  x86/virt/tdx: Add tdx_alloc/free_page() helpers
  x86/virt/tdx: Optimize tdx_alloc/free_page() helpers
  KVM: TDX: Allocate PAMT memory for TD control structures
  KVM: TDX: Allocate PAMT memory for vCPU control structures
  KVM: TDX: Handle PAMT allocation in fault path
  KVM: TDX: Reclaim PAMT memory
  x86/virt/tdx: Enable Dynamic PAMT
  Documentation/x86: Add documentation for TDX's Dynamic PAMT

Rick Edgecombe (3):
  x86/virt/tdx: Simplify tdmr_get_pamt_sz()
  KVM: TDX: Add x86 ops for external spt cache
  x86/virt/tdx: Add helpers to allow for pre-allocating pages

 Documentation/arch/x86/tdx.rst              |  21 +
 arch/x86/coco/tdx/tdx.c                     |  10 +-
 arch/x86/include/asm/kvm-x86-ops.h          |   3 +
 arch/x86/include/asm/kvm_host.h             |  14 +-
 arch/x86/include/asm/shared/tdx.h           |   8 +
 arch/x86/include/asm/shared/tdx_errno.h     | 104 ++++
 arch/x86/include/asm/tdx.h                  |  78 ++-
 arch/x86/include/asm/tdx_global_metadata.h  |   1 +
 arch/x86/kvm/mmu/mmu.c                      |   6 +-
 arch/x86/kvm/mmu/mmu_internal.h             |   2 +-
 arch/x86/kvm/vmx/tdx.c                      | 160 ++++--
 arch/x86/kvm/vmx/tdx.h                      |   3 +-
 arch/x86/kvm/vmx/tdx_errno.h                |  40 --
 arch/x86/virt/vmx/tdx/tdx.c                 | 587 +++++++++++++++++---
 arch/x86/virt/vmx/tdx/tdx.h                 |   5 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   7 +
 16 files changed, 854 insertions(+), 195 deletions(-)
 create mode 100644 arch/x86/include/asm/shared/tdx_errno.h
 delete mode 100644 arch/x86/kvm/vmx/tdx_errno.h

-- 
2.51.2


