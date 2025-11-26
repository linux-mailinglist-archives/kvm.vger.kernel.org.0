Return-Path: <kvm+bounces-64759-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id EF96AC8C2A9
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:15:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A50124E0791
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:15:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A152D33BBD0;
	Wed, 26 Nov 2025 22:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GY5OUh2N"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1C7335553;
	Wed, 26 Nov 2025 22:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764195297; cv=none; b=kL4r+vd/Up3SMK0rx+Q0qAkVN5LFUCNptfajYAtIXMVaq0m3+OEWZEJkbeFLoFfWAKvituVsLa/K75IZuEYsE+QT/b6HAc+GJJBWwcGFYKwnEvkqJXWlRKdhy7dJ+rqMrFkgn5FVU2Jhw0++CDYYXZfuBEXq3QCCvQGsVOB1xT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764195297; c=relaxed/simple;
	bh=MAiaCUP0M6nxH1nX7OpP4kGemqQBUemDN/+yaZL/De4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpw0SHhYH051xjWYnV3bvFMsLJEEvrc5B2rvtGColSGwFApBFFyIU5Rqjj8TPCkdDyfFIt7tEmY5AYOmMchKFjdwms45Dj8R3V0wxxGSqdHCePeY7Hzz+k/WomKNIJDfWWaYdESqSOBjLWCVe0++iSw9GS+8CPBOb4ciUvQDqhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GY5OUh2N; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764195295; x=1795731295;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MAiaCUP0M6nxH1nX7OpP4kGemqQBUemDN/+yaZL/De4=;
  b=GY5OUh2Nj5BelTGqrPaQD2MrfnbRyfbqjtGLB/lACnzTqkxlcz5Uaypy
   B8aGhtGpDwifTsBBCdt4oVeYzgLGhIqC8FI2fqL9vSF62TyZNCayupmDv
   ve9+2XolkEleLoBWkP2A7zETZULr5gIaa+rW5d41z/upJ8jhJRp0cI9WJ
   Q16hs00gagve/8kXF4QJPsi7/ISrnf/cccc2rrcByp9xyYQm5D/hIlr/s
   50YX3e635rRywbq3IV6gRbvZQru8jmyJKK9M6TFX8w6fLkgBmS19K3ynM
   wjg1aUuuOoO+LHrVXxx7AKfGCs7aijpI9znt61awEvp5MLurVFb+YqMh6
   Q==;
X-CSE-ConnectionGUID: wJLkNaLPRLycVHkYXz5v8g==
X-CSE-MsgGUID: AtjQvt8IQ/O3JF6EXsd3rA==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="65246343"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="65246343"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:14:55 -0800
X-CSE-ConnectionGUID: UwEnRufgQyy85dRH8mC8QQ==
X-CSE-MsgGUID: VJli0MSNR3meFAKoeCplRw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="192965101"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:14:54 -0800
Date: Wed, 26 Nov 2025 14:14:54 -0800
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, David Kaplan <david.kaplan@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v5 1/9] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
Message-ID: <20251126-vmscape-bhb-v5-1-02d66e423b00@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126-vmscape-bhb-v5-0-02d66e423b00@linux.intel.com>

Currently, BHB clearing sequence is followed by an LFENCE to prevent
transient execution of subsequent indirect branches prematurely. However,
LFENCE barrier could be unnecessary in certain cases. For example, when
kernel is using BHI_DIS_S mitigation, and BHB clearing is only needed for
userspace. In such cases, LFENCE is redundant because ring transitions
would provide the necessary serialization.

Below is a quick recap of BHI mitigation options:

  On Alder Lake and newer

  - BHI_DIS_S: Hardware control to mitigate BHI in ring0. This has low
	       performance overhead.
  - Long loop: Alternatively, longer version of BHB clearing sequence
	       can be used to mitigate BHI. It can also be used to mitigate
	       BHI variant of VMSCAPE. This is not yet implemented in
	       Linux.

  On older CPUs

  - Short loop: Clears BHB at kernel entry and VMexit. The "Long loop" is
		effective on older CPUs as well, but should be avoided
		because of unnecessary overhead.

On Alder Lake and newer CPUs, eIBRS isolates the indirect targets between
guest and host. But when affected by the BHI variant of VMSCAPE, a guest's
branch history may still influence indirect branches in userspace. This
also means the big hammer IBPB could be replaced with a cheaper option that
clears the BHB at exit-to-userspace after a VMexit.

In preparation for adding the support for BHB sequence (without LFENCE) on
newer CPUs, move the LFENCE to the caller side after clear_bhb_loop() is
executed. This allows callers to decide whether they need the LFENCE or
not. This does adds a few extra bytes to the call sites, but it obviates
the need for multiple variants of clear_bhb_loop().

Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S            | 5 ++++-
 arch/x86/include/asm/nospec-branch.h | 4 ++--
 arch/x86/net/bpf_jit_comp.c          | 2 ++
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index ed04a968cc7d0095ab0185b2e3b5beffb7680afd..886f86790b4467347031bc27d3d761d5cc286da1 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1528,6 +1528,9 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * refactored in the future if needed. The .skips are for safety, to ensure
  * that all RETs are in the second half of a cacheline to mitigate Indirect
  * Target Selection, rather than taking the slowpath via its_return_thunk.
+ *
+ * Note, callers should use a speculation barrier like LFENCE immediately after
+ * a call to this function to ensure BHB is cleared before indirect branches.
  */
 SYM_FUNC_START(clear_bhb_loop)
 	ANNOTATE_NOENDBR
@@ -1562,7 +1565,7 @@ SYM_FUNC_START(clear_bhb_loop)
 	sub	$1, %ecx
 	jnz	1b
 .Lret2:	RET
-5:	lfence
+5:
 	pop	%rbp
 	RET
 SYM_FUNC_END(clear_bhb_loop)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 08ed5a2e46a5fd790bcb1b73feb6469518809c06..ec5ebf96dbb9e240f402f39efc6929ae45ec8f0b 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -329,11 +329,11 @@
 
 #ifdef CONFIG_X86_64
 .macro CLEAR_BRANCH_HISTORY
-	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_LOOP
+	ALTERNATIVE "", "call clear_bhb_loop; lfence", X86_FEATURE_CLEAR_BHB_LOOP
 .endm
 
 .macro CLEAR_BRANCH_HISTORY_VMEXIT
-	ALTERNATIVE "", "call clear_bhb_loop", X86_FEATURE_CLEAR_BHB_VMEXIT
+	ALTERNATIVE "", "call clear_bhb_loop; lfence", X86_FEATURE_CLEAR_BHB_VMEXIT
 .endm
 #else
 #define CLEAR_BRANCH_HISTORY
diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
index de5083cb1d3747bba00effca3703a4f6eea80d8d..c1ec14c559119b120edfac079aeb07948e9844b8 100644
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1603,6 +1603,8 @@ static int emit_spectre_bhb_barrier(u8 **pprog, u8 *ip,
 
 		if (emit_call(&prog, func, ip))
 			return -EINVAL;
+		/* Don't speculate past this until BHB is cleared */
+		EMIT_LFENCE();
 		EMIT1(0x59); /* pop rcx */
 		EMIT1(0x58); /* pop rax */
 	}

-- 
2.34.1



