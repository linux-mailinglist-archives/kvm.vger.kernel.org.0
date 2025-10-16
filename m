Return-Path: <kvm+bounces-60119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E0BBE130B
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 03:52:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34023189D558
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 01:52:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53ED51EDA26;
	Thu, 16 Oct 2025 01:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gJccbYhd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488E91D8DFB;
	Thu, 16 Oct 2025 01:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760579519; cv=none; b=j7+shuzhN6c1fy2d5y82AxCKRKAfgCUuflaatFlihG4kF5cFVJNU6n6DomMLSt/SaNKOryOEOD01kdTIj9vO2Wg7QGXyEMT3L2rl74OZQSPL0x98Gw0QRo+C4wqqgLURUd4qUm0ZUEhf025Vq5h06isobKRa23+nZbKyzds2sgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760579519; c=relaxed/simple;
	bh=WHMz5SG6W3N1B8H9QwVveY7DiuNYYtHq4k7vh7UJKR4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R3pPxjEM2Flg+FqLRFXhW3LtiqfrGcebCl5HYqiTCHmyBq+8Y7rYC5V3IjfiB+WZDs3DnMgWZfer1n3SOEkf7RYm0FAQdHAuFp1C/eBGL8EUHJA0P29uuxiYlk22gAhQlSczosrO9V59vTIorHrJv4VzW6gECt+B1A920TWKu78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gJccbYhd; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760579518; x=1792115518;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WHMz5SG6W3N1B8H9QwVveY7DiuNYYtHq4k7vh7UJKR4=;
  b=gJccbYhdsYRwcEGvNgYhJRnZKD+tEQLRCxJofxmcxYJYvjbLE+kKHI0U
   m+UvwFWogg/t8n80jwE8GPyJYlCIP5Fvacxz+MXGonxw3hxEKMt/1VNiM
   LWJlvvkJP/bvML5t1hA3y7fihJ2hTEOJ48BDrj0P1+VK58V7g/fKmeoax
   qlH2CSLifAJ2OFsTlmvHOXxLtV50LZJqi4soa5apxWEX12xaNUgjP/kMv
   Tr0ic0MfLRtajHvfELC82a2k0DTwz0kvEuxUzDE3X+7tSFOYzknNJwk4U
   5h8P74FzA0ZSXyGJtLcCQzUBSSFu7jQVCQ74wqWFwJNeIPGiP7NxL4CpX
   Q==;
X-CSE-ConnectionGUID: qd5hMo7RTX+wZMgCwD16cQ==
X-CSE-MsgGUID: aRh3+rXwRxe37x4tpSjuKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="85382932"
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="85382932"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 18:51:57 -0700
X-CSE-ConnectionGUID: xTpZhuYAR/uz4EC1rrFxwA==
X-CSE-MsgGUID: EUKuiRHFSbCLH+5YVo6Mgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,232,1754982000"; 
   d="scan'208";a="213279901"
Received: from dnelso2-mobl.amr.corp.intel.com (HELO desk) ([10.124.223.20])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 18:51:56 -0700
Date: Wed, 15 Oct 2025 18:51:55 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
	Asit Mallick <asit.k.mallick@intel.com>,
	Tao Zhang <tao1.zhang@intel.com>
Subject: [PATCH v2 1/3] x86/bhi: Add BHB clearing for CPUs with larger branch
 history
Message-ID: <20251015-vmscape-bhb-v2-1-91cbdd9c3a96@linux.intel.com>
X-Mailer: b4 0.14.2
References: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251015-vmscape-bhb-v2-0-91cbdd9c3a96@linux.intel.com>

Add a version of clear_bhb_loop() that works on CPUs with larger branch
history table such as Alder Lake and newer. This could serve as a cheaper
alternative to IBPB mitigation for VMSCAPE.

clear_bhb_loop() and the new clear_bhb_long_loop() only differ in the loop
counter. Convert the asm implementation of clear_bhb_loop() into a macro
that is used by both the variants, passing counter as an argument.

There is no difference in the output of:

  $ objdump --disassemble=clear_bhb_loop vmlinux

before and after this commit.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
---
 arch/x86/entry/entry_64.S            | 47 ++++++++++++++++++++++++++----------
 arch/x86/include/asm/nospec-branch.h |  3 +++
 2 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index ed04a968cc7d0095ab0185b2e3b5beffb7680afd..f5f62af080d8ec6fe81e4dbe78ce44d08e62aa59 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1499,11 +1499,6 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * from the branch history tracker in the Branch Predictor, therefore removing
  * user influence on subsequent BTB lookups.
  *
