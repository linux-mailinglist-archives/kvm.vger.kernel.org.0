Return-Path: <kvm+bounces-55699-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B94F9B34F67
	for <lists+kvm@lfdr.de>; Tue, 26 Aug 2025 00:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A74AF1B25E98
	for <lists+kvm@lfdr.de>; Mon, 25 Aug 2025 22:59:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE2E62C0F8A;
	Mon, 25 Aug 2025 22:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gI4b/afn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46B523ABB3;
	Mon, 25 Aug 2025 22:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756162742; cv=none; b=loSj+WFdfuTwL30yvvYcuPRcOb7BBytSihg3ST1wO3+JnJL0TygTKU64kCE0Hh1c2Zg2rtDAOz4SFHYkP7E/flPLmMTrUIDTzyL1DRVRSoTEsnSNNQssL2g+mHHu5guEVv/3rQEkx2fOs9bSSzhBXOqmMLcv42QsY0M6pZOzb7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756162742; c=relaxed/simple;
	bh=b6T6bW/JXgPsV/L1zimW/SBrfTer5kjENuXcSgcYIGg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HEj8xJtfBUoj7m0WO26WtRlKiluN86C4Ks4S/I3eqkF56gAa4bXYSrU0LAKksiWAPoHpB74PGNSEitsMjTwzB200rxpCyEHYEbvGOrycl8dWh3sI08PEzAvkDU9Gy+pn7G8iH466VPIFFytBZdmfwzSvcUx+IV70cGSkt4sk29M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gI4b/afn; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756162740; x=1787698740;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=b6T6bW/JXgPsV/L1zimW/SBrfTer5kjENuXcSgcYIGg=;
  b=gI4b/afnpTgdaJNgHkBwxlbI+PPJL8qbsRAgtozgR7EopYqNkU8cTY7p
   obXKtV0TQsYGPbsQX4PKPMZ+v1zgMWsdahFIDMWEqh7UQIrTvolSCM3aB
   EZhXcwEfGcOq+mk+iry80DJyyQor8hs70Hkt7NZCIXHb9/aGOaUgC6pIr
   FWef/QPPwrhycW2M8leZLNJsE65Wx0yi7iVFQJnWBqIoEly2F24xQiJVr
   WIAZbITmyjSj6KS/aF3/3TFEKf84+LLOUj+8zy4h4f2Ae6VdsBcp6aNka
   R7/jQRobA11+4vaXYXLcvlyr2x1iwG4Jgt+y2oc685yd7DqiSdxXd10Ur
   A==;
X-CSE-ConnectionGUID: zYP52N/0QtiVbxsBg/T5bQ==
X-CSE-MsgGUID: zUP7/wvXTlGx/xWsftkawg==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="58533307"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="58533307"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:58:59 -0700
X-CSE-ConnectionGUID: niHmS9ZsS4Kw8Fc5xoxXKw==
X-CSE-MsgGUID: Fq1mgdRQTIqDf1q3mvDC5Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="200308347"
Received: from ldmartin-desk2.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.223.59])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2025 15:58:53 -0700
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
Subject: [PATCH v7 0/7] TDX host: kexec/kdump support
Date: Tue, 26 Aug 2025 10:58:35 +1200
Message-ID: <cover.1756161460.git.kai.huang@intel.com>
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
kexec.  It allows the TDX host and the kexec/kdump to be turned on
together in the Kconfig, and enables kexec/kdump on most of the TDX
platforms (except SPR and EMR due to a TDX erratum).

Hi Dave,

Now the first two patches have Boris/Tom's Reviewed-by.  TDX patches
also received RBs from Rick and TDX developers.  The last KVM patch also
has Paolo's Acked-by.  Since last version only the last KVM patch has
minor updates (to address comments from Sean).  Could you help to review
this series, and if looks good to you, consider merging?

Btw, we also considered removing the last patch since previously we
hadn't met the "kexec-ing time race" [*].  I did more tests on more TDX
machines last week.  I still didn't see any kexec failure but I saw the
chance of meeting this race was getting higher on a GNR machine with 256
CPUs (I saw NMIs were needed to stop remote CPUs during kexec).  So to
be safe, we think we should keep the last patch.

[*] native_stop_other_cpus() firstly sends normal REBOOT vector IPIs to
remote CPUs and waits for them to stop.  When that times out, it sends
NMIs to the still-alive CPUs and waits them to stop.  The race _may_
happen when NMIs are needed albeit the chance is rare.  While we haven't
ever seen it in the real world, patch 7 should close any theoretical
widening of the race by TDX.

v6 -> v7: 
 - Address comments from Sean/Paolo for last patch (see it for details).
 - Collect Boris's Reviewed-by. (Thanks!)
 - Regenerate this series based on tip/x86/tdx.

v6: https://lore.kernel.org/kvm/cover.1755126788.git.kai.huang@intel.com/

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
 arch/x86/include/asm/tdx.h           | 26 +++++++++++++++-
 arch/x86/kernel/cpu/amd.c            | 17 +++++++++++
 arch/x86/kernel/machine_kexec_64.c   | 44 ++++++++++++++++++++++------
 arch/x86/kernel/process.c            | 24 +++++++--------
 arch/x86/kernel/relocate_kernel_64.S | 36 +++++++++++++++--------
 arch/x86/kvm/vmx/tdx.c               | 12 ++++++++
 arch/x86/virt/vmx/tdx/tdx.c          | 16 ++++++++--
 11 files changed, 157 insertions(+), 47 deletions(-)


base-commit: 01fb93a363e0583a3ce48098aca5ab9825a5b790
-- 
2.50.1


