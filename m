Return-Path: <kvm+bounces-69254-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kHQ2AbrleGl1twEAu9opvQ
	(envelope-from <kvm+bounces-69254-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 17:20:10 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 55F0797A65
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 17:20:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D65A7302C93E
	for <lists+kvm@lfdr.de>; Tue, 27 Jan 2026 16:19:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2B1360745;
	Tue, 27 Jan 2026 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jouJGLss"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A897535CBC6
	for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769530791; cv=none; b=oF49bjJakh/bTXmqHtpwvYd1M5VXt6VPv68CIv5D2FbewHoZoYDs6JSykT30FEL3s0ETNLg5KOp4Xk14jX0HLBnz/s8ePsiX/y3GruBx0w+qMCjkYPKgw886jkYv9ctAOI5sB4r9CnkBZHdjPu5oXGQj5HXrjFemVhPZrEI+Zrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769530791; c=relaxed/simple;
	bh=NZ8sJVTMfj1uSDSdtwUzaPIXmErQrSqZItfeH6uMR2s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=UCOdSAVEWL+nRFCzzSCLXt0ChQRZEqS1U+NO/f78ufOYON6s5MDl6U2WRoJZkg/nzpnN0/lRu4K66Jn8lWlJhAGSjOXPe65h06449DH8MYisuhNsF5ljmaM9tJcRZkYnFZjKIUiBa/hrnf69f76/UwZKtIU0MuUjyxVLP9trE1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jouJGLss; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c54e81eeab9so3697953a12.3
        for <kvm@vger.kernel.org>; Tue, 27 Jan 2026 08:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769530788; x=1770135588; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wJV3tQ5RkzE78cWWPGjlDH3M1YazyzDZqql1ApOPIKE=;
        b=jouJGLsskBu8b0BVR3dqJHiXhWm/x/925w3/FA9/p98aGYYDbkVLZskVnYT27RqD99
         OLmbfh6vfq2VA3sbFSYSapOUhIWlbSzLc/88TVwH80berngIBgQoSaaGIjZLXuU9EMxJ
         HITQJevlGeJTX0SpvixBrfkYh4bNfJ52XT+nqV0yGZ47eir7MyCdGnhTAt4lkjAyx9y/
         UmAqlfzAciqhqTxk7FEMfiLITSpk0DyNOAKJUbhqZ8IY1kw8Yvg+mJs4qsN51DSFZCPw
         uxRxZ4SsP25XEIssCy+qk8RBmVyCpMDlflK+y8YRC8xaHoUZWWoeb6RgM0LsqUR9iGI9
         dwFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769530788; x=1770135588;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wJV3tQ5RkzE78cWWPGjlDH3M1YazyzDZqql1ApOPIKE=;
        b=r4eGpxZDgzmeSJtHdBtPVHhPWI/O0Vl0xiexJHXjcJKoB9+wdgDPe6jxAJ1qWtiqEU
         fLKVl2GVfqqbCwoY7zGTwC7dEjn9hfnfQQ1pry5frygehtrr8/ty+30nm3tGnfavElc6
         0iTrpWB4YGlPznJq827NG+tN70mkX3pIXuUIvxJit7b+u+Bm1spFww8BnhtBFQx17gqb
         QE+eGb3SuipDMeLY9YovYOZMU7jA/mn+dBhv1Hk93x+W8ze5EONI8iVadA2zqUt5qvtO
         qAMIE8XWoXTPCi6hNYIPyvdR2JkpdhYVk97HE7Fk7WdW0oVjlQTo67XhfKhfLybchUbo
         tpyQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdAum5I+b+yfw0nNnNppbhlq2KGFgl6xgFavD5BOSHxxj3pRTArWvI2B21uBWBVAevX5Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YzlPFvQX3y0ajOUW83y3i+q2JpenmqYOr0RzZhLaQxcjBuIKH3s
	7S/CxVFx0sRT4SsqDXH0hOUyuc8eKgxHOypDqSjmpp0XnTa+6h1QaMMnesEPm1i1aIWVxlCBgfH
	Ok5iDGg==
X-Received: from pjbbr21.prod.google.com ([2002:a17:90b:f15:b0:352:ed03:9879])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ee88:b0:353:3f04:1b78
 with SMTP id 98e67ed59e1d1-353fecd096emr1487448a91.4.1769530788025; Tue, 27
 Jan 2026 08:19:48 -0800 (PST)
Date: Tue, 27 Jan 2026 08:19:46 -0800
In-Reply-To: <204d5234-9afd-4745-b40a-4355afad1e6b@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123221542.2498217-1-seanjc@google.com> <20260123221542.2498217-2-seanjc@google.com>
 <204d5234-9afd-4745-b40a-4355afad1e6b@intel.com>
Message-ID: <aXjlorS1fvItRe7g@google.com>
Subject: Re: [PATCH 1/3] KVM: x86: Finalize kvm_cpu_caps setup from {svm,vmx}_set_cpu_caps()
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Mathias Krause <minipli@grsecurity.net>, John Allen <john.allen@amd.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69254-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[10];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[grsecurity.net:email,amd.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: 55F0797A65
X-Rspamd-Action: no action

On Tue, Jan 27, 2026, Xiaoyao Li wrote:
> On 1/24/2026 6:15 AM, Sean Christopherson wrote:
> ...
> > +void kvm_finalize_cpu_caps(void)
> 
> It also finalizes the kvm_caps,

No, it just happens to update supported_xss as well.

> at least kvm_caps.supported_xss, which seems not consistent with the name.

I agree, but I don't see a clearly better option.  E.g. kvm_finalize_cpu_caps()
could be pedantic and only touch cpu_caps:

	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES) ||
	    (kvm_host.xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
		kvm_cpu_cap_clear(X86_FEATURE_IBT);
	}

but then we have duplicate logic, and the connection between supported_xss and
SHSTK/IBT is lost.

The only viable alternative I can think of would be to provide a dedicated
kvm_set_xss_caps() and then do:

	kvm_set_xss_caps();

	kvm_finalize_cpu_caps();

where kvm_finalize_cpu_caps() just clears kvm_is_configuring_cpu_caps.   Or I
suppose it could be:

	kvm_set_xss_caps();

	kvm_is_configuring_cpu_caps = false;

though I think I'd prefer to keep kvm_finalize_cpu_caps() and make it an inline.

Hmm, the more I look at that option, the more I like it?  It's kinda silly,
especially if we end up with a whole pile of helpers, e.g.

	kvm_set_xss_caps();

	kvm_set_blah_caps();

	kvm_set_loblaw_caps();

	kvm_finalize_cpu_caps();

But at least for now, I definitely don't hate it.

> Even more, just look at the function body, the name
> "kvm_finalize_supported_xss" seems to fit better while clearing SHSTK and
> IBT just the side effect of the finalized kvm_caps.supported_xss.

No, I definitely want kvm_finalize_cpu_caps() somewhere, so that we end up with
kvm_initialize_cpu_caps() + kvm_finalize_cpu_caps().  The function happens to
only modify CET caps and thus only touches supported_xss as a side effect, but
the intent is very much that it will serve as the one and only place where KVM
makes "final" adjustments that are common to VMX and SVM.

But as above, I'm not opposed to having both.  And it does provide a leaner diff
for the stable@ fix (though that's largely irrelevant since only 6.18 needs the
fix).

So this for patch 1 (not yet tested)?

From: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Jan 2026 08:14:27 -0800
Subject: [PATCH] KVM: x86: Configuring supported XSS from {svm,vmx}_set_cpu_caps()

Explicitly configure KVM's supported XSS as part of each vendor's setup
flow to fix a bug where clearing SHSTK and IBT in kvm_cpu_caps, e.g. due
to lack of CET XFEATURE support, makes kvm-intel.ko unloadable when nested
VMX is enabled, i.e. when nested=1.  The late clearing results in
nested_vmx_setup_{entry,exit}_ctls() clearing VM_{ENTRY,EXIT}_LOAD_CET_STATE
when nested_vmx_setup_ctls_msrs() runs during the CPU compatibility checks,
ultimately leading to a mismatched VMCS config due to the reference config
having the CET bits set, but every CPU's "local" config having the bits
cleared.

Note, kvm_caps.supported_{xcr0,xss} are unconditionally initialized by
kvm_x86_vendor_init(), before calling into vendor code, and not referenced
between ops->hardware_setup() and their current/old location.

Fixes: 69cc3e886582 ("KVM: x86: Add XSS support for CET_KERNEL and CET_USER")
Cc: stable@vger.kernel.org
Cc: Mathias Krause <minipli@grsecurity.net>
Cc: John Allen <john.allen@amd.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c |  2 ++
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     | 30 +++++++++++++++++-------------
 arch/x86/kvm/x86.h     |  2 ++
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7803d2781144..c00a696dacfc 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5387,6 +5387,8 @@ static __init void svm_set_cpu_caps(void)
 	 */
 	kvm_cpu_cap_clear(X86_FEATURE_BUS_LOCK_DETECT);
 	kvm_cpu_cap_clear(X86_FEATURE_MSR_IMM);
+
+	kvm_setup_xss_caps();
 }
 
 static __init int svm_hardware_setup(void)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 27acafd03381..9f85c3829890 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8230,6 +8230,8 @@ static __init void vmx_set_cpu_caps(void)
 		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
 		kvm_cpu_cap_clear(X86_FEATURE_IBT);
 	}
