Return-Path: <kvm+bounces-43059-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 76F2EA83AEF
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:24:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F32AD7ADAA1
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E1E521129C;
	Thu, 10 Apr 2025 07:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MUv+aXEj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15526208989;
	Thu, 10 Apr 2025 07:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744269745; cv=none; b=ZGQcEsRv7CHbELojfv3ycUoyIWP+FbqyH2IxiZo9/UsDG654nI7zf1glii1rd8g/ND+faN1DAGLw58ehtKwR8E+ia7S72wIlE0G+HOaqkob9hALLzp0BfzUrC6s9MNE+jpZ0rwcNbPUQdRNOAI3YA12Q6Pitx05bOUmO0qJSLh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744269745; c=relaxed/simple;
	bh=x75cG+zq9kKplLQMO26hjWO7/9o8dSy+vB9he+XJNfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RV1rP2CVfDaj2vLnQDLZgxEhkOuMKByhVlLWxTERGyHxiUBITRB6gOz9COdbYlI3GZJPW2jJu0eSLxNsWJERKkQuC+J2R0WJAlCdcvObmQIx5J84KhuCrznZBS/rxUMPmucA3oiRVQD0RqLCRt7vFWrTVw87HMxiMTYpHZ2zuSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MUv+aXEj; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744269741; x=1775805741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x75cG+zq9kKplLQMO26hjWO7/9o8dSy+vB9he+XJNfQ=;
  b=MUv+aXEjpEW6JOM1Zfu2QuT3c+Y8drzTDPJsqJlZvuohidrzMSm1N+Xx
   IcQHKMEeodh/gR4v3wQevl408aFGNjeG5qzFc8FJ+PHrkm4ChhUipT5A2
   eJS3SC+E6DlbiLF3wKX9iweBVhMQmNFWy/BPqnI/dVr+U0n6nd5A2RquG
   rllnCzGTLw1iLCEFVuiFijWDCnhRJKVfJgWQZu4yYSGYlozwv8CJ3oJJz
   LI7mwxknG9dod01kmraHcNon2rGdTidLxJajWPB4NrXK5QjidhbIFa64n
   2vBKfq/A8JkF3Y56rsbPS2A6Yg2p5H/FG+hu5w1ZEfss+Zpzp5/ev2UeE
   Q==;
X-CSE-ConnectionGUID: FcEaZsXWRKCYSUQ79EvcFw==
X-CSE-MsgGUID: OB2i6Qb+S62DqPOLJNaSgQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56439280"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56439280"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:21 -0700
X-CSE-ConnectionGUID: FtdSiW5ISnut5H2OZgeVzg==
X-CSE-MsgGUID: kS6gRNAwR22t/AODvzyTaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128778096"
Received: from spr.sh.intel.com ([10.239.53.19])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:22:15 -0700
From: Chao Gao <chao.gao@intel.com>
To: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	tglx@linutronix.de,
	dave.hansen@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: peterz@infradead.org,
	rick.p.edgecombe@intel.com,
	weijiang.yang@intel.com,
	john.allen@amd.com,
	bp@alien8.de,
	chang.seok.bae@intel.com,
	xin3.li@intel.com,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Mitchell Levy <levymitchell0@gmail.com>,
	Vignesh Balasubramanian <vigbalas@amd.com>,
	Aruna Ramakrishna <aruna.ramakrishna@oracle.com>
Subject: [PATCH v5 1/7] x86/fpu/xstate: Always preserve non-user xfeatures/flags in __state_perm
Date: Thu, 10 Apr 2025 15:24:41 +0800
Message-ID: <20250410072605.2358393-2-chao.gao@intel.com>
X-Mailer: git-send-email 2.46.1
In-Reply-To: <20250410072605.2358393-1-chao.gao@intel.com>
References: <20250410072605.2358393-1-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

When granting userspace or a KVM guest access to an xfeature, preserve the
entity's existing supervisor and software-defined permissions as tracked
by __state_perm, i.e. use __state_perm to track *all* permissions even
though all supported supervisor xfeatures are granted to all FPUs and
FPU_GUEST_PERM_LOCKED disallows changing permissions.

Effectively clobbering supervisor permissions results in inconsistent
behavior, as xstate_get_group_perm() will report supervisor features for
process that do NOT request access to dynamic user xfeatures, whereas any
and all supervisor features will be absent from the set of permissions for
any process that is granted access to one or more dynamic xfeatures (which
right now means AMX).

The inconsistency isn't problematic because fpu_xstate_prctl() already
strips out everything except user xfeatures:

        case ARCH_GET_XCOMP_PERM:
                /*
                 * Lockless snapshot as it can also change right after the
                 * dropping the lock.
                 */
                permitted = xstate_get_host_group_perm();
                permitted &= XFEATURE_MASK_USER_SUPPORTED;
                return put_user(permitted, uptr);

        case ARCH_GET_XCOMP_GUEST_PERM:
                permitted = xstate_get_guest_group_perm();
                permitted &= XFEATURE_MASK_USER_SUPPORTED;
                return put_user(permitted, uptr);

