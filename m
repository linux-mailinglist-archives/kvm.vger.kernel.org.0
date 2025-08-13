Return-Path: <kvm+bounces-54619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DBD3B257F1
	for <lists+kvm@lfdr.de>; Thu, 14 Aug 2025 01:59:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8CD1F1C84829
	for <lists+kvm@lfdr.de>; Wed, 13 Aug 2025 23:59:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A77E2FE07E;
	Wed, 13 Aug 2025 23:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZNTIf+re"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89CA2F60C8;
	Wed, 13 Aug 2025 23:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755129566; cv=none; b=b91sOsC0AqAuvo+4igv8l1T2NV8XpiXpXDXl3ZPhrCqalhvBSuuB4vNcBQCq/afgpDZLz0bIKrT/2x785xVsq0sU16IL0cuwccK6+Ql93dlrmQTKaQQJQi7w+o7wKqOoipATHDY6dvWGdlgHoEbyUg9OQnz821tjffB7EklhZyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755129566; c=relaxed/simple;
	bh=Qc1gLS+tjPXUuL+0jMShJDwXpCd/gI+//JyfmdgyoHU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d29npDye4ZWTdyx0c78UGvwDdPS5EpvBoVsKho9jN6tW9F1LvqwN3jEwSjmQomxF6SdaUGLydToE2dmheeByIFjrNGaBmoyrYsH3tVQvUbkZ3wzpqsmhW8s5+/2SxmF0iL9goMrCRvXHg2uOJVZ+2qwhoAoLnC2MtPzHVpY+j/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZNTIf+re; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755129564; x=1786665564;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Qc1gLS+tjPXUuL+0jMShJDwXpCd/gI+//JyfmdgyoHU=;
  b=ZNTIf+reCvaVOiydEBt02t7blByG5EV6rQlUuARbcnGTOscFSXmE3IGA
   AlwVi+xIDIgR5glyup0mvW7QhSelHBfIYPp79xUIjvR6L6juFYsQe6FcT
   tpdTjfuseirnFuE+xedwPr1wsjUQzmvRaRvXMKS7mCZ9mCaDuYHl0aojL
   0IbgGnLUDzTo4JGwtMz6m0CMDu+mySzVlISWFhGdpkbdAhipzDy8n5eaf
   XZaOY16wfvnz6P6LrDSTHU5TO4QmpdfysWivBfFsyrUirvXa07gDTXaFY
   46EV3RwbeY/MXLaEdygEmKK5avDGPg9IpP60hPRMh9/bJnn9VsMBddUEZ
   w==;
X-CSE-ConnectionGUID: CG38bXxPQ+6RBvooU2OVBA==
X-CSE-MsgGUID: Zo52T0L/QGWHmrO94iIJnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="80014640"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="80014640"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:24 -0700
X-CSE-ConnectionGUID: Z+TmnemgSFSGru3OmTL6qA==
X-CSE-MsgGUID: 6yUDdhqeSZ2xjTWbvyw+6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="166105019"
Received: from mgerlach-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.250])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 16:59:18 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	thomas.lendacky@amd.com
Cc: x86@kernel.org,
	kas@kernel.org,
	rick.p.edgecombe@intel.com,
	dwmw@amazon.co.uk,
	linux-kernel@vger.kernel.org,
	pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org,
	reinette.chatre@intel.com,
	isaku.yamahata@intel.com,
	dan.j.williams@intel.com,
	ashish.kalra@amd.com,
	nik.borisov@suse.com,
	chao.gao@intel.com,
	sagis@google.com,
	farrah.chen@intel.com
Subject: [PATCH v6 0/7] TDX host: kexec/kdump support
Date: Thu, 14 Aug 2025 11:59:00 +1200
Message-ID: <cover.1755126788.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series is the latest attempt to support kexec on TDX host following
Dave's suggestion to use a percpu boolean to control WBINVD during
kexec.

Hi Boris/Tom,

Thanks for your review on the first two patches.  Please let me know if
you have more comments.

Hi Dave,

Tom has provided Reviewed-by for the first two patches which change SME
code.  TDX patches also received RBs from multiple Intel TDX developers
(the last patch has Paolo's Acked-by too).  Could you help to review this
series, and if looks good to you, consider merging this series?

v5 -> v6:
 - Regenerate based on latest tip/master.
 - Rename do_seamcall() to __seamcall_dirty_cache() - Rick.
 - Collect Reviewed-by tags from Tom, Rick, Chao (thanks!).

v5: https://lore.kernel.org/kvm/cover.1753679792.git.kai.huang@intel.com/

v4 -> v5:
 - Address comments from Tom, Hpa and Chao (nothing major)
   - RELOC_KERNEL_HOST_MEM_ACTIVE -> RELOC_KERNEL_HOST_MEM_ENC_ACTIVE
     in patch 1 (Tom)
   - Add a comment to explain only RELOC_KERNEL_PRESERVE_CONTEXT is
     restored after jumping back from peer kernel for preserved_context
     kexec in patch 1.
   - Use testb instead of testq to save 3 bytes in patch 1 (Hpa)
   - Remove the unneeded 'ret' local variable in do_seamcall() (Chao)

v4: https://lore.kernel.org/kvm/cover.1752730040.git.kai.huang@intel.com/

v3 -> v4:
 - Rebase to latest tip/master.
 - Add a cleanup patch to consolidate relocate_kernel()'s last two
   function parameters -- Boris.
 - Address comments received -- please see individual patches.
 - Collect tags (Tom, Rick, binbin).

 v3: https://lore.kernel.org/kvm/cover.1750934177.git.kai.huang@intel.com/

(For more history please see v3 coverletter.)

=== More information ===

TDX private memory is memory that is encrypted with private Host Key IDs
(HKID).  If the kernel has ever enabled TDX, part of system memory
remains TDX private memory when kexec happens.  E.g., the PAMT (Physical
Address Metadata Table) pages used by the TDX module to track each TDX
memory page's state are never freed once the TDX module is initialized.
TDX guests also have guest private memory and secure-EPT pages.

After kexec, the new kernel will have no knowledge of which memory page
was used as TDX private page and can use all memory as regular memory.

1) Cache flush