+
+	kvm_setup_xss_caps();
 }
 
 static bool vmx_is_io_intercepted(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8acfdfc583a1..cac1d6a67b49 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9965,6 +9965,23 @@ static struct notifier_block pvclock_gtod_notifier = {
 };
 #endif
 
+void kvm_setup_xss_caps(void)
+{
+	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
+		kvm_caps.supported_xss = 0;
+
+	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
+	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+
+	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
+		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
+		kvm_cpu_cap_clear(X86_FEATURE_IBT);
+		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
+	}
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_setup_xss_caps);
+
 static inline void kvm_ops_update(struct kvm_x86_init_ops *ops)
 {
 	memcpy(&kvm_x86_ops, ops->runtime_ops, sizeof(kvm_x86_ops));
@@ -10138,19 +10155,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops *ops)
 	if (!tdp_enabled)
 		kvm_caps.supported_quirks &= ~KVM_X86_QUIRK_IGNORE_GUEST_PAT;
 
-	if (!kvm_cpu_cap_has(X86_FEATURE_XSAVES))
-		kvm_caps.supported_xss = 0;
-
-	if (!kvm_cpu_cap_has(X86_FEATURE_SHSTK) &&
-	    !kvm_cpu_cap_has(X86_FEATURE_IBT))
-		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
-
-	if ((kvm_caps.supported_xss & XFEATURE_MASK_CET_ALL) != XFEATURE_MASK_CET_ALL) {
-		kvm_cpu_cap_clear(X86_FEATURE_SHSTK);
-		kvm_cpu_cap_clear(X86_FEATURE_IBT);
-		kvm_caps.supported_xss &= ~XFEATURE_MASK_CET_ALL;
-	}
-
 	if (kvm_caps.has_tsc_control) {
 		/*
 		 * Make sure the user can only configure tsc_khz values that
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 70e81f008030..94d4f07aaaa0 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -483,6 +483,8 @@ extern struct kvm_host_values kvm_host;
 extern bool enable_pmu;
 extern bool enable_mediated_pmu;
 
+void kvm_setup_xss_caps(void);
+
 /*
  * Get a filtered version of KVM's supported XCR0 that strips out dynamic
  * features for which the current process doesn't (yet) have permission to use.

base-commit: e81f7c908e1664233974b9f20beead78cde6343a
--

