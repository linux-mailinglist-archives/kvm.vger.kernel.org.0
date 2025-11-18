Return-Path: <kvm+bounces-63602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CA33C6BDD0
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:28:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 973A24EA53B
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:26:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F93E311588;
	Tue, 18 Nov 2025 22:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ko6ePUq3"
X-Original-To: kvm@vger.kernel.org
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A1F30FF27
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504767; cv=none; b=brt2ncq47VYCQbIF61/B3AvxZspMvNXUECR0aVkACNZoAcoag5oQHZ+cgtdlWC7drdRPjdjn8HECN3udfptvaizqhd/tYqF7FtIGcsZvx2wUHZluAJWGbXFqCcSpqBMYQVu5O+QuM7bqf5EI6+gZBo/sg+Nk9yTziL+KArNQWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504767; c=relaxed/simple;
	bh=alNgAGPvUNBhPxs8YkcGDHtoFORtX4BmEf5MMsOuSbY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qU8sZL2EN/Vl5RuAfrb1qp3J9PkGUVmETp1hNkavPaJFPaFuN1/nzDvo4yx3XIPA9PQ1U55AZk9JiKYvb0fcq77V+H/UTSIWq6ui8frUlRamHG12x1MmZg1merrMPo9HqqhG4NuXNMcLbhwMwTcFRd12sSqm/gJzBoEX1DubBRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ko6ePUq3; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 18 Nov 2025 22:25:40 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763504751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=B+jRD8r/6yuvVVSUWkL8O+XOv4tLyvq+g+/BE2dB56E=;
	b=Ko6ePUq3sDjB6n7ffm1q29+s2QTLhGlYx3IskImAv/lREVjBX9usNTYb6EQaHOoSJK/rzE
	J08oR4EaAb94q/F26/ImBE2Tmw+hGKFE9Sfkr098NIw9obXKpXDC8ktP4xrNPTchBBesNS
	Pw+G892+KOIEXUS7RYAe9oMml3jLDTA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/23] Extend test coverage for nested SVM
Message-ID: <n5cjwr3klovu7tqcchptvmr6yieyhvnv5muv7zyvcbo5itskew@6rzo4ohctdhv>
References: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021074736.1324328-1-yosry.ahmed@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Tue, Oct 21, 2025 at 07:47:13AM +0000, Yosry Ahmed wrote:
> There are multiple selftests exercising nested VMX that are not specific
> to VMX (at least not anymore). Extend their coverage to nested SVM.
> 
> This version is significantly different (and longer) than v1 [1], mainly
> due to the change of direction to reuse __virt_pg_map() for nested EPT/NPT
> mappings instead of extending the existing nested EPT infrastructure. It
> also has a lot more fixups and cleanups.
> 
> This series depends on two other series:
> - "KVM: SVM: GIF and EFER.SVME are independent" [2]
> - "KVM: selftests: Add test of SET_NESTED_STATE with 48-bit L2 on 57-bit L1" [3]

v2 of Jim's series switches all tests to use 57-bit by default when
available:
https://lore.kernel.org/kvm/20251028225827.2269128-4-jmattson@google.com/

This breaks moving nested EPT mappings to use __virt_pg_map() because
nested EPTs are hardcoded to use 4-level paging, while __virt_pg_map()
will assume we're using 5-level paging.

Patch #16 ("KVM: selftests: Use __virt_pg_map() for nested EPTs") will
need the following diff to make nested EPTs use the same paging level as
the guest:

diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 358143bf8dd0d..8bacb74c00053 100644
--- a/tools/testing/selftests/kvm/lib/x86/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86/vmx.c
@@ -203,7 +203,7 @@ static inline void init_vmcs_control_fields(struct vmx_pages *vmx)
                uint64_t ept_paddr;
                struct eptPageTablePointer eptp = {
                        .memory_type = X86_MEMTYPE_WB,
-                       .page_walk_length = 3, /* + 1 */
+                       .page_walk_length = get_cr4() & X86_CR4_LA57 ? 4 : 3, /* + 1 */
                        .ad_enabled = ept_vpid_cap_supported(VMX_EPT_VPID_CAP_AD_BITS),
                        .address = vmx->eptp_gpa >> PAGE_SHIFT_4K,
                };


Which will conflict at patch #17, and should end up looking like this:

	uint64_t eptp = vmx->eptp_gpa | EPTP_WB;

	eptp |= get_cr4() & X86_CR4_LA57 ? EPTP_PWL_5 : EPTP_PWL_4;

Sean, let me know if you prefer that I rebase this series on top of
Jim's v2 and resend, or if you'll fix it up while applying.