Per TDX 1.5 base spec "8.6.1.Platforms not Using ACT: Required Cache
Flush and Initialization by the Host VMM", to support kexec for TDX, the
kernel needs to flush cache to make sure there's no dirty cachelines of
TDX private memory left over to the new kernel (when the TDX module
reports TDX_FEATURES.CLFLUSH_BEFORE_ALLOC as 1 in the global metadata for
the platform).  The kernel also needs to make sure there's no more TDX
activity (no SEAMCALL) after cache flush so that no new dirty cachelines
of TDX private memory are generated.

SME has similar requirement.  SME kexec support uses WBINVD to do the
cache flush.  WBINVD is able to flush cachelines associated with any
HKID.  Reuse the WBINVD introduced by SME to flush cache for TDX.

Currently the kernel explicitly checks whether the hardware supports SME
and only does WBINVD if true.  Instead of adding yet another TDX
specific check, this series uses a percpu boolean to indicate whether
WBINVD is needed on that CPU during kexec.

2) Reset TDX private memory using MOVDIR64B

The TDX spec (the aforementioned section) also suggests the kernel
*should* use MOVDIR64B to clear TDX private page before the kernel
reuses it as regular one.

However, in reality the situation can be more flexible.  Per TDX 1.5
base spec ("Table 16.2: Non-ACT Platforms Checks on Memory Reads in Ci
Mode" and "Table 16.3: Non-ACT Platforms Checks on Memory Reads in Li
Mode"), the read/write to TDX private memory using shared KeyID without
integrity check enabled will not poison the memory and cause machine
check.

Note on the platforms with ACT (Access Control Table), there's no
integrity check involved thus no machine check is possible to happen due
to memory read/write using different KeyIDs.

KeyID 0 (TME key) doesn't support integrity check.  This series chooses
to NOT reset TDX private memory but leave TDX private memory as-is to the
new kernel.  As mentioned above, in practice it is safe to do so.

3) One limitation

If the kernel has ever enabled TDX, after kexec the new kernel won't be
able to use TDX anymore.  This is because when the new kernel tries to
initialize TDX module it will fail on the first SEAMCALL due to the
module has already been initialized by the old kernel.

More (non-trivial) work will be needed for the new kernel to use TDX,
e.g., one solution is to just reload the TDX module from the location
where BIOS loads the TDX module (/boot/efi/EFI/TDX/).  This series
doesn't cover this, but leave this as future work.

4) Kdump support

This series also enables kdump with TDX, but no special handling is
needed for crash kexec (except turning on the Kconfig option):

 - kdump kernel uses reserved memory from the old kernel as system ram,
   and the old kernel will never use the reserved memory as TDX memory.
 - /proc/vmcore contains TDX private memory pages.  It's meaningless to
   read them, but it doesn't do any harm either.

5) TDX "partial write machine check" erratum

On the platform with TDX erratum, a partial write (a write transaction
of less than a cacheline lands at memory controller) to TDX private
memory poisons that memory, and a subsequent read triggers machine
check.  On those platforms, the kernel needs to reset TDX private memory
before jumping to the new kernel otherwise the new kernel may see
unexpected machine check.

The kernel currently doesn't track which page is TDX private memory.
It's not trivial to reset TDX private memory.  For simplicity, this
series simply disables kexec/kdump for such platforms.  This can be
enhanced in the future.


Kai Huang (7):
  x86/kexec: Consolidate relocate_kernel() function parameters
  x86/sme: Use percpu boolean to control WBINVD during kexec
  x86/virt/tdx: Mark memory cache state incoherent when making SEAMCALL
  x86/kexec: Disable kexec/kdump on platforms with TDX partial write
    erratum
  x86/virt/tdx: Remove the !KEXEC_CORE dependency
  x86/virt/tdx: Update the kexec section in the TDX documentation
  KVM: TDX: Explicitly do WBINVD when no more TDX SEAMCALLs

 Documentation/arch/x86/tdx.rst       | 14 ++++-----
 arch/x86/Kconfig                     |  1 -
 arch/x86/include/asm/kexec.h         | 12 ++++++--
 arch/x86/include/asm/processor.h     |  2 ++
 arch/x86/include/asm/tdx.h           | 27 ++++++++++++++++-
 arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
 arch/x86/kernel/machine_kexec_64.c   | 44 ++++++++++++++++++++++------
 arch/x86/kernel/process.c            | 24 +++++++--------
 arch/x86/kernel/relocate_kernel_64.S | 36 +++++++++++++++--------
 arch/x86/kvm/vmx/tdx.c               | 12 ++++++++
 arch/x86/virt/vmx/tdx/tdx.c          | 16 ++++++++--
 11 files changed, 158 insertions(+), 47 deletions(-)


base-commit: 4b6b14d20bc04dcab6dd3ad0d5a50a0f473d1c18
-- 
2.50.1


