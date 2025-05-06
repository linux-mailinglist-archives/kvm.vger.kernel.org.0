Return-Path: <kvm+bounces-45585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E970AAC07E
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 11:55:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98C553A9591
	for <lists+kvm@lfdr.de>; Tue,  6 May 2025 09:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04BFA278742;
	Tue,  6 May 2025 09:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="q00Px0TM";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="RCYt3rF2"
X-Original-To: kvm@vger.kernel.org
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245A227816A;
	Tue,  6 May 2025 09:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746525099; cv=none; b=eTqgAfE9TWXyRV2QZqvAny3nSurv6srtykvRJalpU7HLqCrdnu2mEkNKc5hgJytau3GTkLOquYkrhN7Hfi0Y5zYzJy5GX1jzo5bO6hBaglV+lljy/uvqhyh4eSZtTEwR58mk3CtQ4zvDt0GPaE16w9KGO3wXGs9wmGEAXndim/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746525099; c=relaxed/simple;
	bh=3aNJdJlHY9MwIVjR0g1nKhpOMC2dFkuQxHnlrG3Fukg=;
	h=Date:From:To:Subject:Cc:In-Reply-To:References:MIME-Version:
	 Message-ID:Content-Type; b=ZdPnAXt/LcYCmv1oW+AeBHZhvu9DQljsH/f7flppc1jwKSdEF08EKINYonaQdRH+T4J7iZWg/fh2qimoTQZnNxMboyybAK5ErnnsIKGNYElqzi224RoVfG3uIaovMrEFvIn7a6Kg48Fhst+0iANemNlKY7plCCx9LPvB522+eoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=q00Px0TM; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=RCYt3rF2; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Date: Tue, 06 May 2025 09:51:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1746525095;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nq00WmAtUDDYTEujn0CNzFjWEOq4Ukw9dSIBYkIo5L4=;
	b=q00Px0TMUqHMlkjos68f3S9s5ssd3qn4afJVpzdvY2aqOXi+7bxAhV0D/AS5+5tQ6x0yA/
	t5niHB7iiUjXinmq0xcvkrMWLi3uTxuBGbtGIlc0z7aT4BC2HhVK+WX3Kmvc9bEpqNp92G
	TO5l+7k7lM9WxjQRLX8ByhdQLzAVK+odvzN3E5iNpQlITuelQqlcWWFltAf3QBom7unDzs
	RZQ8dnh1dMXfQOE3ujuqJWGKR+KG5NNeKz9fK3Wm7URaUZAOT4SquzTaj90N2eNQM+qdA+
	bPtFsrnbCcDDB92E1mJ8t24jensuK53x5rSYMpdhhN/zv+k3hrVUQkGWcVB/4Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1746525095;
	h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nq00WmAtUDDYTEujn0CNzFjWEOq4Ukw9dSIBYkIo5L4=;
	b=RCYt3rF2hpku9cW5EiT7clhkC775tkxbkU2gN5l9cRtOoFYiJw+jitbrRAwYYg1t1VsGqb
	ROBtmqvcD0390pDQ==
From: "tip-bot2 for Sean Christopherson" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To: linux-tip-commits@vger.kernel.org
Subject: [tip: x86/fpu] x86/fpu/xstate: Always preserve non-user
 xfeatures/flags in __state_perm
Cc: Sean Christopherson <seanjc@google.com>,
 Yang Weijiang <weijiang.yang@intel.com>, Chao Gao <chao.gao@intel.com>,
 Ingo Molnar <mingo@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 "Chang S. Bae" <chang.seok.bae@intel.com>,
 Dave Hansen <dave.hansen@intel.com>, Andy Lutomirski <luto@kernel.org>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 John Allen <john.allen@amd.com>,
 Linus Torvalds <torvalds@linux-foundation.org>,
 Mitchell Levy <levymitchell0@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Samuel Holland <samuel.holland@sifive.com>,
 Sohil Mehta <sohil.mehta@intel.com>,
 Vignesh Balasubramanian <vigbalas@amd.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Xin Li <xin3.li@intel.com>,
 kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20250506093740.2864458-2-chao.gao@intel.com>
References: <20250506093740.2864458-2-chao.gao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <174652509391.406.2586983182542897870.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe:
 Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Precedence: bulk
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The following commit has been merged into the x86/fpu branch of tip:

Commit-ID:     d8414603b29f25191fcceafb72e74b67ac2e92b1
Gitweb:        https://git.kernel.org/tip/d8414603b29f25191fcceafb72e74b67ac2e92b1
Author:        Sean Christopherson <seanjc@google.com>
AuthorDate:    Tue, 06 May 2025 17:36:06 +08:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Tue, 06 May 2025 11:42:04 +02:00

x86/fpu/xstate: Always preserve non-user xfeatures/flags in __state_perm

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

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: Chang S. Bae <chang.seok.bae@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: John Allen <john.allen@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mitchell Levy <levymitchell0@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Samuel Holland <samuel.holland@sifive.com>
Cc: Sohil Mehta <sohil.mehta@intel.com>
Cc: Vignesh Balasubramanian <vigbalas@amd.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xin Li <xin3.li@intel.com>
Cc: kvm@vger.kernel.org
Link: https://lore.kernel.org/all/ZTqgzZl-reO1m01I@google.com
Link: https://lore.kernel.org/r/20250506093740.2864458-2-chao.gao@intel.com
---
 arch/x86/include/asm/fpu/types.h |  8 +++++---
 arch/x86/kernel/fpu/xstate.c     | 18 +++++++++++-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/fpu/types.h b/arch/x86/include/asm/fpu/types.h
index 97310df..e64db0e 100644
--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -416,9 +416,11 @@ struct fpu_state_perm {
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
index 8b14c9d..1c8410b 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1656,16 +1656,20 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
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

