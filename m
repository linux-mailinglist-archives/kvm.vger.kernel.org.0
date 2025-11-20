Return-Path: <kvm+bounces-63771-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A2D38C72506
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 07:18:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id D7A28352727
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 06:18:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A01629AAF3;
	Thu, 20 Nov 2025 06:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YVY5ehVi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80E0A283151;
	Thu, 20 Nov 2025 06:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763619471; cv=none; b=BewRGTqwcDul+kXnaIcQa5AIA7daQ2OBK8ZwycgYXj6ET5UEr67goNCaMu+W5qoBP7HL1OAMGgaCL7Vg2tIlmm1vKuB6I+XDoQAszE0J7s8JbosKg5tVjUP13Dv+I5nppWAaSt5q/awXfkvWBQAsuMSAZfFPrNXIYEeEQRj67kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763619471; c=relaxed/simple;
	bh=Bq9uE0LWCAWuIY6dFFtwrMkiyxhP5MnJZ7cOjR088Ao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eC4VzACoC4W3fg32IDWbikOSQgyjXY3AX6hNr3uo8E6vLhwVTLeTPq1iBQ4RH/oXZOA1fMxptgWEpTreSH5v5AKU30eryF+VbCPQ5YrxW1rBRxP9dbSKMlg3RJ9QUsYp5sr6dqiWJ3cjuHd2Gm7ygM/ygFE5Ar4ymw0MwZpyJgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YVY5ehVi; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763619470; x=1795155470;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bq9uE0LWCAWuIY6dFFtwrMkiyxhP5MnJZ7cOjR088Ao=;
  b=YVY5ehVizW3IBHeJ/cwh4PfZd03j3Z0oLmtng0BQXhfQtBONVBg3KS3G
   CK6BMkCLioiXMBWEMzrqSw872Xf5zUwZ66XMZtwqWQAeFDhJ1j/iXSt0z
   mBND0l+ecFEfoCwJmsNEJtDeG/CBo1jBArDQvUwyQTCUZcHHPnr15s+pK
   2eAopL31kMN/edlqGqKAZ3ZbotNCjGzq13kO7jqxAOSGmJ7VurBsMCjxT
   ApUBushXvGpkLvrOTvfzWpZDcj1eXfLaoynz8S4PTLqylLI4KxMdNP7Ob
   Uuunx/Ir+gbsHncBmp1CkZj21O5HhBxItLcbTVv3PPAMEMm+HVqBKYUAJ
   A==;
X-CSE-ConnectionGUID: dGYmPGVARp+FXtRZ2TA0IQ==
X-CSE-MsgGUID: v9aYB4YSTsGh0Rq9Eq6FWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="65713253"
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="65713253"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:17:49 -0800
X-CSE-ConnectionGUID: v/8w2HgWQNSNBmj5Z1j4vg==
X-CSE-MsgGUID: yvVAI3aGTSKak+treGmMNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,317,1754982000"; 
   d="scan'208";a="191700467"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2025 22:17:48 -0800
Date: Wed, 19 Nov 2025 22:17:48 -0800
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
Subject: [PATCH v4 01/11] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
Message-ID: <20251119-vmscape-bhb-v4-1-1adad4e69ddc@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119-vmscape-bhb-v4-0-1adad4e69ddc@linux.intel.com>

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
	       on older processors can be used to mitigate BHI. This
	       is not yet implemented in Linux.

  On older CPUs

  - Short loop: Clears BHB at kernel entry and VMexit.

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