> 
> The dependency on the former is because set_nested_state_test is now
> also a regression test for that fix. The dependency on the latter is
> purely to avoid conflicts.
> 
> The patch ordering is not perfect, I did some cleanups toward the end
> that arguably should have been moved to the beginning, but I had to stop
> rebasing and send the patches out at some point:
> 
> Block #1 (patch 1 to patch 7):
> - Direct successors to the first 6 patches in v1, addressing review
>   comments from Jim and collecting his review tags. These patch extend 5
>   of the nVMX tests to cover nSVM.
> 
> Block #2 (patch 8 to patch 11):
> - Miscellaneous fixups and cleanups.
> 
> Block #3 (patch 11 to patch 17):
> - Moving nested EPT mapping functions to use __virt_pg_map(), patches 11
>   to 15 do the prep work, and patch 16 does the switch. Patch 17 is a
>   minor cleanup on top (which arguably fits better in block #2).
> 
> Block #4 (patch 18 to 23):
> - Patches 18 to 22 are prep work to generalize the nested EPT mapping
>   code to work with nested NPT, and patch 23 finally extends the nested
>   dirty logging test to work with nSVM using the nested NPT
>   infrastructure. Patch 19 is admittedly an imposter in this block and
>   should have been in block #2.
> 
> [1]https://lore.kernel.org/kvm/20251001145816.1414855-1-yosry.ahmed@linux.dev/
> [2]https://lore.kernel.org/kvm/20251009223153.3344555-1-jmattson@google.com/
> [3]https://lore.kernel.org/kvm/20250917215031.2567566-1-jmattson@google.com/
> 
> Yosry Ahmed (23):
>   KVM: selftests: Minor improvements to asserts in
>     test_vmx_nested_state()
>   KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
>   KVM: selftests: Extend vmx_close_while_nested_test to cover SVM
>   KVM: selftests: Extend vmx_nested_tsc_scaling_test to cover SVM
>   KVM: selftests: Move nested invalid CR3 check to its own test
>   KVM: selftests: Extend nested_invalid_cr3_test to cover SVM
>   KVM: selftests: Extend vmx_tsc_adjust_test to cover SVM
>   KVM: selftests: Stop hardcoding PAGE_SIZE in x86 selftests
>   KVM: selftests: Remove the unused argument to prepare_eptp()
>   KVM: selftests: Stop using __virt_pg_map() directly in tests
>   KVM: selftests: Make sure vm->vpages_mapped is always up-to-date
>   KVM: selftests: Parameterize the PTE bitmasks for virt mapping
>     functions
>   KVM: selftests: Pass the root GPA into virt_get_pte()
>   KVM: selftests: Pass the root GPA into __virt_pg_map()
>   KVM: selftests: Stop setting AD bits on nested EPTs on creation
>   KVM: selftests: Use __virt_pg_map() for nested EPTs
>   KVM: selftests: Kill eptPageTablePointer
>   KVM: selftests: Generalize nested mapping functions
>   KVM: selftests: Move nested MMU mapping functions outside of vmx.c
>   KVM: selftests: Stop passing a memslot to nested_map_memslot()
>   KVM: selftests: Allow kvm_cpu_has_ept() to be called on AMD CPUs
>   KVM: selftests: Set the user bit on nested MMU PTEs
>   KVM: selftests: Extend vmx_dirty_log_test to cover SVM
> 
>  tools/testing/selftests/kvm/Makefile.kvm      |  11 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |   1 +
>  .../selftests/kvm/include/x86/processor.h     |  34 ++-
>  .../selftests/kvm/include/x86/svm_util.h      |   8 +
>  tools/testing/selftests/kvm/include/x86/vmx.h |  15 +-
>  tools/testing/selftests/kvm/lib/kvm_util.c    |   3 -
>  .../testing/selftests/kvm/lib/x86/memstress.c |   6 +-
>  .../testing/selftests/kvm/lib/x86/processor.c | 184 +++++++++++---
>  tools/testing/selftests/kvm/lib/x86/svm.c     |  19 ++
>  tools/testing/selftests/kvm/lib/x86/vmx.c     | 232 +++---------------
>  tools/testing/selftests/kvm/mmu_stress_test.c |   6 +-
>  ...ested_test.c => close_while_nested_test.c} |  42 +++-
>  .../selftests/kvm/x86/hyperv_features.c       |   2 +-
>  tools/testing/selftests/kvm/x86/hyperv_ipi.c  |  18 +-
>  .../selftests/kvm/x86/hyperv_tlb_flush.c      |   2 +-
>  ...rty_log_test.c => nested_dirty_log_test.c} | 102 +++++---
>  .../kvm/x86/nested_invalid_cr3_test.c         | 118 +++++++++
>  ...adjust_test.c => nested_tsc_adjust_test.c} |  79 +++---
>  ...aling_test.c => nested_tsc_scaling_test.c} |  48 +++-
>  ...d_state_test.c => set_nested_state_test.c} | 135 +++++++++-
>  .../selftests/kvm/x86/sev_smoke_test.c        |   2 +-
>  tools/testing/selftests/kvm/x86/state_test.c  |   2 +-
>  .../selftests/kvm/x86/userspace_io_test.c     |   2 +-
>  23 files changed, 695 insertions(+), 376 deletions(-)
>  rename tools/testing/selftests/kvm/x86/{vmx_close_while_nested_test.c => close_while_nested_test.c} (64%)
>  rename tools/testing/selftests/kvm/x86/{vmx_dirty_log_test.c => nested_dirty_log_test.c} (57%)
>  create mode 100644 tools/testing/selftests/kvm/x86/nested_invalid_cr3_test.c
>  rename tools/testing/selftests/kvm/x86/{vmx_tsc_adjust_test.c => nested_tsc_adjust_test.c} (61%)
>  rename tools/testing/selftests/kvm/x86/{vmx_nested_tsc_scaling_test.c => nested_tsc_scaling_test.c} (83%)
>  rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c => set_nested_state_test.c} (67%)
> 
> -- 
> 2.51.0.869.ge66316f041-goog
> 