- * It should be used on parts prior to Alder Lake. Newer parts should use the
- * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
- * virtualized on newer hardware the VMM should protect against BHI attacks by
- * setting BHI_DIS_S for the guests.
- *
  * CALLs/RETs are necessary to prevent Loop Stream Detector(LSD) from engaging
  * and not clearing the branch history. The call tree looks like:
  *
@@ -1529,11 +1524,12 @@ SYM_CODE_END(rewind_stack_and_make_dead)
  * that all RETs are in the second half of a cacheline to mitigate Indirect
  * Target Selection, rather than taking the slowpath via its_return_thunk.
  */
-SYM_FUNC_START(clear_bhb_loop)
+.macro	__CLEAR_BHB_LOOP outer_loop_count:req, inner_loop_count:req
 	ANNOTATE_NOENDBR
 	push	%rbp
 	mov	%rsp, %rbp
-	movl	$5, %ecx
+
+	movl	$\outer_loop_count, %ecx
 	ANNOTATE_INTRA_FUNCTION_CALL
 	call	1f
 	jmp	5f
@@ -1542,29 +1538,54 @@ SYM_FUNC_START(clear_bhb_loop)
 	 * Shift instructions so that the RET is in the upper half of the
 	 * cacheline and don't take the slowpath to its_return_thunk.
 	 */
-	.skip 32 - (.Lret1 - 1f), 0xcc
+	.skip 32 - (.Lret1_\@ - 1f), 0xcc
 	ANNOTATE_INTRA_FUNCTION_CALL
 1:	call	2f
-.Lret1:	RET
+.Lret1_\@:
+	RET
 	.align 64, 0xcc
 	/*
-	 * As above shift instructions for RET at .Lret2 as well.
+	 * As above shift instructions for RET at .Lret2_\@ as well.
 	 *
-	 * This should be ideally be: .skip 32 - (.Lret2 - 2f), 0xcc
+	 * This should be ideally be: .skip 32 - (.Lret2_\@ - 2f), 0xcc
 	 * but some Clang versions (e.g. 18) don't like this.
 	 */
 	.skip 32 - 18, 0xcc
-2:	movl	$5, %eax
+2:	movl	$\inner_loop_count, %eax
 3:	jmp	4f
 	nop
 4:	sub	$1, %eax
 	jnz	3b
 	sub	$1, %ecx
 	jnz	1b
-.Lret2:	RET
+.Lret2_\@:
+	RET
 5:	lfence
+
 	pop	%rbp
 	RET
+.endm
+
+/*
+ * This should be used on parts prior to Alder Lake. Newer parts should use the
+ * BHI_DIS_S hardware control instead. If a pre-Alder Lake part is being
+ * virtualized on newer hardware the VMM should protect against BHI attacks by
+ * setting BHI_DIS_S for the guests.
+ */
+SYM_FUNC_START(clear_bhb_loop)
+	__CLEAR_BHB_LOOP 5, 5
 SYM_FUNC_END(clear_bhb_loop)
 EXPORT_SYMBOL_GPL(clear_bhb_loop)
 STACK_FRAME_NON_STANDARD(clear_bhb_loop)
+
+/*
+ * A longer version of clear_bhb_loop to ensure that the BHB is cleared on CPUs
+ * with larger branch history tables (i.e. Alder Lake and newer). BHI_DIS_S
+ * protects the kernel, but to mitigate the guest influence on the host
+ * userspace either IBPB or this sequence should be used. See VMSCAPE bug.
+ */
+SYM_FUNC_START(clear_bhb_long_loop)
+	__CLEAR_BHB_LOOP 12, 7
+SYM_FUNC_END(clear_bhb_long_loop)
+EXPORT_SYMBOL_GPL(clear_bhb_long_loop)
+STACK_FRAME_NON_STANDARD(clear_bhb_long_loop)
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 08ed5a2e46a5fd790bcb1b73feb6469518809c06..49707e563bdf71bdd05d3827f10dd2b8ac6bca2c 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -388,6 +388,9 @@ extern void write_ibpb(void);
 
 #ifdef CONFIG_X86_64
 extern void clear_bhb_loop(void);
+extern void clear_bhb_long_loop(void);
+#else
+static inline void clear_bhb_long_loop(void) {}
 #endif
 
 extern void (*x86_return_thunk)(void);

-- 
2.34.1



