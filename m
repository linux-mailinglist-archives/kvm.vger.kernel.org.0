Return-Path: <kvm+bounces-5966-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8251C829210
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 02:27:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3DB01F26BB9
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 01:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D23F64A3E;
	Wed, 10 Jan 2024 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GvAwooCE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95EEB33F9
	for <kvm@vger.kernel.org>; Wed, 10 Jan 2024 01:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-daee86e2d70so3339441276.0
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 17:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704850029; x=1705454829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=IIQammAHhw1ngHO6ANyDTfr+sZcY4cd5zo+XWlGta08=;
        b=GvAwooCEBsnM+KrjlD3OO3b/BonedW9mK/7R/QPo+0Atx0zpi/cZ/n32NEKbXx6id+
         QAl8APSSF5B9opwNEGgdAPC+Wk3/KyLqIC2b02I9ep7isSxIHARNaD9asU20tIfN43aA
         fSpD5xm7fWEsyT52kRxjk8VZFuQAHbJjXEA2tqgZceoORJVsMYayzktc0TmOO/bSkdGl
         rEjQKJ+NdZCgDHj2phpA/3eVUQPRpFGk8tIhZ9tOfotZXk3GX8+8tTVX1ZCUWhde7ft4
         kvnX5HmO2yrQeFLHdkh0ux7ZOYjbZPFR4z+Njri3q+/0ZkYO34OW9lJBT09MCO0zDG92
         Kd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704850029; x=1705454829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IIQammAHhw1ngHO6ANyDTfr+sZcY4cd5zo+XWlGta08=;
        b=XBwPnbwvw9FLEKN5rxBsz6LqoS164s+xWqdEuYK0j2uRdZOFqUmwzDR2A1WZXOYlgT
         IuhQHb0Xg8Lw9uAgDEPocXVl1ap1evesgyaaKbbD1knLG5e+kQ1i6FVDEBbfM82Acv/j
         CmJJTu86VFuFt756YUZam8EpnzmTeZ0DEudbU9szSbeI3kjd0/BeZRMEi1ib0PJKuNFl
         b0im1fyhPQaTzFZdkOwW8LbVJp2xspY6knhE3ZTKFni6Zbz2NSlIs/GXc2fTOQCq/aLj
         vayl7vGA4DHxLNCuZgQ4CbBEwQo4YD056fUgIt6vZpqvIM2L4uxZOoGzZVdGjnRbmR0E
         vmjg==
X-Gm-Message-State: AOJu0YwG+yzdgLrXRQUeodGoOWF6+MxcigN8SKgLGLtZnr+TYT+aqDvd
	jsi7ZBideOZCWZWHYgn2Kitg2QMoUcv6bBO/NA==
X-Google-Smtp-Source: AGHT+IG7zLpYOzJQoiOqhFIghEXci1Ti8H3tTaRAJgjun4AugcfabivAhkw/qGFXuhcVktgi7U6MJ1WANKU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:136d:b0:dbd:3fff:7c2a with SMTP id
 bt13-20020a056902136d00b00dbd3fff7c2amr7907ybb.3.1704850029694; Tue, 09 Jan
 2024 17:27:09 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 17:27:00 -0800
In-Reply-To: <20240110012705.506918-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240110012705.506918-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240110012705.506918-2-seanjc@google.com>
Subject: [PATCH 1/6] KVM: x86: Plumb "force_immediate_exit" into kvm_entry() tracepoint
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Annotate the kvm_entry() tracepoint with "immediate exit" when KVM is
forcing a VM-Exit immediately after VM-Enter, e.g. when KVM wants to
inject an event but needs to first complete some other operation.
Knowing that KVM is (or isn't) forcing an exit is useful information when
debugging issues related to event injection.

Suggested-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/svm/svm.c          | 5 +++--
 arch/x86/kvm/trace.h            | 9 ++++++---
 arch/x86/kvm/vmx/vmx.c          | 4 ++--
 arch/x86/kvm/x86.c              | 2 +-
 5 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7bc1daf68741..9c90664ef9fb 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1663,7 +1663,8 @@ struct kvm_x86_ops {
 	void (*flush_tlb_guest)(struct kvm_vcpu *vcpu);
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
-	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
+	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu,
+						  bool force_immediate_exit);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2171b0cda8d4..f5f3301d2a01 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4115,12 +4115,13 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu, bool spec_ctrl_in
 	guest_state_exit_irqoff();
 }
 
-static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
+static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
+					  bool force_immediate_exit)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool spec_ctrl_intercepted = msr_write_intercepted(vcpu, MSR_IA32_SPEC_CTRL);
 
-	trace_kvm_entry(vcpu);
+	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
 	svm->vmcb->save.rsp = vcpu->arch.regs[VCPU_REGS_RSP];
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index 83843379813e..88659de4d2a7 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -15,20 +15,23 @@
  * Tracepoint for guest mode entry.
  */
 TRACE_EVENT(kvm_entry,
-	TP_PROTO(struct kvm_vcpu *vcpu),
-	TP_ARGS(vcpu),
+	TP_PROTO(struct kvm_vcpu *vcpu, bool force_immediate_exit),
+	TP_ARGS(vcpu, force_immediate_exit),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	vcpu_id		)
 		__field(	unsigned long,	rip		)
+		__field(	bool,		immediate_exit	)
 	),
 
 	TP_fast_assign(
 		__entry->vcpu_id        = vcpu->vcpu_id;
 		__entry->rip		= kvm_rip_read(vcpu);
+		__entry->immediate_exit	= force_immediate_exit;
 	),
 
-	TP_printk("vcpu %u, rip 0x%lx", __entry->vcpu_id, __entry->rip)
+	TP_printk("vcpu %u, rip 0x%lx%s", __entry->vcpu_id, __entry->rip,
+		  __entry->immediate_exit ? "[immediate exit]" : "")
 );
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d21f55f323ea..51d0f3985463 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7268,7 +7268,7 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	guest_state_exit_irqoff();
 }
 
-static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
+static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	unsigned long cr3, cr4;
@@ -7295,7 +7295,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		return EXIT_FASTPATH_NONE;
 	}
 
-	trace_kvm_entry(vcpu);
+	trace_kvm_entry(vcpu, force_immediate_exit);
 
 	if (vmx->ple_window_dirty) {
 		vmx->ple_window_dirty = false;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 27e23714e960..e4523ca3dedf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10962,7 +10962,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		WARN_ON_ONCE((kvm_vcpu_apicv_activated(vcpu) != kvm_vcpu_apicv_active(vcpu)) &&
 			     (kvm_get_apic_mode(vcpu) != LAPIC_MODE_DISABLED));
 
-		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
+		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu, req_immediate_exit);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
-- 
2.43.0.472.g3155946c3a-goog


