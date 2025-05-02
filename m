Return-Path: <kvm+bounces-45218-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17161AA72E2
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:08:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7E9DD17035E
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:08:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B8AB2550A9;
	Fri,  2 May 2025 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="np6S0W3z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA41253F1F;
	Fri,  2 May 2025 13:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191322; cv=none; b=K4jkwAUhLy1+tmJzholRGToaAGWh3aHntphkyYj0iRHfHhWEKlax3scNevshtVMVq7UwHTY8tbC137SUFcWXvmAdCAtcqSNlqOIC/947lyikkNbM8Hc2RnNgH6HpTQAfiEvf3YlgzrlyRhQ/HQy48feIHLCpE16r3IztPybmn2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191322; c=relaxed/simple;
	bh=3P3mgQqRuiIbn0l8GHo+gg4HDaCnkHEQP/WXI0NTA/g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r7Q3m0TFgbc6T1zCXg7zvmasLTfpzv2RKjOSzQ9ltWlm6cF3ElwduIYcRf02jIrsQ1YeWPM6tn3eOv9VycxkvJ8q9S7vULDW3el8rpOYHYwu6ViLRC7DLSMx/myJCaz/DrQUb1ac+Y7j+6KzNa0kAxYboqnN48j72LzHWPi0naA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=np6S0W3z; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191321; x=1777727321;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3P3mgQqRuiIbn0l8GHo+gg4HDaCnkHEQP/WXI0NTA/g=;
  b=np6S0W3zjYh8HqTJsTEawqybhzIf4D6rqXpVJL9AoPO63Hvk4OpT0JLI
   Dgls6EKG0NodFsotj3Re8Bcg6DJEg3/cqWVt3iEdCvdt9uLHvL72ZwNhI
   QxH3h3dasvtZv9X4Vix1tjSmlfpf1pjbCjgkBpyFy6kdN1I4NOf/5OEfR
   soYunWcwzv1hd18jdmMWXkPdels2xgbdixQ+ExIKG4W5kdXpl2E46CveS
   GLTYQkmh7zaA4YMvsCkbUJpNg+U1B5ytWN1zWTU1D6ckHLSl4d33se6pH
   c5OnlT9/WC4OsmmRwji2YrSft1B7M4YImvBkJVHp83MxPtH6kKX7Z3qXr
   w==;
X-CSE-ConnectionGUID: VKe5QqxoQnmY93kZTksZxw==
X-CSE-MsgGUID: XYUVOJqjRSuFWs7x6ovjPQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="48012946"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="48012946"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:40 -0700
X-CSE-ConnectionGUID: emtkRdthSH6ZjRgLol11CQ==
X-CSE-MsgGUID: 5rtAlyF0Rzemi7YmI7Wz+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="157871060"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 02 May 2025 06:08:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id F247811C; Fri, 02 May 2025 16:08:35 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH 00/12] TDX: Enable Dynamic PAMT
Date: Fri,  2 May 2025 16:08:16 +0300
Message-ID: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This RFC patchset enables Dynamic PAMT in TDX. It is not intended to be
applied, but rather to receive early feedback on the feature design and
enabling.

From our perspective, this feature has a lower priority compared to huge
page support. I will rebase this patchset on top of Yan's huge page
enabling at a later time, as it requires additional work.

Any feedback is welcome. We are open to ideas.

=========================================================================

The Physical Address Metadata Table (PAMT) holds TDX metadata for
physical memory and must be allocated by the kernel during TDX module
initialization.

The exact size of the required PAMT memory is determined by the TDX
module and may vary between TDX module versions, but currently it is
approximately 0.4% of the system memory. This is a significant
commitment, especially if it is not known upfront whether the machine
will run any TDX guests.

The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
PAMT_2M levels are still allocated on TDX module initialization, but the
PAMT_4K level is allocated dynamically, reducing static allocations to
approximately 0.004% of the system memory.

PAMT memory is dynamically allocated as pages gain TDX protections.
It is reclaimed when TDX protections have been removed from all
pages in a contiguous area.

TODO:
  - Rebase on top of Yan's huge page support series. Demotion requires
    additional handling with Dynamic PAMT;
  - Get better vmalloc API from core-mm and simplify patch 02/12.

Kirill A. Shutemov (12):
  x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
  x86/virt/tdx: Allocate reference counters for PAMT memory
  x86/virt/tdx: Add wrappers for TDH.PHYMEM.PAMT.ADD/REMOVE
  x86/virt/tdx: Account PAMT memory and print if in /proc/meminfo
  KVM: TDX: Add tdx_pamt_get()/put() helpers
  KVM: TDX: Allocate PAMT memory in __tdx_td_init()
  KVM: TDX: Allocate PAMT memory in tdx_td_vcpu_init()
  KVM: x86/tdp_mmu: Add phys_prepare() and phys_cleanup() to kvm_x86_ops
  KVM: TDX: Preallocate PAMT pages to be used in page fault path
  KVM: TDX: Hookup phys_prepare() and phys_cleanup() kvm_x86_ops
  KVM: TDX: Reclaim PAMT memory
  x86/virt/tdx: Enable Dynamic PAMT

 arch/x86/include/asm/kvm-x86-ops.h          |   2 +
 arch/x86/include/asm/kvm_host.h             |   5 +
 arch/x86/include/asm/set_memory.h           |   2 +
 arch/x86/include/asm/tdx.h                  |  22 ++
 arch/x86/include/asm/tdx_global_metadata.h  |   1 +
 arch/x86/kvm/mmu/mmu.c                      |  10 +
 arch/x86/kvm/mmu/tdp_mmu.c                  |  47 ++++-
 arch/x86/kvm/vmx/main.c                     |   2 +
 arch/x86/kvm/vmx/tdx.c                      | 215 ++++++++++++++++++--
 arch/x86/kvm/vmx/tdx_errno.h                |   1 +
 arch/x86/kvm/vmx/x86_ops.h                  |   9 +
 arch/x86/mm/Makefile                        |   2 +
 arch/x86/mm/meminfo.c                       |  11 +
 arch/x86/mm/pat/set_memory.c                |   2 +-
 arch/x86/virt/vmx/tdx/tdx.c                 | 211 ++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx.h                 |   5 +-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |   3 +
 virt/kvm/kvm_main.c                         |   1 +
 18 files changed, 522 insertions(+), 29 deletions(-)
 create mode 100644 arch/x86/mm/meminfo.c

-- 
2.47.2