and similarly KVM doesn't apply the __state_perm to supervisor states
(kvm_get_filtered_xcr0() incorporates xstate_get_guest_group_perm()):

        case 0xd: {
                u64 permitted_xcr0 = kvm_get_filtered_xcr0();
                u64 permitted_xss = kvm_caps.supported_xss;

But if KVM in particular were to ever change, dropping supervisor
permissions would result in subtle bugs in KVM's reporting of supported
CPUID settings.  And the above behavior also means that having supervisor
xfeatures in __state_perm is correctly handled by all users.

Dropping supervisor permissions also creates another landmine for KVM.  If
more dynamic user xfeatures are ever added, requesting access to multiple
xfeatures in separate ARCH_REQ_XCOMP_GUEST_PERM calls will result in the
second invocation of __xstate_request_perm() computing the wrong ksize, as
as the mask passed to xstate_calculate_size() would not contain *any*
supervisor features.

Commit 781c64bfcb73 ("x86/fpu/xstate: Handle supervisor states in XSTATE
permissions") fudged around the size issue for userspace FPUs, but for
reasons unknown skipped guest FPUs.  Lack of a fix for KVM "works" only
because KVM doesn't yet support virtualizing features that have supervisor
xfeatures, i.e. as of today, KVM guest FPUs will never need the relevant
xfeatures.

Simply extending the hack-a-fix for guests would temporarily solve the
ksize issue, but wouldn't address the inconsistency issue and would leave
another lurking pitfall for KVM.  KVM support for virtualizing CET will
likely add CET_KERNEL as a guest-only xfeature, i.e. CET_KERNEL will not
be set in xfeatures_mask_supervisor() and would again be dropped when
granting access to dynamic xfeatures.

Note, the existing clobbering behavior is rather subtle.  The @permitted
parameter to __xstate_request_perm() comes from:

	permitted = xstate_get_group_perm(guest);

which is either fpu->guest_perm.__state_perm or fpu->perm.__state_perm,
where __state_perm is initialized to:

        fpu->perm.__state_perm          = fpu_kernel_cfg.default_features;

and copied to the guest side of things:

	/* Same defaults for guests */
	fpu->guest_perm = fpu->perm;

fpu_kernel_cfg.default_features contains everything except the dynamic
xfeatures, i.e. everything except XFEATURE_MASK_XTILE_DATA:

        fpu_kernel_cfg.default_features = fpu_kernel_cfg.max_features;
        fpu_kernel_cfg.default_features &= ~XFEATURE_MASK_USER_DYNAMIC;

When __xstate_request_perm() restricts the local "mask" variable to
compute the user state size:

	mask &= XFEATURE_MASK_USER_SUPPORTED;
	usize = xstate_calculate_size(mask, false);

it subtly overwrites the target __state_perm with "mask" containing only
user xfeatures:

	perm = guest ? &fpu->guest_perm : &fpu->perm;
	/* Pairs with the READ_ONCE() in xstate_get_group_perm() */
	WRITE_ONCE(perm->__state_perm, mask);

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Weijiang Yang <weijiang.yang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: John Allen <john.allen@amd.com>
Cc: kvm@vger.kernel.org
Link: https://lore.kernel.org/all/ZTqgzZl-reO1m01I@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
---
 arch/x86/include/asm/fpu/types.h |  8 +++++---
 arch/x86/kernel/fpu/xstate.c     | 18 +++++++++++-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index de16862bf230..46cc263f9f4f 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -407,9 +407,11 @@ struct fpu_state_perm {
 	/*
 	 * @__state_perm:
 	 *
-	 * This bitmap indicates the permission for state components, which
-	 * are available to a thread group. The permission prctl() sets the
-	 * enabled state bits in thread_group_leader()->thread.fpu.
+	 * This bitmap indicates the permission for state components
+	 * available to a thread group, including both user and supervisor
+	 * components and software-defined bits like FPU_GUEST_PERM_LOCKED.
+	 * The permission prctl() sets the enabled state bits in
+	 * thread_group_leader()->thread.fpu.
 	 *
 	 * All run time operations use the per thread information in the
 	 * currently active fpu.fpstate which contains the xfeature masks
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 46c45e2f2a5a..6f10f5490022 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1642,16 +1642,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
 	if ((permitted & requested) == requested)
 		return 0;
 
-	/* Calculate the resulting kernel state size */
+	/*
+	 * Calculate the resulting kernel state size.  Note, @permitted also
+	 * contains supervisor xfeatures even though supervisor are always
+	 * permitted for kernel and guest FPUs, and never permitted for user
+	 * FPUs.
+	 */
 	mask = permitted | requested;
-	/* Take supervisor states into account on the host */
-	if (!guest)
-		mask |= xfeatures_mask_supervisor();
 	ksize = xstate_calculate_size(mask, compacted);
 
-	/* Calculate the resulting user state size */
-	mask &= XFEATURE_MASK_USER_SUPPORTED;
-	usize = xstate_calculate_size(mask, false);
+	/*
+	 * Calculate the resulting user state size.  Take care not to clobber
+	 * the supervisor xfeatures in the new mask!
+	 */
+	usize = xstate_calculate_size(mask & XFEATURE_MASK_USER_SUPPORTED, false);
 
 	if (!guest) {
 		ret = validate_sigaltstack(usize);
-- 
2.46.1


