Return-Path: <kvm+bounces-65073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 57673C9A37B
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 07:19:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DBE73A611C
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 06:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4B43009CA;
	Tue,  2 Dec 2025 06:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CgFUlZ2o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569762F6189;
	Tue,  2 Dec 2025 06:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764656343; cv=none; b=j5ztdP1ttHwWpGeCDBeGsjF0qQIrNJh3XSgKG6rTU9ujziMN04W9aN3jusEACvnNrhilAbxpITr6hnqoUj6eRBgHPHXkovOyOYB+CL90FMBipKS3t1VA5OzuJVHtXuwWDCbXUnLp1203qpMMjflUiXyW/yrbQJXY0A6tfVgF2EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764656343; c=relaxed/simple;
	bh=MAiaCUP0M6nxH1nX7OpP4kGemqQBUemDN/+yaZL/De4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Af+vrHHPBeZuiC8X01ABRtfNDAO/QIZLJjlS6k0jqtQWkQ8m9LJiRkzCyQfuuk8gIB4Ox2aUClDGnhMi19uF3RzoDRkQE14IQoTxUwETjmiyGXXlWJoTRLKYoQouj79IR+Sj9rgAkqp3J08s8VDf88BCjs30kLsCOFVVvIm6W6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CgFUlZ2o; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764656341; x=1796192341;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MAiaCUP0M6nxH1nX7OpP4kGemqQBUemDN/+yaZL/De4=;
  b=CgFUlZ2oOL1lXV6vfweOFVINbD6lnuzBWW/i0PODidyM6yU9m1gTdHCG
   bQi81kdGN/g36TDmg1wle9Ff/R1+UfAqVKafDhYd+CcNa9g4iV39yfRBh
   4AEwCksIYV5TwzUpZmjGw+VlCp+9XJp3b1/LCBKV4EuBtBfBRH70XGqPM
   klOeZdcOBav8Iyf2Qy1AOzMf9aH8QJhcI6eTHkP6VRfhUxRjyq7+w8Rtl
   iIcLjysd8R80ffxn1iLDwXXd8oJBiOWr04OzFhAQ0iRxKqs6y93veHR+l
   sEBeQ/bW8JnZaWbzyg2Amp3SLXG5fjGX3YUkgJhTFL7fsgnGh6UG0N8we
   Q==;
X-CSE-ConnectionGUID: pYliuFrzTAOfGVkYR8dmMA==
X-CSE-MsgGUID: 2dKwKJRMTiOY1T0VqeNIZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11630"; a="66499076"
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="66499076"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:00 -0800
X-CSE-ConnectionGUID: Z2Mp99fQRveriU5jv5ea0A==
X-CSE-MsgGUID: cZcILv9ES4upYDXuyouDiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,242,1758610800"; 
   d="scan'208";a="194276801"
Received: from guptapa-desk.jf.intel.com (HELO desk) ([10.165.239.46])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 22:19:00 -0800
Date: Mon, 1 Dec 2025 22:18:59 -0800
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
Subject: [PATCH v6 1/9] x86/bhi: x86/vmscape: Move LFENCE out of
 clear_bhb_loop()
Message-ID: <20251201-vmscape-bhb-v6-1-d610dd515714@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201-vmscape-bhb-v6-0-d610dd515714@linux.intel.com>

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



